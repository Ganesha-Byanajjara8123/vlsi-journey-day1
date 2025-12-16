`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 16.12.2025 11:35:51
// Design Name: 
// Module Name: if_stage_day16
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


module if_stage_day16 (
    input        clk,
    input        rstn,
    input        pc_write,
    output reg [7:0] pc,
    output [19:0] instr
);

    instr_mem IM (.addr(pc), .instr(instr));

    always @(posedge clk or negedge rstn) begin
        if (!rstn)
            pc <= 0;
        else if (pc_write)
            pc <= pc + 1;
    end

endmodule



