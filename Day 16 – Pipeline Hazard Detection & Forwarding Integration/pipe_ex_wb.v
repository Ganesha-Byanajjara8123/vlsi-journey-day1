`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 16.12.2025 11:44:50
// Design Name: 
// Module Name: pipe_ex_wb
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



module pipe_ex_wb (
    input        clk,
    input        rstn,
    input        regwrite_in,
    input  [2:0] rd_in,
    input  [7:0] alu_in,

    output reg        regwrite_out,
    output reg [2:0]  rd_out,
    output reg [7:0]  alu_out
);

    always @(posedge clk or negedge rstn) begin
        if (!rstn) begin
            regwrite_out <= 0;
            rd_out       <= 0;
            alu_out      <= 0;
        end else begin
            regwrite_out <= regwrite_in;
            rd_out       <= rd_in;
            alu_out      <= alu_in;
        end
    end

endmodule

