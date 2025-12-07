`timescale 1ns/1ps

module shift_encode_TB;

    // Inputs to DUT
    reg  [7:0] in;
    reg  [2:0] shamt;
    reg  [1:0] mode;

    // Outputs from DUT
    wire [7:0] shifted;
    wire [2:0] pe_out;
    wire       pe_valid;

    // Instantiate DUT
    shift_encode_unit dut (
        .in     (in),
        .shamt  (shamt),
        .mode   (mode),
        .shifted(shifted),
        .pe_out (pe_out),
        .pe_valid(pe_valid)
    );

    // Golden reference variables
    reg [7:0] exp_shift;
    reg [2:0] exp_pe;
    reg       exp_valid;

    integer i;
    integer errors;

    initial begin
        errors = 0;
        $display("=== DAY-7 TEST START ===");

        // 50 random tests
        for (i = 0; i < 50; i = i + 1) begin
            in    = $random;
            shamt = $random;
            mode  = $random;

            #1; // allow combinational logic to settle

            // --------------------------
            // Golden SHIFT model
            // --------------------------
            case (mode)
                2'b00: exp_shift = in << shamt;                    // logical left
                2'b01: exp_shift = in >> shamt;                    // logical right
                2'b10: exp_shift = (in << shamt) | (in >> (8-shamt)); // rotate left
                2'b11: exp_shift = (in >> shamt) | (in << (8-shamt)); // rotate right
                default: exp_shift = 8'h00;
            endcase

            // --------------------------
            // Golden PRIORITY ENCODER
            // --------------------------
            exp_pe    = 3'd0;
            exp_valid = (exp_shift != 8'b0);

            if (exp_shift[7])      exp_pe = 3'd7;
            else if (exp_shift[6]) exp_pe = 3'd6;
            else if (exp_shift[5]) exp_pe = 3'd5;
            else if (exp_shift[4]) exp_pe = 3'd4;
            else if (exp_shift[3]) exp_pe = 3'd3;
            else if (exp_shift[2]) exp_pe = 3'd2;
            else if (exp_shift[1]) exp_pe = 3'd1;
            else if (exp_shift[0]) exp_pe = 3'd0;
            // if all zero, exp_pe stays 0 and exp_valid=0

            // --------------------------
            // CHECKS
            // --------------------------
            if (shifted !== exp_shift) begin
                $display("SHIFT FAIL: in=%h shamt=%0d mode=%b | exp=%h got=%h",
                         in, shamt, mode, exp_shift, shifted);
                errors = errors + 1;
            end

            if (pe_out !== exp_pe) begin
                $display("PE FAIL   : shifted=%h | exp_idx=%0d got=%0d",
                         exp_shift, exp_pe, pe_out);
                errors = errors + 1;
            end

            if (pe_valid !== exp_valid) begin
                $display("VALID FAIL: shifted=%h | exp_valid=%0b got=%0b",
                         exp_shift, exp_valid, pe_valid);
                errors = errors + 1;
            end
        end

        $display("=== DAY-7 TEST COMPLETE. errors=%0d ===", errors);
        if (errors == 0)
            $display("ALL TESTS PASSED (Day-7 Shift+Encode)");
        else
            $display("TESTS FAILED");

        $finish;
    end

endmodule

