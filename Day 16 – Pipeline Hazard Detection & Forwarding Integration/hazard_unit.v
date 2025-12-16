`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 16.12.2025 11:43:56
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
    input  wire        id_ex_memread,
    input  wire [2:0]  id_ex_rd,
    input  wire [2:0]  if_id_rs1,
    input  wire [2:0]  if_id_rs2,
    output wire        pc_write,
    output wire        if_id_write,
    output wire        id_ex_flush
);

    wire hazard;

    assign hazard =
        id_ex_memread &&
        (id_ex_rd != 3'b000) &&
        ((id_ex_rd == if_id_rs1) || (id_ex_rd == if_id_rs2));

    assign pc_write    = ~hazard;
    assign if_id_write = ~hazard;
    assign id_ex_flush =  hazard;

endmodule




