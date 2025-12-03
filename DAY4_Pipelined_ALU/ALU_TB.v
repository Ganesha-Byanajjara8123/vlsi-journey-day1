// DAY4_Pipelined_ALU/ALU_PIPELINED_TB.v
`timescale 1ns/1ps

module ALU_PIPELINED_TB;

    // DUT ports
    reg         clk;
    reg         rst_n;
    reg         in_valid;
    reg  [3:0]  A;
    reg  [3:0]  B;
    reg  [2:0]  OpCode;

    wire        out_valid;
    wire [3:0]  Result;
    wire        SLT_Flag;
    wire        Zero_Flag;
    wire        Carry_Flag;
    wire        Overflow_Flag;

    // Instantiate DUT
    ALU_PIPELINED dut (
        .clk(clk),
        .rst_n(rst_n),
        .in_valid(in_valid),
        .A(A),
        .B(B),
        .OpCode(OpCode),
        .out_valid(out_valid),
        .Result(Result),
        .SLT_Flag(SLT_Flag),
        .Zero_Flag(Zero_Flag),
        .Carry_Flag(Carry_Flag),
        .Overflow_Flag(Overflow_Flag)
    );

    // Opcodes
    localparam OP_ADD = 3'b000;
    localparam OP_SUB = 3'b001;
    localparam OP_AND = 3'b010;
    localparam OP_OR  = 3'b011;
    localparam OP_XOR = 3'b100;
    localparam OP_SLT = 3'b101;

    // Clock generation
    initial clk = 1'b0;
    always #5 clk = ~clk; // 100MHz equivalent

    // test counters
    integer test_count;
    integer error_count;

    // expected outputs (for next cycle)
    reg [3:0] exp_result_q;
    reg       exp_slt_q;
    reg       exp_zero_q;
    reg       exp_carry_q;
    reg       exp_ovf_q;
    reg       exp_valid_q;

    // comb expected (from golden model)
    reg [3:0] exp_result_comb;
    reg       exp_slt_comb;
    reg       exp_zero_comb;
    reg       exp_carry_comb;
    reg       exp_ovf_comb;

    // -------------- Golden reference model --------------
    task calc_expected;
        reg [4:0] tmp;
        begin
            exp_result_comb = 4'b0000;
            exp_slt_comb    = 1'b0;
            exp_carry_comb  = 1'b0;
            exp_ovf_comb    = 1'b0;

            case (OpCode)
                OP_ADD: begin
                    tmp            = {1'b0, A} + {1'b0, B};
                    exp_result_comb= tmp[3:0];
                    exp_carry_comb = tmp[4];
                    exp_ovf_comb   = (A[3] == B[3]) && (exp_result_comb[3] != A[3]);
                end

                OP_SUB: begin
                    tmp            = {1'b0, A} - {1'b0, B};
                    exp_result_comb= tmp[3:0];
                    exp_carry_comb = tmp[4];
                    exp_ovf_comb   = (A[3] != B[3]) && (exp_result_comb[3] != A[3]);
                end

                OP_AND: begin
                    exp_result_comb = A & B;
                end

                OP_OR: begin
                    exp_result_comb = A | B;
                end

                OP_XOR: begin
                    exp_result_comb = A ^ B;
                end

                OP_SLT: begin
                    if ($signed(A) < $signed(B)) begin
                        exp_slt_comb    = 1'b1;
                        exp_result_comb = 4'd1;
                    end else begin
                        exp_slt_comb    = 1'b0;
                        exp_result_comb = 4'd0;
                    end
                end

                default: begin
                    exp_result_comb = 4'b0000;
                end
            endcase

            exp_zero_comb = (exp_result_comb == 4'b0000);
        end
    endtask
    // ----------------------------------------------------

    // -------------- Scoreboard with 1-cycle delay --------------
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            exp_valid_q   <= 1'b0;
            exp_result_q  <= 4'b0000;
            exp_slt_q     <= 1'b0;
            exp_zero_q    <= 1'b0;
            exp_carry_q   <= 1'b0;
            exp_ovf_q     <= 1'b0;
            test_count    <= 0;
            error_count   <= 0;
        end else begin
            // 1) Check previous expected against current DUT outputs
           // 1) Check previous expected against current DUT outputs
if (exp_valid_q && out_valid) begin
    test_count <= test_count + 1;

    if ( (Result        !== exp_result_q) ||
         (SLT_Flag      !== exp_slt_q)   ||
         (Zero_Flag     !== exp_zero_q)  ||
         (Carry_Flag    !== exp_carry_q) ||
         (Overflow_Flag !== exp_ovf_q) ) begin

        $display("TEST %0d FAIL:", test_count);
        $display("  Expected: R=0x%0h SLT=%b Z=%b C=%b OVF=%b",
                 exp_result_q, exp_slt_q, exp_zero_q,
                 exp_carry_q, exp_ovf_q);
        $display("  Actual  : R=0x%0h SLT=%b Z=%b C=%b OVF=%b",
                 Result, SLT_Flag, Zero_Flag, Carry_Flag, Overflow_Flag);

        error_count <= error_count + 1;
    end else begin
        $display("TEST %0d PASS", test_count);
    end
end

            // 2) Compute new expected outputs for current input if in_valid
            if (in_valid) begin
                calc_expected();
                exp_result_q <= exp_result_comb;
                exp_slt_q    <= exp_slt_comb;
                exp_zero_q   <= exp_zero_comb;
                exp_carry_q  <= exp_carry_comb;
                exp_ovf_q    <= exp_ovf_comb;
                exp_valid_q  <= 1'b1;
            end else begin
                exp_valid_q  <= 1'b0;
            end
        end
    end
    // ------------------------------------------------------------

    // -------------- Stimulus: directed + random --------------
    integer k;
    integer rnd;

    initial begin
        // init
        rst_n    = 1'b0;
        in_valid = 1'b0;
        A        = 4'd0;
        B        = 4'd0;
        OpCode   = OP_ADD;

        // reset phase
        #25;
        rst_n = 1'b1;

        // start continuous valid stream
        @(posedge clk);
        in_valid = 1'b1;

        $display("==== DAY-4 Pipelined ALU Tests Start ====");

        // ---------- Directed tests ----------
        OpCode = OP_ADD; A = 4'd5;  B = 4'd3;  @(posedge clk);
        OpCode = OP_ADD; A = 4'd10; B = 4'd5;  @(posedge clk);
        OpCode = OP_ADD; A = 4'd15; B = 4'd1;  @(posedge clk);

        OpCode = OP_SUB; A = 4'd10; B = 4'd3;  @(posedge clk);
        OpCode = OP_SUB; A = 4'd5;  B = 4'd5;  @(posedge clk);
        OpCode = OP_SUB; A = 4'd3;  B = 4'd10; @(posedge clk);

        OpCode = OP_AND; A = 4'b1101; B = 4'b0111; @(posedge clk);
        OpCode = OP_OR;  A = 4'b1101; B = 4'b0110; @(posedge clk);
        OpCode = OP_XOR; A = 4'b1101; B = 4'b0110; @(posedge clk);

        OpCode = OP_SLT; A = 4'd5;   B = 4'd10; @(posedge clk);
        OpCode = OP_SLT; A = 4'd10;  B = 4'd5;  @(posedge clk);
        OpCode = OP_SLT; A = 4'b1001; B = 4'b0010; @(posedge clk); // -7 < 2

        $display("==== Directed tests done, running random tests ====");

        // ---------- Random tests ----------
        for (k = 0; k < 40; k = k + 1) begin
            rnd    = $random;
            A      = rnd[3:0];
            rnd    = $random;
            B      = rnd[3:0];
            rnd    = $random;
            OpCode = rnd[2:0];  // 0..7 (so we also hit default case)

            @(posedge clk);
        end

        // stop sending new inputs
        in_valid = 1'b0;

        // allow pipeline to flush (one extra cycle)
        @(posedge clk);
        @(posedge clk);

        $display("==== Tests complete: total=%0d, errors=%0d ====",
                 test_count, error_count);
        if (error_count == 0)
            $display("ALL TESTS PASSED (Day-4 Pipelined ALU)");
        else
            $display("%0d TEST(S) FAILED", error_count);

        #10;
        $finish;
    end

endmodule

