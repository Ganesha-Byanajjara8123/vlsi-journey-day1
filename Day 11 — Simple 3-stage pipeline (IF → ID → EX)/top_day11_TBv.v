`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12.12.2025 18:35:15
// Design Name: 
// Module Name: top_day12_tb
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

module top_day12_tb;

    reg clk, rstn;

    wire [7:0] pc;
    wire [19:0] instr_if, instr_id;
    wire [3:0] opcode_id, opcode_ex;
    wire [7:0] A_id, B_id, A_ex, B_ex, alu_out;

    top_day12 DUT (
        .clk(clk),
        .rstn(rstn),
        .pc(pc),
        .instr_if(instr_if),
        .instr_id(instr_id),
        .opcode_id(opcode_id),
        .A_id(A_id),
        .B_id(B_id),
        .opcode_ex(opcode_ex),
        .A_ex(A_ex),
        .B_ex(B_ex),
        .alu_out(alu_out)
    );

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        rstn = 0;
        #20 rstn = 1;
        #400 $finish;
    end

endmodule


