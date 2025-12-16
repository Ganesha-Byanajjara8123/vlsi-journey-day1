`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 16.12.2025 11:43:12
// Design Name: 
// Module Name: regfile
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


module regfile (
    input         clk,
    input         rstn,
    input         we,
    input  [2:0]  ra1,
    input  [2:0]  ra2,
    input  [2:0]  wa,
    input  [7:0]  wd,
    output [7:0]  rd1,
    output [7:0]  rd2
);

    reg [7:0] regs [0:7];
    integer i;

    always @(negedge rstn) begin
        for (i = 0; i < 8; i = i + 1)
            regs[i] <= 8'b0;
    end

    always @(posedge clk) begin
        if (we && wa != 0)
            regs[wa] <= wd;
    end

    assign rd1 = (ra1 == 0) ? 8'b0 : regs[ra1];
    assign rd2 = (ra2 == 0) ? 8'b0 : regs[ra2];

endmodule



