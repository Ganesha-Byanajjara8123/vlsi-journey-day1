`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 13.12.2025 17:59:04
// Design Name: 
// Module Name: id_stage
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


module id_stage (
    input  [19:0] instr,
    output [3:0]  opcode,
    output [7:0]  A,
    output [7:0]  B,
    output [2:0]  rs,
    output [2:0]  rt,
    output [2:0]  rd
);
    assign opcode = instr[19:16];
    assign A      = instr[15:8];
    assign B      = instr[7:0];

    // Simple register mapping
    assign rs = instr[10:8];
    assign rt = instr[2:0];
    assign rd = instr[10:8]; // destination = rs (simplified)
endmodule


