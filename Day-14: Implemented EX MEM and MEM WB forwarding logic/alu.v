module alu (
    input  [7:0] A,
    input  [7:0] B,
    input  [3:0] opcode,
    output reg [7:0] result
);

    always @(*) begin
        case (opcode)
            4'b0000: result = A + B;        // ADD
            4'b0001: result = A - B;        // SUB
            4'b0010: result = A & B;        // AND
            4'b0011: result = A | B;        // OR
            4'b0100: result = A ^ B;        // XOR
            4'b0101: result = (A < B);      // SLT
            4'b0110: result = A << B[2:0];  // SLL
            4'b0111: result = A >> B[2:0];  // SRL
            default: result = 8'b0;
        endcase
    end

endmodule

