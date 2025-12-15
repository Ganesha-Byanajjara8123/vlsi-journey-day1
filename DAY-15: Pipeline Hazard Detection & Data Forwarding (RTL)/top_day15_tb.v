`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 15.12.2025 09:33:26
// Design Name: 
// Module Name: top_day15_tb
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


module top_day15_tb;

    reg clk;
    reg rstn;

    wire [7:0] pc;
    wire [7:0] alu_out;

    wire pc_write;
    wire if_id_write;
    wire id_ex_flush;
    wire [1:0] forwardA;
    wire [1:0] forwardB;

    top_day15 DUT (
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

    // clock
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        rstn = 0;
        #20 rstn = 1;

        #300;
        $display("PC=%0d ALU=%h pc_write=%b if_id_write=%b flush=%b fA=%b fB=%b",
                  pc, alu_out, pc_write, if_id_write, id_ex_flush, forwardA, forwardB);
        $finish;
    end

endmodule



