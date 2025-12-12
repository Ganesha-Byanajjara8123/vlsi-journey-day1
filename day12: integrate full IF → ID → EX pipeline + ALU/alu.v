`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12.12.2025 18:19:25
// Design Name: 
// Module Name: alu
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


module alu #(
    parameter WIDTH = 8
)(
    input  [WIDTH-1:0] A,
    input  [WIDTH-1:0] B,
    input  [3:0] opcode,
    output reg [WIDTH-1:0] result
);

    always @(*) begin
        case (opcode)
            4'b0000: result = A + B;
            4'b0001: result = A - B;
            4'b0010: result = A & B;
            4'b0011: result = A | B;
            4'b0100: result = A ^ B;
            4'b0101: result = ($signed(A) < $signed(B)) ? 8'd1 : 8'd0;
            4'b0110: result = A << B[2:0];
            4'b0111: result = A >> B[2:0];
            default: result = 0;
        endcase
    end
endmodule


