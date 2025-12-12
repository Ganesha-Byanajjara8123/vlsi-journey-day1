`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12.12.2025 18:34:21
// Design Name: 
// Module Name: top_day12
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


module top_day12 (
    input clk,
    input rstn,

    output [7:0] pc,
    output [19:0] instr_if,
    output [19:0] instr_id,
    output [3:0] opcode_id,
    output [7:0] A_id,
    output [7:0] B_id,
    output [3:0] opcode_ex,
    output [7:0] A_ex,
    output [7:0] B_ex,
    output [7:0] alu_out
);

    // -------- IF Stage --------
    if_stage IF (
        .clk(clk),
        .rstn(rstn),
        .stall(1'b0),
        .pc_out(pc),
        .instr_out(instr_if)
    );

    // -------- IF/ID pipe --------
    pipe_if_id IFID (
        .clk(clk),
        .rstn(rstn),
        .stall(1'b0),
        .pc_in(pc),
        .instr_in(instr_if),
        .pc_out(),  
        .instr_out(instr_id)
    );

    // -------- ID Stage (combinational decoder) --------
    // id_stage expects port 'instr' (combinational), not clk/rst/ instr_in
    id_stage ID (
        .instr(instr_id),
        .opcode(opcode_id),
        .A(A_id),
        .B(B_id)
    );

    // -------- ID/EX pipe --------
    pipe_id_ex IDEX (
        .clk(clk),
        .rstn(rstn),
        .stall(1'b0),
        .opcode_in(opcode_id),
        .A_in(A_id),
        .B_in(B_id),
        .opcode_out(opcode_ex),
        .A_out(A_ex),
        .B_out(B_ex)
    );

    // -------- EX (ALU) stage --------
    alu ALU (
        .A(A_ex),
        .B(B_ex),
        .opcode(opcode_ex),
        .result(alu_out)
    );

endmodule

