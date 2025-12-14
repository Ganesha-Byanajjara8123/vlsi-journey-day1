`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 13.12.2025 17:59:29
// Design Name: 
// Module Name: hazard_unit
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

module hazard_unit (
    input [2:0] rs_id,
    input [2:0] rt_id,
    input [2:0] rd_ex,
    input       regwrite_ex,
    output      stall
);
    assign stall =
        regwrite_ex &&
        ((rd_ex == rs_id) || (rd_ex == rt_id)) &&
        (rd_ex != 0);
endmodule


