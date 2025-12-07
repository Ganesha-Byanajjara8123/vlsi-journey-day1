`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07.12.2025 22:57:09
// Design Name: 
// Module Name: barrel_shifter_8
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


module barrel_shifter_8 (
    input  wire [7:0] in,
    input  wire [2:0] shamt,
    input  wire [1:0] mode,   // 00=LL, 01=LR, 10=RL, 11=RR
    output reg  [7:0] out
);
    always @(*) begin
        case (mode)
            2'b00: out = in << shamt;
            2'b01: out = in >> shamt;
            2'b10: out = (in << shamt) | (in >> (8 - shamt));  // rot left
            2'b11: out = (in >> shamt) | (in << (8 - shamt));  // rot right
        endcase
    end
endmodule

