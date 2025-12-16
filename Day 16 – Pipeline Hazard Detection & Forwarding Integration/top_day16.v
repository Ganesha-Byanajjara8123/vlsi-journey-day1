`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 16.12.2025 11:46:45
// Design Name: 
// Module Name: top_day16
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

module top_day16 (
    input  wire clk,
    input  wire rstn,

    output wire [7:0] pc,
    output wire [7:0] alu_out,

    output wire        pc_write,
    output wire        if_id_write,
    output wire        id_ex_flush,
    output wire [1:0]  forwardA,
    output wire [1:0]  forwardB
);

    // IF
    wire [19:0] instr_if;
    if_stage_day16 IF (
        .clk(clk),
        .rstn(rstn),
        .pc_write(pc_write),
        .pc(pc),
        .instr(instr_if)
    );

    // IF/ID
    wire [19:0] instr_id;
    pipe_if_id IFID (
        .clk(clk),
        .rstn(rstn),
        .write_en(if_id_write),
        .instr_in(instr_if),
        .instr_out(instr_id)
    );

    // ID
    wire [2:0] rs1 = instr_id[15:13];
    wire [2:0] rs2 = instr_id[12:10];
    wire [2:0] rd  = instr_id[9:7];
    wire [3:0] op  = instr_id[19:16];
    wire [7:0] A, B;

    regfile RF (
        .clk(clk),
        .rstn(rstn),
        .we(1'b0),
        .ra1(rs1),
        .ra2(rs2),
        .wa(3'b0),
        .wd(8'b0),
        .rd1(A),
        .rd2(B)
    );

    // ID/EX
    wire [2:0] rs_ex, rt_ex, rd_ex;
    wire [7:0] A_ex, B_ex;
    wire [3:0] op_ex;

    pipe_id_ex IDEX (
        .clk(clk),
        .rstn(rstn),
        .flush(id_ex_flush),
        .opcode_in(op),
        .A_in(A),
        .B_in(B),
        .rs_in(rs1),
        .rt_in(rs2),
        .rd_in(rd),
        .opcode_out(op_ex),
        .A_out(A_ex),
        .B_out(B_ex),
        .rs_out(rs_ex),
        .rt_out(rt_ex),
        .rd_out(rd_ex)
    );

    // HAZARD (FORCED)
    hazard_unit HU (
        .id_ex_memread(1'b1), // FORCE hazard for demo
        .id_ex_rd(rd_ex),
        .if_id_rs1(rs1),
        .if_id_rs2(rs2),
        .pc_write(pc_write),
        .if_id_write(if_id_write),
        .id_ex_flush(id_ex_flush)
    );

    // FORWARDING (NO WB STAGE USED HERE → stays 0)
    assign forwardA = 2'b00;
    assign forwardB = 2'b00;

    // EX
    alu ALU (
        .A(A_ex),
        .B(B_ex),
        .opcode(op_ex),
        .result(alu_out)
    );

endmodule


