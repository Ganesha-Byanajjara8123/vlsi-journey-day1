`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 15.12.2025 09:34:05
// Design Name: 
// Module Name: day15_forwarding_tb
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


module day15_forwarding_tb;

    reg  [7:0] A_ex, B_ex;
    reg  [7:0] alu_mem;
    reg  [7:0] wb_data;

    reg  [2:0] id_ex_rs, id_ex_rt;
    reg  [2:0] ex_mem_rd, mem_wb_rd;
    reg        ex_mem_regwrite, mem_wb_regwrite;

    wire [1:0] forwardA, forwardB;

    reg  [7:0] alu_in1, alu_in2;
    wire [7:0] alu_result;

    // -------------------------------
    // Forwarding Unit (CORRECT PORTS)
    // -------------------------------
    forwarding_unit FU (
        .ex_mem_regwrite(ex_mem_regwrite),
        .mem_wb_regwrite(mem_wb_regwrite),
        .ex_mem_rd(ex_mem_rd),
        .mem_wb_rd(mem_wb_rd),
        .id_ex_rs(id_ex_rs),
        .id_ex_rt(id_ex_rt),
        .forwardA(forwardA),
        .forwardB(forwardB)
    );

    // -------------------------------
    // ALU input muxes
    // -------------------------------
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

    assign alu_result = alu_in1 + alu_in2;

    initial begin
        $display("=== DAY-13 FORWARDING TB START ===");

        // -------------------------------
        // TEST 1: EX/MEM forwarding
        // -------------------------------
        A_ex = 8'd0;
        B_ex = 8'd5;

        alu_mem = 8'd20;
        wb_data = 8'd0;

        id_ex_rs = 3'd1;
        id_ex_rt = 3'd0;

        ex_mem_rd = 3'd1;
        ex_mem_regwrite = 1;

        mem_wb_rd = 0;
        mem_wb_regwrite = 0;

        #1;
        if (alu_in1 !== 8'd20)
            $display("FAIL: EX/MEM forwarding failed");
        else
            $display("PASS: EX/MEM forwarding works");

        // -------------------------------
        // TEST 2: MEM/WB forwarding
        // -------------------------------
        ex_mem_regwrite = 0;

        mem_wb_rd = 3'd2;
        mem_wb_regwrite = 1;
        wb_data = 8'd15;

        id_ex_rs = 3'd2;

        #1;
        if (alu_in1 !== 8'd15)
            $display("FAIL: MEM/WB forwarding failed");
        else
            $display("PASS: MEM/WB forwarding works");

        // -------------------------------
        // TEST 3: No forwarding
        // -------------------------------
        mem_wb_regwrite = 0;
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
