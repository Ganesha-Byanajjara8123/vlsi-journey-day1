// rtl/alu.v
// 4-bit ALU (ADD, SUB, AND, OR, XOR, SLT)
// Day-3: add Carry_Flag (unsigned) and Overflow_Flag (signed)
// - Result: 4-bit
// - SLT_Flag: signed A < B
// - Zero_Flag: Result == 0
// - Carry_Flag: tmp[4] from ADD/SUB (unsigned carry/borrow info)
// - Overflow_Flag: signed overflow for ADD/SUB

module ALU (
    input  wire [3:0] A,
    input  wire [3:0] B,
    input  wire [2:0] OpCode,
    output reg  [3:0] Result,
    output reg        SLT_Flag,
    output reg        Zero_Flag,
    output reg        Carry_Flag,      // NEW (Day-3)
    output reg        Overflow_Flag    // NEW (Day-3)
);

    // Opcode localparams
    localparam OP_ADD = 3'b000;
    localparam OP_SUB = 3'b001;
    localparam OP_AND = 3'b010;
    localparam OP_OR  = 3'b011;
    localparam OP_XOR = 3'b100;
    localparam OP_SLT = 3'b101;

    // Internal wider temp for arithmetic to capture carry/overflow
    reg [4:0] tmp;

    always @(*) begin
        // Default safe values
        Result       = 4'b0000;
        SLT_Flag     = 1'b0;
        Zero_Flag    = 1'b0;
        Carry_Flag   = 1'b0;   // default for non-arithmetic ops
        Overflow_Flag= 1'b0;   // default for non-arithmetic ops
        tmp          = 5'b0;

        case (OpCode)
            OP_ADD: begin
                // Unsigned addition with 5-bit temp
                tmp    = {1'b0, A} + {1'b0, B};
                Result = tmp[3:0];
                // Unsigned carry-out (bit 4)
                Carry_Flag = tmp[4];
                // Signed overflow: A and B same sign, result different
                Overflow_Flag = (A[3] == B[3]) && (Result[3] != A[3]);
            end

            OP_SUB: begin
                // Unsigned subtraction with 5-bit temp
                tmp    = {1'b0, A} - {1'b0, B};
                Result = tmp[3:0];
                // For subtraction, tmp[4] carries borrow-related info.
                // We expose it as Carry_Flag and document this behavior.
                Carry_Flag = tmp[4];
                // Signed overflow: A and B different sign, result different from A
                Overflow_Flag = (A[3] != B[3]) && (Result[3] != A[3]);
            end

            OP_AND: begin
                Result = A & B;
                // Carry_Flag and Overflow_Flag remain 0
            end

            OP_OR: begin
                Result = A | B;
                // Carry_Flag and Overflow_Flag remain 0
            end

            OP_XOR: begin
                Result = A ^ B;
                // Carry_Flag and Overflow_Flag remain 0
            end

            OP_SLT: begin
                // Signed comparison on 4-bit two's complement values
                if ($signed(A) < $signed(B)) begin
                    SLT_Flag = 1'b1;
                    Result   = 4'd1;
                end else begin
                    SLT_Flag = 1'b0;
                    Result   = 4'd0;
                end
                // For SLT we don't define carry/overflow; leave them 0.
            end

            default: begin
                // Safe default: zero output and clear flags
                Result       = 4'b0000;
                SLT_Flag     = 1'b0;
                Carry_Flag   = 1'b0;
                Overflow_Flag= 1'b0;
            end
        endcase

        // Zero Flag: asserted when Result == 0
        Zero_Flag = (Result == 4'b0000);
    end

endmodule
