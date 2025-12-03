// rtl/alu.v-DAY!
// 4-bit ALU (ADD, SUB, AND, OR, XOR, SLT)
// - Uses a 5-bit internal temp for add/sub to capture carry/overflow
// - SLT uses signed 4-bit comparison
// - Deterministic defaults (no 'X' in RTL)

module ALU (
    input  wire [3:0] A,
    input  wire [3:0] B,
    input  wire [2:0] OpCode,
    output reg  [3:0] Result,
    output reg         SLT_Flag,
    output reg         Zero_Flag
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
        Result   = 4'b0000;
        SLT_Flag = 1'b0;
        tmp      = 5'b0;

        case (OpCode)
            OP_ADD: begin
                tmp    = {1'b0, A} + {1'b0, B}; // zero-extend to 5 bits
                Result = tmp[3:0];
                // carry/overflow is tmp[4] if you need it later
            end

            OP_SUB: begin
                // Use 5-bit signed-aware subtraction if you want carry/borrow:
                tmp    = {1'b0, A} - {1'b0, B}; // result truncated to 4 bits
                Result = tmp[3:0];
                // borrow is tmp[4] (depending on interpretation)
            end

            OP_AND: begin
                Result = A & B;
            end

            OP_OR: begin
                Result = A | B;
            end

            OP_XOR: begin
                Result = A ^ B;
            end

            OP_SLT: begin
                // Signed comparison on 4-bit two's complement values
                // Use $signed to interpret A and B as signed 4-bit numbers
                if ($signed(A) < $signed(B)) begin
                    SLT_Flag = 1'b1;
                    Result   = 4'd1;
                end else begin
                    SLT_Flag = 1'b0;
                    Result   = 4'd0;
                end
            end

            default: begin
                // Safe default: zero output and clear flags
                Result   = 4'b0000;
                SLT_Flag = 1'b0;
            end
        endcase

        // Zero Flag: asserted when Result == 0
        Zero_Flag = (Result == 4'b0000);
    end

endmodule

