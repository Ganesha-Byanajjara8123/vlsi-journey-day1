`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 15.12.2025 09:32:49
// Design Name: 
// Module Name: top_day15
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module top_day15 (
    input  wire clk,
    input  wire rstn,

    // visible architectural outputs
    output wire [7:0] pc,
    output wire [7:0] alu_out,

    // ===== DAY-15 DEBUG / VERIFICATION SIGNALS =====
    output wire        pc_write,
    output wire        if_id_write,
    output wire        id_ex_flush,
    output wire [1:0]  forwardA,
    output wire [1:0]  forwardB
);

    // ---------------- IF ----------------
    wire [19:0] instr_if;

 if_stage_day15 IF (
    .clk(clk),
    .rstn(rstn),
    .stall(1'b0),
    .pc_write(pc_write),
    .pc(pc),
    .instr(instr_if)
);


    // ---------------- IF / ID ----------------
    wire [19:0] instr_id;

    pipe_if_id IFID (
        .clk(clk),
        .rstn(rstn),
        .write_en(if_id_write),
        .pc_in(pc),
        .instr_in(instr_if),
        //.pc(pc),
        .instr_out(instr_id)
    );

    // ---------------- ID ----------------
    wire [3:0] opcode_id;
    wire [2:0] rs1_id, rs2_id, rd_id;
    wire [7:0] rf_a, rf_b;

    assign opcode_id = instr_id[19:16];
    assign rs1_id    = instr_id[15:13];
    assign rs2_id    = instr_id[12:10];
    assign rd_id     = instr_id[9:7];

    regfile RF (
        .clk(clk),
        .rstn(rstn),
        .we(wb_regwrite),
        .ra1(rs1_id),
        .ra2(rs2_id),
        .wa(wb_rd),
        .wd(wb_data),
        .rd1(rf_a),
        .rd2(rf_b)
    );

    // ---------------- ID / EX ----------------
    wire [3:0] opcode_ex;
    wire [7:0] A_ex, B_ex;
    wire [2:0] rd_ex;

    pipe_id_ex IDEX (
        .clk(clk),
        .rstn(rstn),
        .stall(1'b0),
        .flush(id_ex_flush),
        .opcode_in(opcode_id),
        .A_in(rf_a),
        .B_in(rf_b),
        .rd_in(rd_id),
        .opcode_out(opcode_ex),
        .A_out(A_ex),
        .B_out(B_ex),
        .rd_out(rd_ex)
    );

    // ---------------- EX ----------------
    alu ALU (
        .A(A_ex),
        .B(B_ex),
        .opcode(opcode_ex),
        .result(alu_out)
    );

    // ---------------- EX / WB ----------------
    wire        wb_regwrite;
    wire [2:0]  wb_rd;
    wire [7:0]  wb_data;

    pipe_ex_wb EXWB (
        .clk(clk),
        .rstn(rstn),
        .regwrite_in(1'b1),
        .rd_in(rd_ex),
        .alu_in(alu_out),
        .regwrite_out(wb_regwrite),
        .rd_out(wb_rd),
        .alu_out(wb_data)
    );

    // ---------------- Hazard Unit ----------------
    hazard_unit HU (
        .id_ex_memread(1'b1),   // force hazard for demo
        .id_ex_rd(rd_ex),
        .if_id_rs1(rs1_id),
        .if_id_rs2(rs2_id),
        .pc_write(pc_write),
        .if_id_write(if_id_write),
        .id_ex_flush(id_ex_flush)
    );

    // ---------------- Forwarding Unit ----------------
    forwarding_unit FU (
        .ex_mem_regwrite(wb_regwrite),
        .mem_wb_regwrite(wb_regwrite),
        .ex_mem_rd(wb_rd),
        .mem_wb_rd(wb_rd),
        .id_ex_rs(rs1_id),
        .id_ex_rt(rs2_id),
        .forwardA(forwardA),
        .forwardB(forwardB)
    );

endmodule

