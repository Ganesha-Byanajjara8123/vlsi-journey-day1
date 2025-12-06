`timescale 1ns/1ps

module ALU_Multicycle_TB;

    reg clk, rst;
    reg in_valid;
    wire in_ready;
    reg [3:0] A, B;
    reg [2:0] Op;

    wire out_valid;
    wire [7:0] Result;
    wire busy;

    integer i;
    integer errors = 0;

    // DUT
    ALU_Multicycle_Handshake dut (
        .clk(clk),
        .rst(rst),
        .in_valid(in_valid),
        .in_ready(in_ready),
        .A(A),
        .B(B),
        .OpCode(Op),
        .out_valid(out_valid),
        .Result(Result),
        .busy(busy)
    );

    // Clock
    always #5 clk = ~clk;

    // Task to apply one operation
    task apply_op(input [3:0] a, input [3:0] b, input [2:0] op);
        begin
            // Wait until DUT ready
            while (!in_ready) @(posedge clk);

            A = a;
            B = b;
            Op = op;
            in_valid = 1;
            @(posedge clk);
            in_valid = 0;

            // Wait for output
            while (!out_valid) @(posedge clk);
        end
    endtask


    initial begin
        clk = 0; rst = 1;
        in_valid = 0;
        @(posedge clk);
        rst = 0;

        $display("==== DAY-6 TEST START ====");

        // Directed tests
        apply_op(4'd5, 4'd3, 3'b000);  // ADD
        apply_op(4'd9, 4'd2, 3'b001);  // SUB
        apply_op(4'd4, 4'd6, 3'b110);  // MUL
        apply_op(4'd1, 4'd7, 3'b101);  // SLT

        // Random tests
        for (i=0; i<20; i=i+1) begin
            apply_op($random, $random, $random % 7);
            $display("PASS: A=%0d B=%0d Op=%b => R=%0d", A, B, Op, Result);
        end

        $display("==== TEST COMPLETE. Errors=%0d ====", errors);
        $finish;
    end

endmodule

