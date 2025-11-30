// rtl/tb/alu_tb.v
`timescale 1ns/1ps
module ALU_TB;

    // Inputs
    reg [3:0] A;
    reg [3:0] B;
    reg [2:0] OpCode;

    // Outputs
    wire [3:0] Result;
    wire      SLT_Flag;
    wire      Zero_Flag;

    // UUT
    ALU uut (
        .A(A), .B(B), .OpCode(OpCode),
        .Result(Result), .SLT_Flag(SLT_Flag), .Zero_Flag(Zero_Flag)
    );

    // Opcodes
    localparam OP_ADD = 3'b000,
               OP_SUB = 3'b001,
               OP_AND = 3'b010,
               OP_OR  = 3'b011,
               OP_XOR = 3'b100,
               OP_SLT = 3'b101;

    integer test_count = 0;
    integer error_count = 0;

    // Utility: mask to 4 bits
    function [3:0] mask4(input [7:0] v);
        mask4 = v[3:0];
    endfunction

    // Self-checking task: settle then compare
    task run_test;
        input [3:0] exp_result;
        input       exp_slt;
        input       exp_zero;
        input [127:0] test_name;
        begin
            #2; // settle time for combinational logic (adjust if needed)
            test_count = test_count + 1;
            if ( (Result === exp_result) && (SLT_Flag === exp_slt) && (Zero_Flag === exp_zero) ) begin
                $display("TEST %0d PASS : %s", test_count, test_name);
            end else begin
                $display("TEST %0d FAIL : %s", test_count, test_name);
                $display("  Inputs: A=%0d (0x%0h), B=%0d (0x%0h), Op=%b", $signed(A), A, $signed(B), B, OpCode);
                $display("  Expected: R=0x%0h SLT=%b Zero=%b", exp_result, exp_slt, exp_zero);
                $display("  Actual  : R=0x%0h SLT=%b Zero=%b", Result, SLT_Flag, Zero_Flag);
                error_count = error_count + 1;
            end
        end
    endtask

    // Dump waveform for GTKWave/Icarus or Vivado dump viewer
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0, ALU_TB);
    end

    initial begin
        $display("==== ALU Testbench Start ====");
        // ADD tests
        OpCode = OP_ADD;
        A = 4'd5;  B = 4'd3;  run_test(mask4(5+3), 0, (mask4(5+3)==0), "ADD 5+3");
        A = 4'd10; B = 4'd5;  run_test(mask4(10+5), 0, (mask4(10+5)==0), "ADD 10+5");
        A = 4'd15; B = 4'd1;  run_test(mask4(15+1), 0, (mask4(15+1)==0), "ADD 15+1 (overflow)");
        A = 4'd7;  B = 4'd8;  run_test(mask4(7+8),  0, (mask4(7+8)==0), "ADD 7+8");

        // SUB tests (signed behaviour considered in DUT)
        OpCode = OP_SUB;
        A = 4'd10; B = 4'd3; run_test(mask4(10-3), 0, (mask4(10-3)==0), "SUB 10-3");
        A = 4'd5;  B = 4'd5; run_test(mask4(5-5),  0, (mask4(5-5)==0), "SUB 5-5 (zero)");
        A = 4'd3;  B = 4'd10; run_test(mask4(3-10), 0, (mask4(3-10)==0), "SUB 3-10 (neg)");

        // LOGICAL tests
        OpCode = OP_AND;
        A = 4'b1101; B = 4'b0111; run_test(4'b0101, 0, 0, "AND 13 & 7");
        A = 4'b0000; B = 4'b1111; run_test(4'b0000, 0, 1, "AND 0 & 15 (zero)");

        OpCode = OP_OR;
        A = 4'b1101; B = 4'b0110; run_test(4'b1111, 0, 0, "OR 13 | 6");
        A = 4'b0000; B = 4'b0000; run_test(4'b0000, 0, 1, "OR 0 | 0 (zero)");

        OpCode = OP_XOR;
        A = 4'b1101; B = 4'b0110; run_test(4'b1011, 0, 0, "XOR 13 ^ 6");
        A = 4'b1010; B = 4'b1010; run_test(4'b0000, 0, 1, "XOR 10 ^ 10 (zero)");

        // SLT tests (signed comparisons)
        OpCode = OP_SLT;
        A = 4'd5;  B = 4'd10; run_test(4'd1, 1, 0, "SLT: 5 < 10");
        A = 4'd10; B = 4'd5;  run_test(4'd0, 0, 1, "SLT: 10 < 5 (false, zero)");
        A = 4'd5;  B = 4'd5;  run_test(4'd0, 0, 1, "SLT: 5 < 5 (false, zero)");
        A = 4'b1001; B = 4'b0010; run_test(4'd1, 1, 0, "SLT: -7 < 2 (true)");
        A = 4'b1110; B = 4'b1010; run_test(4'd0, 0, 1, "SLT: -2 < -6 (false, zero)");

        // Additional checks
        OpCode = OP_SUB; A = 4'd0; B = 4'd1; run_test(mask4(0-1), 0, (mask4(0-1)==0), "SUB 0-1");
        OpCode = OP_AND; A = 4'd15; B = 4'd15; run_test(4'd15, 0, 0, "AND 15&15");

        $display("==== Tests complete: total=%0d, errors=%0d ====", test_count, error_count);
        if (error_count == 0) $display("ALL PASSED");
        else $display("%0d FAILURES", error_count);

        #1;
        $finish;
    end

endmodule
