`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 13.12.2025 17:57:43
// Design Name: 
// Module Name: instr_mem
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


module instr_mem (
    input  [7:0] addr,
    output [19:0] instr
);
    reg [19:0] mem [0:255];

    initial begin
        mem[0] = {4'b0000,8'h05,8'h03}; // ADD
        mem[1] = {4'b0000,8'h08,8'h01}; // ADD (RAW hazard)
        mem[2] = {4'b0001,8'h08,8'h02}; // SUB
    end

    assign instr = mem[addr];
endmodule


