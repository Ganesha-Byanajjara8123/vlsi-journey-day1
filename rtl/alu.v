// ALU.v
module ALU (
    input [3:0] A,
    input [3:0] B,
    input [2:0] OpCode,
    output reg [3:0] Result,
    output reg SLT_Flag,
    output reg Zero_Flag
);

    // OpCode Definitions (for clarity in the testbench and main code)
    // 000: ADD
    // 001: SUB
    // 010: AND
    // 011: OR
    // 100: XOR
    // 101: SLT (Set Less Than)

    // Internal wire for subtraction carry (C_out)
    wire [4:0] Sum_Carry;
    wire [3:0] B_Sub; // B's 2's complement for subtraction

    // Generate 2's complement of B for subtraction
    // A - B = A + (~B + 1)
    // Subtraction is effectively A + (~B) + 1 (the OpCode 001 handles the +1 by setting Cin to 1)
    // For this simplified ALU, we'll use a direct adder/subtractor approach.
    // However, since we are designing a behavioral model, we can use the Verilog '+' and '-' operators directly.
    // For a structural implementation, a carry-lookahead adder would be used.
    
    // For a clean behavioral model:
    always @(*) begin
        // Reset flags
        SLT_Flag = 1'b0;
        
        case (OpCode)
            // 000: ADD (A + B)
            3'b000: begin
                Result = A + B;
            end
            
            // 001: SUB (A - B)
            3'b001: begin
                Result = A - B;
            end
            
            // 010: AND (A & B)
            3'b010: begin
                Result = A & B;
            end
            
            // 011: OR (A | B)
            3'b011: begin
                Result = A | B;
            end
            
            // 100: XOR (A ^ B)
            3'b100: begin
                Result = A ^ B;
            end
            
            // 101: SLT (Set Less Than)
            // Result is 0001 if A < B, and 0000 otherwise.
            // This is a common operation in MIPS ALUs.
            3'b101: begin
                // We use the result of A - B to determine A < B.
                // If A - B results in a negative number, A < B.
                // In 4-bit 2's complement: a result is negative if its MSB (bit 3) is 1.
                // The subtraction result is calculated as A - B (using the built-in operator).
                // The Verilog comparison operator '<' handles signed comparison for A and B.
                if ($signed(A) < $signed(B)) begin
                    SLT_Flag = 1'b1;
                    Result = 4'd1; // Result is 1
                end else begin
                    SLT_Flag = 1'b0;
                    Result = 4'd0; // Result is 0
                end
            end
            
            // Default case for undefined OpCodes
            default: begin
                Result = 4'hX; // Output 'X' (unknown) for safety
            end
        endcase
        
        // Zero Flag calculation (done after all operations)
        // Set Zero_Flag if Result is 0
        if (Result == 4'd0) begin
            Zero_Flag = 1'b1;
        end else begin
            Zero_Flag = 1'b0;
        end
        
    end // always @(*)
    
endmodule
