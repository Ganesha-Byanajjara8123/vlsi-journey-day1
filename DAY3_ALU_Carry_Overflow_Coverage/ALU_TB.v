// rtl/tb/ALU_TB.v  -- Day 3 Testbench: golden model + scoreboard + coverage
`timescale 1ns/1ps

module ALU_TB;

    // DUT inputs
    reg [3:0] A;
    reg [3:0] B;
    reg [2:0] OpCode;

    // DUT outputs
    wire [3:0] Result;
    wire       SLT_Flag;
    wire       Zero_Flag;
    wire       Carry_Flag;
    wire       Overflow_Flag;

    // Instantiate DUT
    ALU uut (
        .A(A),
        .B(B),
        .OpCode(OpCode),
        .Result(Result),
        .SLT_Flag(SLT_Flag),
        .Zero_Flag(Zero_Flag),
        .Carry_Flag(Carry_Flag),
        .Overflow_Flag(Overflow_Flag)
    );

    // Opcode encodings (must match ALU)
    localparam OP_ADD = 3'b000;
    localparam OP_SUB = 3'b001;
    localparam OP_AND = 3'b010;
    localparam OP_OR  = 3'b011;
    localparam OP_XOR = 3'b100;
    localparam OP_SLT = 3'b101;

    // settle delay for combinational outputs
    localparam integer SETTLE = 2;

    // test counters
    integer test_count;
    integer error_count;

    // coverage counters
    integer cov_op[0:5];       // per-opcode
    integer cov_slt_true;
    integer cov_slt_false;
    integer cov_carry_true;
    integer cov_ovf_true;

    integer fd;                // file for coverage CSV
    integer i;                 // loop index

    // expected (golden model) outputs
    reg [3:0] exp_result;
    reg       exp_slt;
    reg       exp_zero;
    reg       exp_carry;
    reg       exp_ovf;

    // helper: 4-bit mask
    function [3:0] mask4(input [7:0] v);
        mask4 = v[3:0];
    endfunction

    // --------- Golden reference model (Day-3) ----------
    // Uses current A, B, OpCode to compute expected outputs
    task calc_expected;
        reg [4:0] tmp;
        begin
            // defaults
            exp_result = 4'b0000;
            exp_slt    = 1'b0;
            exp_carry  = 1'b0;
            exp_ovf    = 1'b0;

            case (OpCode)
                OP_ADD: begin
                    tmp        = {1'b0, A} + {1'b0, B};
                    exp_result = tmp[3:0];
                    exp_carry  = tmp[4]; // unsigned carry
                    // signed overflow: A and B same sign, Result different
                    exp_ovf    = (A[3] == B[3]) && (exp_result[3] != A[3]);
                end

                OP_SUB: begin
                    tmp        = {1'b0, A} - {1'b0, B};
                    exp_result = tmp[3:0];
                    exp_carry  = tmp[4]; // borrow-related info (documented)
                    // signed overflow: A and B different sign, Result different from A
                    exp_ovf    = (A[3] != B[3]) && (exp_result[3] != A[3]);
                end

                OP_AND: begin
                    exp_result = A & B;
                end

                OP_OR: begin
                    exp_result = A | B;
                end

                OP_XOR: begin
                    exp_result = A ^ B;
                end

                OP_SLT: begin
                    // signed comparison
                    if ($signed(A) < $signed(B)) begin
                        exp_slt    = 1'b1;
                        exp_result = 4'd1;
                    end else begin
                        exp_slt    = 1'b0;
                        exp_result = 4'd0;
                    end
                end

                default: begin
                    exp_result = 4'b0000;
                end
            endcase

            exp_zero = (exp_result == 4'b0000);
        end
    endtask
    // ---------------------------------------------------

    // self-checking task with assertion-style checks
    task run_test;
        begin
            #SETTLE;
            test_count = test_count + 1;

            // Basic X-check on Result
            if (Result === 4'bxxxx) begin
                $display("ASSERT FAIL @TEST %0d: Result is X (A=0x%0h B=0x%0h Op=%b)",
                          test_count, A, B, OpCode);
                error_count = error_count + 1;
            end

            // Compare DUT vs expected
            if ( (Result      !== exp_result) ||
                 (SLT_Flag    !== exp_slt)    ||
                 (Zero_Flag   !== exp_zero)   ||
                 (Carry_Flag  !== exp_carry)  ||
                 (Overflow_Flag !== exp_ovf) ) begin

                $display("TEST %0d FAIL", test_count);
                $display("  Inputs : A=%0d (0x%0h), B=%0d (0x%0h), Op=%b",
                          $signed(A), A, $signed(B), B, OpCode);
                $display("  Expected: R=0x%0h SLT=%b Z=%b C=%b OVF=%b",
                          exp_result, exp_slt, exp_zero, exp_carry, exp_ovf);
                $display("  Actual  : R=0x%0h SLT=%b Z=%b C=%b OVF=%b",
                          Result, SLT_Flag, Zero_Flag, Carry_Flag, Overflow_Flag);

                // extra assertion: Zero_Flag must match Result==0
                if (Zero_Flag !== (Result == 4'b0000))
                    $display("  ASSERT: Zero_Flag mismatch with Result==0");

                // extra assertion: SLT_Flag only relevant in SLT opcode
                if ((OpCode != OP_SLT) && (SLT_Flag !== 1'b0))
                    $display("  ASSERT: SLT_Flag should be 0 when not SLT opcode");

                error_count = error_count + 1;
            end else begin
                $display("TEST %0d PASS", test_count);
            end
        end
    endtask

    // waveform dump (Vivado will generate wave.vcd in sim dir)
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0, ALU_TB);
    end

    // main test flow: directed + random + coverage + summary
    initial begin : TEST_FLOW
        integer rndA, rndB, rndOp;

        // init counts
        test_count      = 0;
        error_count     = 0;
        cov_slt_true    = 0;
        cov_slt_false   = 0;
        cov_carry_true  = 0;
        cov_ovf_true    = 0;
        for (i = 0; i <= 5; i = i + 1) cov_op[i] = 0;

        $display("==== ALU Day-3 Tests Start ====");

        // ---------------- DIRECTED TESTS ----------------
        // ADD tests
        OpCode = OP_ADD;
        A = 4'd5;  B = 4'd3;
        $display("RUN: ADD 5+3");
        calc_expected; run_test;

        A = 4'd10; B = 4'd5;
        $display("RUN: ADD 10+5");
        calc_expected; run_test;

        A = 4'd15; B = 4'd1; // overflow unsigned carry, signed too
        $display("RUN: ADD 15+1 (overflow unsigned)");
        calc_expected; run_test;

        A = 4'd7;  B = 4'd8; // 7+8=15
        $display("RUN: ADD 7+8");
        calc_expected; run_test;

        // SUB tests
        OpCode = OP_SUB;
        A = 4'd10; B = 4'd3;
        $display("RUN: SUB 10-3");
        calc_expected; run_test;

        A = 4'd5;  B = 4'd5;
        $display("RUN: SUB 5-5 (zero)");
        calc_expected; run_test;

        A = 4'd3;  B = 4'd10; // negative result
        $display("RUN: SUB 3-10 (neg)");
        calc_expected; run_test;

        // AND tests
        OpCode = OP_AND;
        A = 4'b1101; B = 4'b0111;
        $display("RUN: AND 13 & 7");
        calc_expected; run_test;

        A = 4'b0000; B = 4'b1111;
        $display("RUN: AND 0 & 15 (zero)");
        calc_expected; run_test;

        // OR tests
        OpCode = OP_OR;
        A = 4'b1101; B = 4'b0110;
        $display("RUN: OR 13 | 6");
        calc_expected; run_test;

        A = 4'b0000; B = 4'b0000;
        $display("RUN: OR 0 | 0 (zero)");
        calc_expected; run_test;

        // XOR tests
        OpCode = OP_XOR;
        A = 4'b1101; B = 4'b0110;
        $display("RUN: XOR 13 ^ 6");
        calc_expected; run_test;

        A = 4'b1010; B = 4'b1010;
        $display("RUN: XOR 10 ^ 10 (zero)");
        calc_expected; run_test;

        // SLT tests (signed)
        OpCode = OP_SLT;
        A = 4'd5;  B = 4'd10;
        $display("RUN: SLT 5 < 10");
        calc_expected; run_test;

        A = 4'd10; B = 4'd5;
        $display("RUN: SLT 10 < 5");
        calc_expected; run_test;

        A = 4'd5;  B = 4'd5;
        $display("RUN: SLT 5 < 5");
        calc_expected; run_test;

        A = 4'b1001; B = 4'b0010; // -7 < 2
        $display("RUN: SLT -7 < 2");
        calc_expected; run_test;

        A = 4'b1110; B = 4'b1010; // -2 vs -6
        $display("RUN: SLT -2 < -6");
        calc_expected; run_test;

        $display("==== Directed Tests Done ====");

        // --------------- RANDOM TESTS -------------------
        // Use older $random (Verilog) instead of $urandom_range
        $display("==== Running 50 random tests (Day-3) ====");
        for (i = 0; i < 50; i = i + 1) begin
            rndA = $random;
            rndB = $random;
            rndOp = $random;

            A      = rndA & 4'hF;         // 0..15
            B      = rndB & 4'hF;         // 0..15
            OpCode = rndOp % 6;           // 0..5 only (valid ops)

            $display("RUN: RANDOM %0d: Op=%0d A=0x%0h B=0x%0h",
                     i, OpCode, A, B);

            calc_expected;
            run_test;

            // coverage update
            cov_op[OpCode] = cov_op[OpCode] + 1;

            if (OpCode == OP_SLT) begin
                if (exp_slt) cov_slt_true = cov_slt_true + 1;
                else         cov_slt_false = cov_slt_false + 1;
            end

            if (exp_carry)
                cov_carry_true = cov_carry_true + 1;

            if (exp_ovf)
                cov_ovf_true = cov_ovf_true + 1;
        end

        // --------------- COVERAGE SUMMARY ---------------
        $display("==== COVERAGE SUMMARY (Day-3) ====");
        $display("ADD  (000): %0d", cov_op[0]);
        $display("SUB  (001): %0d", cov_op[1]);
        $display("AND  (010): %0d", cov_op[2]);
        $display("OR   (011): %0d", cov_op[3]);
        $display("XOR  (100): %0d", cov_op[4]);
        $display("SLT  (101): %0d  (SLT_true=%0d, SLT_false=%0d)",
                  cov_op[5], cov_slt_true, cov_slt_false);
        $display("CARRY asserted   : %0d times", cov_carry_true);
        $display("OVERFLOW asserted: %0d times", cov_ovf_true);

        // write coverage to CSV
        fd = $fopen("coverage_report.csv", "w");
        if (fd) begin
            $fdisplay(fd, "Metric,Value");
            $fdisplay(fd, "ADD,%0d",  cov_op[0]);
            $fdisplay(fd, "SUB,%0d",  cov_op[1]);
            $fdisplay(fd, "AND,%0d",  cov_op[2]);
            $fdisplay(fd, "OR,%0d",   cov_op[3]);
            $fdisplay(fd, "XOR,%0d",  cov_op[4]);
            $fdisplay(fd, "SLT,%0d",  cov_op[5]);
            $fdisplay(fd, "SLT_true,%0d",  cov_slt_true);
            $fdisplay(fd, "SLT_false,%0d", cov_slt_false);
            $fdisplay(fd, "CARRY_true,%0d", cov_carry_true);
            $fdisplay(fd, "OVF_true,%0d",   cov_ovf_true);
            $fclose(fd);
            $display("Coverage written to coverage_report.csv");
        end else begin
            $display("WARNING: could not open coverage_report.csv for writing.");
        end

        // --------------- FINAL SUMMARY ------------------
        $display("==== Tests complete: total=%0d, errors=%0d ====",
                 test_count, error_count);
        if (error_count == 0) $display("ALL TESTS PASSED");
        else                  $display("%0d TEST(S) FAILED", error_count);

        #5;
        $finish;
    end

endmodule

