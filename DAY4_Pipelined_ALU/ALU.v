// DAY4_Pipelined_ALU/ALU_PIPELINED.v
// 4-bit ALU with 1-cycle pipeline latency
// - Inputs sampled when in_valid=1
// - Outputs and flags registered, appear with out_valid=1 on next cycle

module ALU_PIPELINED (
    input  wire        clk,
    input  wire        rst_n,
    input  wire        in_valid,
    input  wire [3:0]  A,
    input  wire [3:0]  B,
    input  wire [2:0]  OpCode,
    output reg         out_valid,
    output reg  [3:0]  Result,
    output reg         SLT_Flag,
    output reg         Zero_Flag,
    output reg         Carry_Flag,
    output reg         Overflow_Flag
);

    // Opcode encodings
    localparam OP_ADD = 3'b000;
    localparam OP_SUB = 3'b001;
    localparam OP_AND = 3'b010;
    localparam OP_OR  = 3'b011;
    localparam OP_XOR = 3'b100;
    localparam OP_SLT = 3'b101;

    // Combinational "next" values for pipeline
    reg [3:0] result_next;
    reg       slt_next;
    reg       zero_next;
    reg       carry_next;
    reg       ovf_next;

    reg [4:0] tmp;

    // ---------------- COMBINATIONAL STAGE ----------------
    always @* begin
        // defaults
        result_next = 4'b0000;
        slt_next    = 1'b0;
        carry_next  = 1'b0;
        ovf_next    = 1'b0;
        tmp         = 5'b0;

        case (OpCode)
            OP_ADD: begin
                tmp         = {1'b0, A} + {1'b0, B};
                result_next = tmp[3:0];
                carry_next  = tmp[4]; // unsigned carry
                ovf_next    = (A[3] == B[3]) && (result_next[3] != A[3]); // signed ovf
            end

            OP_SUB: begin
                tmp         = {1'b0, A} - {1'b0, B};
                result_next = tmp[3:0];
                carry_next  = tmp[4]; // borrow-related info
                ovf_next    = (A[3] != B[3]) && (result_next[3] != A[3]); // signed ovf
            end

            OP_AND: begin
                result_next = A & B;
            end

            OP_OR: begin
                result_next = A | B;
            end

            OP_XOR: begin
                result_next = A ^ B;
            end

            OP_SLT: begin
                if ($signed(A) < $signed(B)) begin
                    slt_next    = 1'b1;
                    result_next = 4'd1;
                end else begin
                    slt_next    = 1'b0;
                    result_next = 4'd0;
                end
            end

            default: begin
                result_next = 4'b0000;
            end
        endcase

        zero_next = (result_next == 4'b0000);
    end

    // ---------------- PIPELINE REGISTER STAGE ----------------
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            Result        <= 4'b0000;
            SLT_Flag      <= 1'b0;
            Zero_Flag     <= 1'b0;
            Carry_Flag    <= 1'b0;
            Overflow_Flag <= 1'b0;
            out_valid     <= 1'b0;
        end else begin
            // out_valid is just in_valid delayed by one cycle
            out_valid <= in_valid;

            if (in_valid) begin
                Result        <= result_next;
                SLT_Flag      <= slt_next;
                Zero_Flag     <= zero_next;
                Carry_Flag    <= carry_next;
                Overflow_Flag <= ovf_next;
            end
            // if in_valid=0, outputs hold previous values; out_valid=0 tells TB to ignore them
        end
    end

endmodule

