`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 15.12.2025 09:31:31
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
    wire load_use_hazard;

    assign load_use_hazard =
        id_ex_memread &&
        ((id_ex_rd == if_id_rs1) || (id_ex_rd == if_id_rs2)) &&
        (id_ex_rd != 3'b000);

    assign pc_write    = ~load_use_hazard;
    assign if_id_write = ~load_use_hazard;
    assign id_ex_flush =  load_use_hazard;
endmodule

