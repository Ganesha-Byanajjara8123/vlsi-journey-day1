
// DAY5 Advanced ALU
module ALU_Day5 (
    input  wire [3:0] A,
    input  wire [3:0] B,
    input  wire [3:0] OpCode,
    output reg  [3:0] Result,
    output reg        Zero_Flag,
    output reg        Negative_Flag,
    output reg        Parity_Flag,
    output reg        SLT_Flag
);

    // Local shift amount
    wire [1:0] shamt = B[1:0];
    wire [1:0] mode  = B[3:2];

    always @* begin

        // Default outputs
        Result        = 4'b0000;
        SLT_Flag      = 1'b0;
        Negative_Flag = 1'b0;
        Parity_Flag   = 1'b0;

        case (OpCode)

            // ===== BASIC OPS =====
            4'b0000: Result = A + B;          // ADD
            4'b0001: Result = A - B;          // SUB
            4'b0010: Result = A & B;          // AND
            4'b0011: Result = A | B;          // OR
            4'b0100: Result = A ^ B;          // XOR

            // ===== SIGNED LESS-THAN =====
            4'b0101: begin
                SLT_Flag = ($signed(A) < $signed(B));
                Result   = SLT_Flag ? 4'd1 : 4'd0;
            end

            // ===== SHIFT UNIT =====
            4'b0110: begin
                case (mode)
                    2'b00: Result = A << shamt;                     // SLL
                    2'b01: Result = A >> shamt;                     // SRL
                    2'b10: Result = $signed(A) >>> shamt;           // SRA
                    default: Result = 4'b0000;
                endcase
            end

            // ===== ROTATE UNIT =====
            4'b0111: begin
                case (mode)
                    2'b00: Result = (A << shamt) | (A >> (4 - shamt)); // ROL
                    2'b01: Result = (A >> shamt) | (A << (4 - shamt)); // ROR
                    default: Result = 4'b0000;
                endcase
            end

            // MUL reserved for Day 6 (multi-cycle)
            default: Result = 4'b0000;
        endcase

        // ===== FLAGS =====
        Zero_Flag     = (Result == 4'b0000);
        Negative_Flag = Result[3];
        Parity_Flag   = ^Result;

    end
endmodule

