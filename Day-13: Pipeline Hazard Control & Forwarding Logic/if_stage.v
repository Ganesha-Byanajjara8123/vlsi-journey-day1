`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 13.12.2025 17:58:11
// Design Name: 
// Module Name: if_stage
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

module if_stage (
    input clk,
    input rstn,
    input stall,
    output reg [7:0] pc,
    output [19:0] instr
);
    instr_mem IM (.addr(pc), .instr(instr));

    always @(posedge clk or negedge rstn) begin
        if (!rstn)
            pc <= 0;
        else if (!stall)
            pc <= pc + 1;
    end
endmodule


