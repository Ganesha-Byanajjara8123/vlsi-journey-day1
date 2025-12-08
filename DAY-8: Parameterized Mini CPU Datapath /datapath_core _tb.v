`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08.12.2025 18:54:22
// Design Name: 
// Module Name: datapath_core_TB
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


module datapath_core_TB;

    parameter WIDTH = 8;

    reg  [WIDTH-1:0] A, B;
    reg  [3:0] Op;
    wire [WIDTH-1:0] Result;
    wire Zero, Neg;
    wire Carry, Overflow;

    datapath_core #(WIDTH) dut (A,B,Op,Result,Zero,Neg,Carry,Overflow);

    initial begin
        $display("=== DAY-8 Datapath Core TB Start ===");

        // Simple directed tests (Day-9 adds random + coverage)
        A = 8'd5; B = 8'd3; Op = 4'b0000; #1; // ADD
        A = 8'd12; B= 8'd7; Op = 4'b0001; #1; // SUB
        A = 8'hF0; B= 8'h0F; Op = 4'b0010; #1; // AND
        A = 8'hAA; B= 8'h55; Op = 4'b0011; #1; // OR
        A = 8'hC3; B= 8'h3C; Op = 4'b0100; #1; // XOR
        A = 8'd2;  B= 8'd5; Op = 4'b0101; #1; // SLT
        A = 8'h0F; B= 8'd2; Op = 4'b0110; #1; // SLL
        A = 8'hF0; B= 8'd3; Op = 4'b0111; #1; // SRL

        $display("=== DAY-8 Datapath Core TB End ===");
        $finish;
    end

endmodule


