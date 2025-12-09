`timescale 1ns/1ps
//
// datapath_core_verif_TB.v
// Day-9: Randomized verification + scoreboard + coverage counters
//

module datapath_core_verif_TB;

    // Adjustable params
    parameter WIDTH     = 8;
    parameter NUM_TESTS = 2000;

    // DUT stimulus
    reg  [WIDTH-1:0] A;
    reg  [WIDTH-1:0] B;
    reg  [3:0]       Op;

    // DUT outputs
    wire [WIDTH-1:0] Result;
    wire             Zero;
    wire             Neg;
    wire             Carry;
    wire             Overflow;

    // Instantiate DUT (assumes datapath_core.v exists and has same port order)
    datapath_core #( .WIDTH(WIDTH) ) dut (
        .A(A),
        .B(B),
        .OpCode(Op),
        .Result(Result),
        .Zero(Zero),
        .Neg(Neg),
        .Carry(Carry),
        .Overflow(Overflow)
    );

    // Scoreboard / golden model variables
    reg  [WIDTH-1:0] exp_result;
    reg              exp_zero, exp_neg, exp_carry, exp_ovf;

    // Coverage counters & stats
    integer errors;
    integer i;
    integer op_count [0:15];      // opcode counts
    integer cov_slt_true;
    integer cov_slt_false;
    integer cov_carry_true;
    integer cov_ovf_true;

    // File for coverage dump
    integer fd;

    // Simple directed tests to sanity-check
    task directed_tests;
        begin
            $display("=== Day-9 Directed tests start ===");
            // ADD
            A = 8'd5; B = 8'd3; Op = 4'b0000; #1; check_and_record();
            // SUB
            A = 8'd10; B = 8'd3; Op = 4'b0001; #1; check_and_record();
            // AND
            A = 8'hF0; B = 8'h0F; Op = 4'b0010; #1; check_and_record();
            // OR
            A = 8'hAA; B = 8'h55; Op = 4'b0011; #1; check_and_record();
            // XOR
            A = 8'hC3; B = 8'h3C; Op = 4'b0100; #1; check_and_record();
            // SLT (signed)
            A = 8'd2; B = 8'd5; Op = 4'b0101; #1; check_and_record();
            // SLL
            A = 8'h0F; B = 8'd2; Op = 4'b0110; #1; check_and_record();
            // SRL
            A = 8'hF0; B = 8'd3; Op = 4'b0111; #1; check_and_record();
            $display("=== Day-9 Directed tests done ===");
        end
    endtask

    // Golden model: compute expected result and flags
    task golden;
        input [WIDTH-1:0] a;
        input [WIDTH-1:0] b;
        input [3:0]       op;
        output [WIDTH-1:0] r;
        output             z;
        output             n;
        output             c;
        output             v;
        reg [WIDTH:0] tmp;
        reg signed [WIDTH-1:0] sa, sb;
        begin
            // default
            r = {WIDTH{1'b0}};
            c = 1'b0;
            v = 1'b0;

            case (op)
                4'b0000: begin // ADD
                    tmp = a + b;
                    r   = tmp[WIDTH-1:0];
                    c   = tmp[WIDTH];
                    // signed overflow
                    v = (a[WIDTH-1] == b[WIDTH-1]) && (r[WIDTH-1] != a[WIDTH-1]);
                end

                4'b0001: begin // SUB
                    tmp = a - b;
                    r   = tmp[WIDTH-1:0];
                    c   = tmp[WIDTH]; // borrow indicator (as implemented in DUT)
                    v = (a[WIDTH-1] != b[WIDTH-1]) && (r[WIDTH-1] != a[WIDTH-1]);
                end

                4'b0010: r = a & b; // AND
                4'b0011: r = a | b; // OR
                4'b0100: r = a ^ b; // XOR

                4'b0101: begin // SLT (signed)
                    sa = a;
                    sb = b;
                    if (sa < sb) r = {{(WIDTH-1){1'b0}}, 1'b1};
                    else         r = {WIDTH{1'b0}};
                end

                4'b0110: begin // SLL
                    r = a << b[($clog2(WIDTH)-1):0];
                end

                4'b0111: begin // SRL
                    r = a >> b[($clog2(WIDTH)-1):0];
                end

                default: r = {WIDTH{1'b0}};
            endcase

            z = (r == {WIDTH{1'b0}});
            n = r[WIDTH-1];
        end
    endtask

    // check and update counters
    task check_and_record;
        reg [WIDTH-1:0] golden_r;
        reg golden_z, golden_n, golden_c, golden_v;
        begin
            golden(A, B, Op, golden_r, golden_z, golden_n, golden_c, golden_v);

            // opcode coverage
            op_count[Op] = op_count[Op] + 1;

            // coverage counters
            if (Op == 4'b0101) begin
                if (golden_r != {WIDTH{1'b0}}) cov_slt_true = cov_slt_true + 1;
                else cov_slt_false = cov_slt_false + 1;
            end
            if (golden_c) cov_carry_true = cov_carry_true + 1;
            if (golden_v) cov_ovf_true = cov_ovf_true + 1;

            // scoreboard compare
            if (Result !== golden_r) begin
                $display("RESULT MISMATCH: Op=%0d A=%0h B=%0h | exp=%0h got=%0h",
                         Op, A, B, golden_r, Result);
                errors = errors + 1;
            end
            if (Zero !== golden_z) begin
                $display("ZERO FLAG MISMATCH: Op=%0d A=%0h B=%0h | exp=%0b got=%0b",
                         Op, A, B, golden_z, Zero);
                errors = errors + 1;
            end
            if (Neg !== golden_n) begin
                $display("NEG FLAG MISMATCH: Op=%0d A=%0h B=%0h | exp=%0b got=%0b",
                         Op, A, B, golden_n, Neg);
                errors = errors + 1;
            end
            if (Carry !== golden_c) begin
                $display("CARRY FLAG MISMATCH: Op=%0d A=%0h B=%0h | exp=%0b got=%0b",
                         Op, A, B, golden_c, Carry);
                errors = errors + 1;
            end
            if (Overflow !== golden_v) begin
                $display("OVF FLAG MISMATCH: Op=%0d A=%0h B=%0h | exp=%0b got=%0b",
                         Op, A, B, golden_v, Overflow);
                errors = errors + 1;
            end
        end
    endtask

    // initialize
    initial begin
        // reset stats
        errors = 0;
        cov_slt_true = 0;
        cov_slt_false = 0;
        cov_carry_true = 0;
        cov_ovf_true = 0;
        for (i=0; i<16; i=i+1) op_count[i] = 0;

        // run directed quick checks
        directed_tests();

        // run randomized tests
        $display("=== Day-9: Running %0d randomized tests ===", NUM_TESTS);
        for (i = 0; i < NUM_TESTS; i = i + 1) begin
            // choose random op 0..7 (limit to supported ops)
            Op = $unsigned($random) % 8;

            // random operands
            A = $random;
            B = $random;

            // shorten B for shift amount to avoid expensive shifts out of range
            B = B & ({WIDTH{1'b1}}); // keep width bits

            #1; // wait combinational settle

            // perform check and stats
            check_and_record();
        end

        // report
        $display("=== Day-9 DONE. Errors=%0d ===", errors);
        $display("Opcode counts:");
        for (i=0; i<8; i=i+1) $display("  Op %0d -> %0d", i, op_count[i]);

        $display("Coverage:");
        $display("  SLT true  : %0d", cov_slt_true);
        $display("  SLT false : %0d", cov_slt_false);
        $display("  Carry true: %0d", cov_carry_true);
        $display("  OVF true  : %0d", cov_ovf_true);

        // write small CSV coverage file
        fd = $fopen("day9_coverage_report.csv","w");
        $fdisplay(fd, "op, count");
        for (i=0; i<8; i=i+1) $fdisplay(fd, "%0d, %0d", i, op_count[i]);
        $fdisplay(fd, "");
        $fdisplay(fd, "cov_slt_true, %0d", cov_slt_true);
        $fdisplay(fd, "cov_slt_false, %0d", cov_slt_false);
        $fdisplay(fd, "cov_carry_true, %0d", cov_carry_true);
        $fdisplay(fd, "cov_ovf_true, %0d", cov_ovf_true);
        $fclose(fd);

        if (errors == 0) $display("ALL TESTS PASSED (Day-9 verification).");
        else $display("FAILURES: %0d", errors);

        $finish;
    end

endmodule

