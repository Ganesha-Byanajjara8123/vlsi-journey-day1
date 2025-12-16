`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 16.12.2025 11:50:05
// Design Name: 
// Module Name: top_day16_tb
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

module top_day16_tb;

    reg clk;
    reg rstn;

    wire [7:0] pc;
    wire [7:0] alu_out;
    wire pc_write, if_id_write, id_ex_flush;
    wire [1:0] forwardA, forwardB;

    top_day16 DUT (
        .clk(clk),
        .rstn(rstn),
        .pc(pc),
        .alu_out(alu_out),
        .pc_write(pc_write),
        .if_id_write(if_id_write),
        .id_ex_flush(id_ex_flush),
        .forwardA(forwardA),
        .forwardB(forwardB)
    );

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        rstn = 0;
        #20 rstn = 1;
        #300 $finish;
    end

endmodule

