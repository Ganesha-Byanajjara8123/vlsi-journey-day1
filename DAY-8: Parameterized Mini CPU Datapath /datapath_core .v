`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08.12.2025 18:53:49
// Design Name: 
// Module Name: datapath_core
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

// ==========================================================
// DAY-8 PARAMETERIZED MINI CPU DATAPATH (Stage-1)
// ==========================================================
// Supports:
// ADD, SUB, AND, OR, XOR, SLT, SLL, SRL
// Generates: Zero, Negative, Carry, Overflow
// Parameterizable WIDTH: 8, 16, 32
// ==========================================================

module datapath_core #(
    parameter WIDTH = 8
)(
    input  wire [WIDTH-1:0] A,
    input  wire [WIDTH-1:0] B,
    input  wire [3:0]       OpCode,   // ALU + Shifter opcodes
    output reg  [WIDTH-1:0] Result,
    output wire             Zero,
    output wire             Neg,
    output reg              Carry,
    output reg              Overflow
);

    // Internal signals
    reg [WIDTH-1:0] alu_res;
    reg [WIDTH-1:0] shift_res;
    reg [WIDTH:0]   tmp;  // for detecting carry/overflow

    // ---------------------------------------------
    // 1) ALU CORE
    // ---------------------------------------------
    always @(*) begin
        alu_res = {WIDTH{1'b0}};
        Carry   = 1'b0;
        Overflow= 1'b0;
        tmp     = {WIDTH+1{1'b0}};

        case (OpCode)
            4'b0000: begin   // ADD
                tmp     = A + B;
                alu_res = tmp[WIDTH-1:0];
                Carry   = tmp[WIDTH];  // unsigned carry-out
                // Signed overflow detection
                Overflow = (A[WIDTH-1] == B[WIDTH-1]) &&
                           (alu_res[WIDTH-1] != A[WIDTH-1]);
            end

            4'b0001: begin   // SUB
                tmp     = A - B;
                alu_res = tmp[WIDTH-1:0];
                Carry   = tmp[WIDTH]; // borrow info (not very meaningful)
                Overflow = (A[WIDTH-1] != B[WIDTH-1]) &&
                           (alu_res[WIDTH-1] != A[WIDTH-1]);
            end

            4'b0010: alu_res = A & B; // AND
            4'b0011: alu_res = A | B; // OR
            4'b0100: alu_res = A ^ B; // XOR

            4'b0101: begin  // SLT (signed)
                alu_res = ($signed(A) < $signed(B)) ? {{(WIDTH-1){1'b0}},1'b1}
                                                    : {WIDTH{1'b0}};
            end
        endcase
    end

    // ---------------------------------------------
    // 2) SHIFTER UNIT
    // ---------------------------------------------
    always @(*) begin
        case (OpCode)
            4'b0110: shift_res = A << B[($clog2(WIDTH)-1):0]; // SLL
            4'b0111: shift_res = A >> B[($clog2(WIDTH)-1):0]; // SRL
            default: shift_res = {WIDTH{1'b0}};
        endcase
    end

    // ---------------------------------------------
    // 3) FINAL RESULT SELECT
    // ---------------------------------------------
    always @(*) begin
        case (OpCode)
            4'b0000,4'b0001,4'b0010,4'b0011,4'b0100,4'b0101:
                Result = alu_res;

            4'b0110,4'b0111:
                Result = shift_res;

            default:
                Result = {WIDTH{1'b0}};
        endcase
    end

    // ---------------------------------------------
    // FLAG UNIT
    // ---------------------------------------------
    assign Zero = (Result == {WIDTH{1'b0}});
    assign Neg  = Result[WIDTH-1];

endmodule


