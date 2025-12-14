module top_day13 (
    input clk,
    input rstn,

    output [7:0] pc,
    output [7:0] alu_out
);

    wire [19:0] instr_if, instr_id;
    wire [3:0] opcode_id, opcode_ex;
    wire [7:0] A_id, B_id;
    wire [7:0] A_ex, B_ex;
    wire [7:0] alu_raw;
    wire forward_en;

    // IF
   wire [7:0]  pc;
wire [19:0] instr_if;

if_stage IF (
    .clk(clk),
    .rstn(rstn),
    .stall(1'b0),
    .pc(pc),
    .instr(instr_if)
);

    // IF/ID
    pipe_if_id IFID (
        .clk(clk),
        .rstn(rstn),
        .stall(1'b0),
        .pc_in(pc),
        .instr_in(instr_if),
        .pc_out(),
        .instr_out(instr_id)
    );

    // ID
    id_stage ID (
        .instr(instr_id),
        .opcode(opcode_id),
        .A(A_id),
        .B(B_id)
    );

    // ID/EX
    pipe_id_ex IDEX (
        .clk(clk),
        .rstn(rstn),
        .stall(1'b0),
        .opcode_in(opcode_id),
        .A_in(A_id),
        .B_in(B_id),
        .opcode_out(opcode_ex),
        .A_out(A_ex),
        .B_out(B_ex)
    );

    // Forwarding (simple)
    forwarding_unit FU (
        .opcode_ex(opcode_ex),
        .opcode_prev(opcode_id),
        .forward_enable(forward_en)
    );

    // ALU
    alu ALU (
        .A(forward_en ? alu_raw : A_ex),
        .B(B_ex),
        .opcode(opcode_ex),
        .result(alu_raw)
    );

    assign alu_out = alu_raw;

endmodule

