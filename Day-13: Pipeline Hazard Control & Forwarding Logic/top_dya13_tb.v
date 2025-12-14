`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 13.12.2025 18:02:13
// Design Name: 
// Module Name: top_day13_tb
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



module top_day13_tb;

    reg clk;
    reg rstn;

    wire [7:0] pc;
    wire [7:0] alu_out;

    // DUT
    top_day13 dut (
        .clk(clk),
        .rstn(rstn),
        .pc(pc),
        .alu_out(alu_out)
    );

    // Clock
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Test
    initial begin
        $display("=== DAY-13 Hazard Test Start ===");
        $dumpfile("day13.vcd");
        $dumpvars(0, top_day13_tb);

        rstn = 0;
        #15 rstn = 1;

        // Let pipeline run
        repeat (10) @(posedge clk);

        // Observe behavior
        $display("Final PC = %0d", pc);
        $display("Final ALU OUT = %0d", alu_out);

        // Sanity check
        if (alu_out === 8'bx) begin
            $display("ERROR: ALU output is X (hazard failed)");
        end else begin
            $display("ALU output valid (hazard handled)");
        end

        $display("=== DAY-13 Test Complete ===");
        #10 $finish;
    end

endmodule

