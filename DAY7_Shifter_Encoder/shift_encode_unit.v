`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07.12.2025 22:57:33
// Design Name: 
// Module Name: shift_encode_unit
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


module shift_encode_unit (
    input  wire [7:0] in,
    input  wire [2:0] shamt,
    input  wire [1:0] mode,
    output wire [7:0] shifted,
    output wire [2:0] pe_out,
    output wire       pe_valid
);

    barrel_shifter_8 BS (in, shamt, mode, shifted);
    priority_encoder_8 PE (shifted, pe_out, pe_valid);

endmodule
    

