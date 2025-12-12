`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12.12.2025 17:48:19
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
    input  wire [19:0] instr,
    output wire [3:0]  opcode,
    output wire [7:0]  A,
    output wire [7:0]  B
);

    // instr[19:16] = opcode, instr[15:8] = A, instr[7:0] = B
    assign opcode = instr[19:16];
    assign A      = instr[15:8];
    assign B      = instr[7:0];

endmodule

