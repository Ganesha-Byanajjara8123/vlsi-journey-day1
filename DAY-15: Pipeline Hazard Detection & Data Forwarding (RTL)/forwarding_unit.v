`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 15.12.2025 09:32:22
// Design Name: 
// Module Name: forwarding_unit
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


module forwarding_unit (
    input        ex_mem_regwrite,
    input        mem_wb_regwrite,
    input  [2:0] ex_mem_rd,
    input  [2:0] mem_wb_rd,
    input  [2:0] id_ex_rs,
    input  [2:0] id_ex_rt,
    output reg [1:0] forwardA,
    output reg [1:0] forwardB
);
    always @(*) begin
        forwardA = 2'b00;
        forwardB = 2'b00;

        if (ex_mem_regwrite && ex_mem_rd!=0 && ex_mem_rd==id_ex_rs)
            forwardA = 2'b10;
        if (ex_mem_regwrite && ex_mem_rd!=0 && ex_mem_rd==id_ex_rt)
            forwardB = 2'b10;

        if (mem_wb_regwrite && mem_wb_rd!=0 &&
           !(ex_mem_regwrite && ex_mem_rd==id_ex_rs) &&
            mem_wb_rd==id_ex_rs)
            forwardA = 2'b01;

        if (mem_wb_regwrite && mem_wb_rd!=0 &&
           !(ex_mem_regwrite && ex_mem_rd==id_ex_rt) &&
            mem_wb_rd==id_ex_rt)
            forwardB = 2'b01;
    end
endmodule

