`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12.12.2025 18:20:07
// Design Name: 
// Module Name: pipe_id_ex
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


module pipe_id_ex (
    input clk,
    input rstn,
    input stall,

    input  [3:0] opcode_in,
    input  [7:0] A_in,
    input  [7:0] B_in,

    output reg [3:0] opcode_out,
    output reg [7:0] A_out,
    output reg [7:0] B_out
);

    always @(posedge clk or negedge rstn) begin
        if (!rstn) begin
            opcode_out <= 0;
            A_out      <= 0;
            B_out      <= 0;
        end 
        else if (!stall) begin
            opcode_out <= opcode_in;
            A_out      <= A_in;
            B_out      <= B_in;
        end
    end

endmodule

  


