module forwarding_unit (
    input  [3:0] opcode_ex,
    input  [3:0] opcode_prev,
    output reg   forward_enable
);

    always @(*) begin
        // simplistic hazard assumption
        if (opcode_ex == opcode_prev)
            forward_enable = 1'b1;
        else
            forward_enable = 1'b0;
    end

endmodule

