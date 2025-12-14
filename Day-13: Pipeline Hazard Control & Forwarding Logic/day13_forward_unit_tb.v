`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 13.12.2025 18:33:20
// Design Name: 
// Module Name: day13_forwarding_tb
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


module day13_forwarding_tb;

    reg clk;
    reg rstn;

    // Simulated pipeline registers
    reg  [7:0] A_ex, B_ex;
    reg  [7:0] alu_mem;
    reg  [7:0] wb_data;

    reg  [4:0] ex_rs1, ex_rs2;
    reg  [4:0] mem_rd, wb_rd;
    reg        mem_regwrite, wb_regwrite;

    wire [1:0] forwardA, forwardB;

    reg  [7:0] alu_in1, alu_in2;
    wire [7:0] alu_result;

    // Forwarding Unit
    forwarding_unit FU (
        .ex_rs1(ex_rs1),
        .ex_rs2(ex_rs2),
        .mem_rd(mem_rd),
        .mem_regwrite(mem_regwrite),
        .wb_rd(wb_rd),
        .wb_regwrite(wb_regwrite),
        .forwardA(forwardA),
        .forwardB(forwardB)
    );

    // ALU input mux (what we are REALLY testing)
    always @(*) begin
        case (forwardA)
            2'b00: alu_in1 = A_ex;
            2'b10: alu_in1 = alu_mem;
            2'b01: alu_in1 = wb_data;
            default: alu_in1 = 8'h00;
        endcase

        case (forwardB)
            2'b00: alu_in2 = B_ex;
            2'b10: alu_in2 = alu_mem;
            2'b01: alu_in2 = wb_data;
            default: alu_in2 = 8'h00;
        endcase
    end

    // Simple ALU (ADD only for clarity)
    assign alu_result = alu_in1 + alu_in2;

    // Clock
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        $display("=== DAY-13 FORWARDING TB START ===");

        // Reset
        rstn = 0;
        #10 rstn = 1;

        // -------------------------------
        // TEST 1: EX/MEM forwarding
        // I1 result = 20, I2 needs it
        // -------------------------------
        A_ex = 8'd0;
        B_ex = 8'd5;

        alu_mem = 8'd20;    // result from previous instruction
        wb_data = 8'd0;

        ex_rs1 = 5'd1;      // current instruction needs R1
        ex_rs2 = 5'd0;

        mem_rd = 5'd1;      // EX/MEM writes R1
        mem_regwrite = 1;

        wb_rd = 0;
        wb_regwrite = 0;

        #1;

        if (alu_in1 !== 8'd20)
            $display("FAIL: EX/MEM forwarding failed");
        else
            $display("PASS: EX/MEM forwarding works");

        // -------------------------------
        // TEST 2: MEM/WB forwarding
        // -------------------------------
        mem_regwrite = 0;

        wb_rd = 5'd2;
        wb_regwrite = 1;
        wb_data = 8'd15;

        ex_rs1 = 5'd2;

        #1;

        if (alu_in1 !== 8'd15)
            $display("FAIL: MEM/WB forwarding failed");
        else
            $display("PASS: MEM/WB forwarding works");

        // -------------------------------
        // TEST 3: No forwarding (normal)
        // -------------------------------
        wb_regwrite = 0;
        A_ex = 8'd7;

        #1;

        if (alu_in1 !== 8'd7)
            $display("FAIL: Normal path broken");
        else
            $display("PASS: Normal path works");

        $display("=== DAY-13 FORWARDING TB DONE ===");
        $finish;
    end

endmodule


