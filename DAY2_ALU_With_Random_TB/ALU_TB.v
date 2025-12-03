// rtl/tb/alu_tb.v  -- Verilog-2001, single-sequence testbench (Vivado-friendly)
`timescale 1ns/1ps

module ALU_TB;

    // Inputs
    reg [3:0] A;
    reg [3:0] B;
    reg [2:0] OpCode;

    // Outputs
    wire [3:0] Result;
    wire       SLT_Flag;
    wire       Zero_Flag;

    // UUT
    ALU uut (
        .A(A), .B(B), .OpCode(OpCode),
        .Result(Result), .SLT_Flag(SLT_Flag), .Zero_Flag(Zero_Flag)
    );

    // Opcodes (match rtl/alu.v)
    localparam OP_ADD = 3'b000,
               OP_SUB = 3'b001,
               OP_AND = 3'b010,
               OP_OR  = 3'b011,
               OP_XOR = 3'b100,
               OP_SLT = 3'b101;

    // settle delay for combinational outputs
    localparam integer SETTLE = 2;

    // test counters
    integer test_count;
    integer error_count;

    // coverage
    integer cov_op[0:5];
    integer cov_slt_true, cov_slt_false;
    integer fd;

    // temporaries
    reg [3:0] exp_result;
    reg       exp_slt;
    reg       exp_zero;

    // mask helper
    function [3:0] mask4(input [7:0] v);
        mask4 = v[3:0];
    endfunction

    // self-checking task
    task run_test;
        input [3:0] exp_result_in;
        input       exp_slt_in;
        input       exp_zero_in;
        begin
            #SETTLE;
            test_count = test_count + 1;
            if ( (Result === exp_result_in) && (SLT_Flag === exp_slt_in) && (Zero_Flag === exp_zero_in) ) begin
                $display("TEST %0d PASS", test_count);
            end else begin
                $display("TEST %0d FAIL", test_count);
                $display("  Inputs : A=%0d (0x%0h), B=%0d (0x%0h), Op=%b", $signed(A), A, $signed(B), B, OpCode);
                $display("  Expected: R=0x%0h SLT=%b Zero=%b", exp_result_in, exp_slt_in, exp_zero_in);
                $display("  Actual  : R=0x%0h SLT=%b Zero=%b", Result, SLT_Flag, Zero_Flag);
                error_count = error_count + 1;
            end
        end
    endtask

    // waveform dump
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0, ALU_TB);
    end

    // single sequential test flow: directed tests -> random tests -> coverage -> finish
    initial begin : TEST_FLOW
        integer i;
        test_count  = 0;
        error_count = 0;

        // init coverage
        for (i = 0; i <= 5; i = i + 1) cov_op[i] = 0;
        cov_slt_true  = 0;
        cov_slt_false = 0;

        $display("==== ALU Directed Tests Start ====");

        // ---- DIRECTED TESTS ----
        // ADD tests
        OpCode = OP_ADD;
        A = 4'd5;  B = 4'd3;  exp_result = mask4(5+3);  exp_slt = 1'b0; exp_zero = (exp_result==4'd0);
        $display("RUN: ADD 5+3"); run_test(exp_result, exp_slt, exp_zero);

        A = 4'd10; B = 4'd5;  exp_result = mask4(10+5); exp_slt = 1'b0; exp_zero = (exp_result==4'd0);
        $display("RUN: ADD 10+5"); run_test(exp_result, exp_slt, exp_zero);

        A = 4'd15; B = 4'd1;  exp_result = mask4(15+1); exp_slt = 1'b0; exp_zero = (exp_result==4'd0);
        $display("RUN: ADD 15+1 (overflow)"); run_test(exp_result, exp_slt, exp_zero);

        A = 4'd7;  B = 4'd8;  exp_result = mask4(7+8);  exp_slt = 1'b0; exp_zero = (exp_result==4'd0);
        $display("RUN: ADD 7+8"); run_test(exp_result, exp_slt, exp_zero);

        // SUB tests
        OpCode = OP_SUB;
        A = 4'd10; B = 4'd3; exp_result = mask4(10-3); exp_slt = 1'b0; exp_zero = (exp_result==4'd0);
        $display("RUN: SUB 10-3"); run_test(exp_result, exp_slt, exp_zero);

        A = 4'd5; B = 4'd5; exp_result = mask4(5-5); exp_slt = 1'b0; exp_zero = (exp_result==4'd0);
        $display("RUN: SUB 5-5 (zero)"); run_test(exp_result, exp_slt, exp_zero);

        A = 4'd3; B = 4'd10; exp_result = mask4(3-10); exp_slt = 1'b0; exp_zero = (exp_result==4'd0);
        $display("RUN: SUB 3-10 (neg)"); run_test(exp_result, exp_slt, exp_zero);

        // AND tests
        OpCode = OP_AND;
        A = 4'b1101; B = 4'b0111; exp_result = A & B; exp_slt = 1'b0; exp_zero = (exp_result==4'd0);
        $display("RUN: AND 13 & 7"); run_test(exp_result, exp_slt, exp_zero);

        A = 4'b0000; B = 4'b1111; exp_result = A & B; exp_slt = 1'b0; exp_zero = (exp_result==4'd0);
        $display("RUN: AND 0 & 15 (zero)"); run_test(exp_result, exp_slt, exp_zero);

        // OR tests
        OpCode = OP_OR;
        A = 4'b1101; B = 4'b0110; exp_result = A | B; exp_slt = 1'b0; exp_zero = (exp_result==4'd0);
        $display("RUN: OR 13 | 6"); run_test(exp_result, exp_slt, exp_zero);

        A = 4'b0000; B = 4'b0000; exp_result = A | B; exp_slt = 1'b0; exp_zero = (exp_result==4'd0);
        $display("RUN: OR 0 | 0 (zero)"); run_test(exp_result, exp_slt, exp_zero);

        // XOR tests
        OpCode = OP_XOR;
        A = 4'b1101; B = 4'b0110; exp_result = A ^ B; exp_slt = 1'b0; exp_zero = (exp_result==4'd0);
        $display("RUN: XOR 13 ^ 6"); run_test(exp_result, exp_slt, exp_zero);

        A = 4'b1010; B = 4'b1010; exp_result = A ^ B; exp_slt = 1'b0; exp_zero = (exp_result==4'd0);
        $display("RUN: XOR 10 ^ 10 (zero)"); run_test(exp_result, exp_slt, exp_zero);

        // SLT tests
        OpCode = OP_SLT;
        A = 4'd5; B = 4'd10; exp_slt = ($signed(A) < $signed(B)); exp_result = exp_slt ? 4'd1 : 4'd0; exp_zero = (exp_result==4'd0);
        $display("RUN: SLT 5 < 10"); run_test(exp_result, exp_slt, exp_zero);

        A = 4'd10; B = 4'd5; exp_slt = ($signed(A) < $signed(B)); exp_result = exp_slt ? 4'd1 : 4'd0; exp_zero = (exp_result==4'd0);
        $display("RUN: SLT 10 < 5"); run_test(exp_result, exp_slt, exp_zero);

        A = 4'd5; B = 4'd5; exp_slt = ($signed(A) < $signed(B)); exp_result = exp_slt ? 4'd1 : 4'd0; exp_zero = (exp_result==4'd0);
        $display("RUN: SLT 5 < 5"); run_test(exp_result, exp_slt, exp_zero);

        A = 4'b1001; B = 4'b0010; exp_slt = ($signed(A) < $signed(B)); exp_result = exp_slt ? 4'd1 : 4'd0; exp_zero = (exp_result==4'd0);
        $display("RUN: SLT -7 < 2"); run_test(exp_result, exp_slt, exp_zero);

        A = 4'b1110; B = 4'b1010; exp_slt = ($signed(A) < $signed(B)); exp_result = exp_slt ? 4'd1 : 4'd0; exp_zero = (exp_result==4'd0);
        $display("RUN: SLT -2 < -6"); run_test(exp_result, exp_slt, exp_zero);

        $display("==== Directed Tests Done ====");

        // small gap before random tests to make waveform readable
        #10;

        // ---- RANDOMIZED TESTS ----
        $display("==== Running 30 random tests (Day-2) ====");
        for (i = 0; i < 30; i = i + 1) begin
            A      = $urandom_range(0,15);
            B      = $urandom_range(0,15);
            OpCode = $urandom_range(0,5);

            case (OpCode)
                OP_ADD: exp_result = mask4(A + B);
                OP_SUB: exp_result = mask4(A - B);
                OP_AND: exp_result = A & B;
                OP_OR : exp_result = A | B;
                OP_XOR: exp_result = A ^ B;
                OP_SLT: begin
                    exp_slt = ($signed(A) < $signed(B));
                    exp_result = exp_slt ? 4'd1 : 4'd0;
                end
                default: exp_result = 4'd0;
            endcase

            if (OpCode != OP_SLT) exp_slt = 1'b0;
            exp_zero = (exp_result == 4'd0);

            $display("RUN: RANDOM %0d: Op=%0d A=0x%0h B=0x%0h", i, OpCode, A, B);
            run_test(exp_result, exp_slt, exp_zero);

            // update coverage
            cov_op[OpCode] = cov_op[OpCode] + 1;
            if (OpCode == OP_SLT) begin
                if (exp_slt) cov_slt_true = cov_slt_true + 1;
                else          cov_slt_false = cov_slt_false + 1;
            end
        end

        // print coverage
        $display("==== COVERAGE SUMMARY (Day-2) ====");
        $display("ADD  (000): %0d", cov_op[0]);
        $display("SUB  (001): %0d", cov_op[1]);
        $display("AND  (010): %0d", cov_op[2]);
        $display("OR   (011): %0d", cov_op[3]);
        $display("XOR  (100): %0d", cov_op[4]);
        $display("SLT  (101): %0d  (SLT_true=%0d, SLT_false=%0d)", cov_op[5], cov_slt_true, cov_slt_false);

        // write coverage CSV (Vivado should allow writing in sim working dir)
        fd = $fopen("coverage_report.csv", "w");
        if (fd) begin
            $fdisplay(fd,"Opcode,Count");
            $fdisplay(fd,"ADD,%0d",  cov_op[0]);
            $fdisplay(fd,"SUB,%0d",  cov_op[1]);
            $fdisplay(fd,"AND,%0d",  cov_op[2]);
            $fdisplay(fd,"OR,%0d",   cov_op[3]);
            $fdisplay(fd,"XOR,%0d",  cov_op[4]);
            $fdisplay(fd,"SLT,%0d,SLT_true=%0d,SLT_false=%0d", cov_op[5], cov_slt_true, cov_slt_false);
            $fclose(fd);
            $display("Coverage written to coverage_report.csv");
        end else begin
            $display("WARNING: could not open coverage_report.csv for writing.");
        end

        // final summary
        $display("==== Tests complete: total=%0d, errors=%0d ====", test_count, error_count);
        if (error_count == 0) $display("ALL PASSED");
        else $display("%0d FAILURES", error_count);

        #1;
        $finish;
    end // TEST_FLOW

endmodule

