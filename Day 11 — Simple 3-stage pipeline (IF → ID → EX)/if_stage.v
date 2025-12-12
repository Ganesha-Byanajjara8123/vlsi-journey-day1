
`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11.12.2025 22:47:01
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
    input        clk,
    input        rstn,
    input        stall,          // hazard stall input
    output [7:0] pc_out,
    output [19:0] instr_out      // 4b opcode + A + B
);
    reg [7:0] pc;

    wire [19:0] instr_mem_out;

    instr_mem imem (
        .addr(pc),
        .instr(instr_mem_out)
    );

    assign pc_out = pc;
    assign instr_out = instr_mem_out;

    always @(posedge clk or negedge rstn) begin
        if (!rstn)
            pc <= 0;
        else if (!stall)
            pc <= pc + 1;
    end

endmodule
  
