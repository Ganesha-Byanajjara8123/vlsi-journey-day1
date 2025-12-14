module top_day14 (
    input clk,
    input rstn,

    output [7:0] pc,
    output [7:0] alu_out
);

    // ---------------- IF ----------------
    wire [19:0] instr_if;
    if_stage IF (
        .clk(clk),
        .rstn(rstn),
        .stall(1'b0),
        .pc_out(pc),
        .instr_out(instr_if)
    );

    // ---------------- IF/ID ----------------
    wire [19:0] instr_id;
    pipe_if_id IFID (
        .clk(clk),
        .rstn(rstn),
        .stall(1'b0),
        .pc_in(pc),
        .instr_in(instr_if),
        .pc_out(),
        .instr_out(instr_id)
    );

    // ---------------- ID ----------------
    wire [3:0] opcode_id;
    wire [2:0] rs_id, rt_id, rd_id;
    wire [7:0] rf_rd1, rf_rd2;

    assign opcode_id = instr_id[19:16];
    assign rs_id     = instr_id[15:13];
    assign rt_id     = instr_id[12:10];
    assign rd_id     = instr_id[9:7];

    regfile RF (
        .clk(clk),
        .rstn(rstn),
        .we(wb_regwrite),
        .ra1(rs_id),
        .ra2(rt_id),
        .wa(wb_rd),
        .wd(wb_data),
        .rd1(rf_rd1),
        .rd2(rf_rd2)
    );

    // ---------------- ID/EX ----------------
    wire [3:0] opcode_ex;
    wire [7:0] A_ex, B_ex;
    wire [2:0] rd_ex;

    pipe_id_ex IDEX (
        .clk(clk),
        .rstn(rstn),
        .stall(1'b0),
        .opcode_in(opcode_id),
        .A_in(rf_rd1),
        .B_in(rf_rd2),
        .opcode_out(opcode_ex),
        .A_out(A_ex),
        .B_out(B_ex)
    );

    assign rd_ex = rd_id;

    // ---------------- EX ----------------
    alu ALU (
        .A(A_ex),
        .B(B_ex),
        .opcode(opcode_ex),
        .result(alu_out)
    );

    // ---------------- EX/WB ----------------
    wire        wb_regwrite;
    wire [2:0]  wb_rd;
    wire [7:0]  wb_data;

    pipe_ex_wb EXWB (
        .clk(clk),
        .rstn(rstn),
        .regwrite_in(1'b1),
        .rd_in(rd_ex),
        .alu_in(alu_out),
        .regwrite_out(wb_regwrite),
        .rd_out(wb_rd),
        .alu_out(wb_data)
    );

endmodule

