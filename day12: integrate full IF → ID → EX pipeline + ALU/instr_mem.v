
module instr_mem #(parameter WIDTH=8, DEPTH=256) (
    input  wire [7:0] addr,
    output reg  [19:0] instr   // 4 + 8 + 8 = 20 bits
);
    // memory: 20-bit wide words, DEPTH entries
    reg [19:0] mem [0:DEPTH-1];
    integer i;

    initial begin
        // default-clear full ROM to avoid X propagation when PC runs past program
        for (i = 0; i < DEPTH; i = i + 1) mem[i] = 20'h00000;

        // program (low addresses)
        mem[0] = {4'b0000, 8'h05, 8'h03}; // ADD 5 + 3
        mem[1] = {4'b0001, 8'h0A, 8'h03}; // SUB 10 - 3
        mem[2] = {4'b0010, 8'hF0, 8'h0F}; // AND
        mem[3] = {4'b0011, 8'hAA, 8'h55}; // OR
        mem[4] = {4'b0100, 8'hC3, 8'h3C}; // XOR
        mem[5] = {4'b0101, 8'h02, 8'h05}; // SLT
        mem[6] = {4'b0110, 8'h0F, 8'h02}; // SLL
        mem[7] = {4'b0111, 8'hF0, 8'h03}; // SRL
        // rest remain zeroed
    end

    // combinational read
    always @(*) begin
        instr = mem[addr];
    end
endmodule

