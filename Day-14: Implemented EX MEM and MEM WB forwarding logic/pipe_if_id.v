`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 13.12.2025 17:58:41
// Design Name: 
// Module Name: pipe_if_id
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


module pipe_if_id (
    input clk,
    input rstn,
    input stall,
    input [7:0] pc_in,
    input [19:0] instr_in,
    output reg [7:0] pc_out,
    output reg [19:0] instr_out
);
    always @(posedge clk or negedge rstn) begin
        if (!rstn) begin
            pc_out <= 0;
            instr_out <= 0;
        end else if (!stall) begin
            pc_out <= pc_in;
            instr_out <= instr_in;
        end
    end
endmodule


