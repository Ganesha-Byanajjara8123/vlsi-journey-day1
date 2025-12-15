`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 15.12.2025 22:32:16
// Design Name: 
// Module Name: if_stage_day15
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


module if_stage_day15 (
    input  wire        clk,
    input  wire        rstn,
    input  wire        stall,
    input  wire        pc_write,
    output reg  [7:0]  pc,
    output wire [19:0] instr
);
    instr_mem IM (
        .addr(pc),
        .instr(instr)
    );

    always @(posedge clk or negedge rstn) begin
        if (!rstn)
            pc <= 8'd0;
        else if (!stall && pc_write)
            pc <= pc + 1'b1;
    end
endmodule


