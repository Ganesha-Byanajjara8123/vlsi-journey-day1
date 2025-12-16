`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 16.12.2025 11:44:23
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
    input  wire        clk,
    input  wire        rstn,
    input  wire        flush,

    input  wire [3:0]  opcode_in,
    input  wire [7:0]  A_in,
    input  wire [7:0]  B_in,
    input  wire [2:0]  rs_in,
    input  wire [2:0]  rt_in,
    input  wire [2:0]  rd_in,

    output reg  [3:0]  opcode_out,
    output reg  [7:0]  A_out,
    output reg  [7:0]  B_out,
    output reg  [2:0]  rs_out,
    output reg  [2:0]  rt_out,
    output reg  [2:0]  rd_out
);

    always @(posedge clk or negedge rstn) begin
        if (!rstn || flush) begin
            opcode_out <= 0;
            A_out      <= 0;
            B_out      <= 0;
            rs_out     <= 0;
            rt_out     <= 0;
            rd_out     <= 0;
        end else begin
            opcode_out <= opcode_in;
            A_out      <= A_in;
            B_out      <= B_in;
            rs_out     <= rs_in;
            rt_out     <= rt_in;
            rd_out     <= rd_in;
        end
    end
endmodule


