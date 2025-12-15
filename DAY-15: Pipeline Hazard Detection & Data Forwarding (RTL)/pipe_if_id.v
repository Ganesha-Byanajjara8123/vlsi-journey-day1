`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 15.12.2025 09:30:40
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
    input write_en,
    input [7:0] pc_in,
    input [19:0] instr_in,
    output reg [19:0] instr_out
);
    always @(posedge clk or negedge rstn) begin
        if (!rstn)
            instr_out <= 0;
        else if (write_en)
            instr_out <= instr_in;
    end
endmodule

