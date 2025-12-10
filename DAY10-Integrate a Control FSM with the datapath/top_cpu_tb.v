`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10.12.2025 22:30:16
// Design Name: 
// Module Name: top_cpu_tb
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

`timescale 1ns/1ps

module top_cpu_tb;

    localparam WIDTH = 8;
    localparam CLK_PERIOD = 10;
    integer i;

    // DUT inputs
    reg clk;
    reg rstn;
    reg [3:0] instr;
    reg [7:0] inA, inB;

    // DUT outputs
    wire [7:0] result;
    wire zero, neg, carry, ovf;

    // Instantiate DUT
    top_cpu dut (
        .clk(clk),
        .rstn(rstn),
        .instr(instr),
        .inA(inA),
        .inB(inB),
        .result(result),
        .zero(zero),
        .neg(neg),
        .carry(carry),
        .ovf(ovf)
    );

    // Clock
    always #(CLK_PERIOD/2) clk = ~clk;

    //-----------------------------------------------------------
    // GOLDEN MODEL (matches datapath_core behavior)
    //-----------------------------------------------------------
    task golden;
        input [7:0] A, B;
        input [3:0] op;
        output [7:0] r;
        output gz, gn, gc, gv;

        reg [8:0] tmp;
        reg signed [7:0] SA, SB;

        begin
            r  = 0; gc = 0; gv = 0;

            case(op)
                4'b0000: begin // ADD
                    tmp = A + B;
                    r   = tmp[7:0];
                    gc  = tmp[8];
                    gv  = (A[7] == B[7]) && (r[7] != A[7]);
                end

                4'b0001: begin // SUB
                    tmp = A - B;
                    r   = tmp[7:0];
                    gc  = tmp[8];
                    gv  = (A[7] != B[7]) && (r[7] != A[7]);
                end

                4'b0010: r = A & B;
                4'b0011: r = A | B;
                4'b0100: r = A ^ B;

                4'b0101: begin // SLT signed
                    SA = A; SB = B;
                    r = (SA < SB) ? 8'h01 : 8'h00;
                end

                4'b0110: r = A << (B[2:0]);
                4'b0111: r = A >> (B[2:0]);

                default: r = 0;
            endcase

            gz = (r == 8'h00);
            gn = r[7];
        end
    endtask

    //-----------------------------------------------------------
    // RUN ONE TEST
    //-----------------------------------------------------------
    task run_one(input [7:0] A, B, input [3:0] op);
        reg [7:0] gr;
        reg gz, gn, gc, gv;
        begin
            // apply operands
            inA = A;
            inB = B;
            #(CLK_PERIOD);

            // apply instruction
            instr = op;
            #(2*CLK_PERIOD);   // allow FSM to complete

            // golden result
            golden(A, B, op, gr, gz, gn, gc, gv);

            // compare
            if (result !== gr ||
                zero   !== gz ||
                neg    !== gn ||
                carry  !== gc ||
                ovf    !== gv)
            begin
                $display("FAIL: A=%h B=%h OP=%b => DUT=%h (z=%b n=%b c=%b v=%b), EXP=%h (z=%b n=%b c=%b v=%b)",
                         A,B,op,result,zero,neg,carry,ovf,
                         gr,gz,gn,gc,gv);
            end
            else begin
                $display("PASS: A=%h B=%h OP=%b => R=%h", A,B,op,result);
            end

            instr = 0; // clear instruction for safety
            #(CLK_PERIOD);
        end
    endtask

    //-----------------------------------------------------------
    // MAIN TB
    //-----------------------------------------------------------
    initial begin
        clk   = 0;
        rstn  = 0;
        instr = 0;
        inA   = 0;
        inB   = 0;

        // Reset sequence
        #(3*CLK_PERIOD);
        rstn = 1;                     // release reset
        #(2*CLK_PERIOD);

        $display("=== DAY-10 CPU TEST START ===");

        // directed tests
        run_one(8'h05, 8'h03, 4'b0000); // ADD
        run_one(8'h0A, 8'h03, 4'b0001); // SUB
        run_one(8'hF0, 8'h0F, 4'b0010); // AND
        run_one(8'hAA, 8'h55, 4'b0011); // OR
        run_one(8'hC3, 8'h3C, 4'b0100); // XOR
        run_one(8'h02, 8'h05, 4'b0101); // SLT
        run_one(8'h0F, 8'h02, 4'b0110); // SLL
        run_one(8'hF0, 8'h03, 4'b0111); // SRL

        // random tests
        for (i=0; i<50; i=i+1) begin
            run_one($random, $random, $random % 8);
        end

        $display("=== DAY-10 CPU TEST COMPLETE ===");
        $finish;
    end

endmodule

