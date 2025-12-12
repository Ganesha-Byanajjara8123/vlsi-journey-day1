`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12.12.2025 17:49:16
// Design Name: 
// Module Name: top_day11_TBv
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module top_day11_TBv;

    // signals
    reg        clk;
    reg        rstn;
    wire [7:0] pc;
    wire [19:0] instr;
    wire [7:0] pc_id;
    wire [19:0] instr_id;
    wire [3:0] opcode;
    wire [7:0] A, B;

    // -----------------------------------------------------------------
    // Instantiate IF stage (must match your if_stage port names)
    // -----------------------------------------------------------------
    if_stage IF (
        .clk(clk),
        .rstn(rstn),
        .stall(1'b0),
        .pc_out(pc),
        .instr_out(instr)
    );

    // -----------------------------------------------------------------
    // IF/ID pipeline register (must match your pipe_if_id port names)
    // -----------------------------------------------------------------
    pipe_if_id PIPE (
        .clk(clk),
        .rstn(rstn),
        .stall(1'b0),
        .pc_in(pc),
        .instr_in(instr),
        .pc_out(pc_id),
        .instr_out(instr_id)
    );

    // -----------------------------------------------------------------
    // ID decode stage
    // -----------------------------------------------------------------
    id_stage ID (
        .instr(instr_id),
        .opcode(opcode),
        .A(A),
        .B(B)
    );

    // -----------------------------------------------------------------
    // Clock generation
    // -----------------------------------------------------------------
    initial begin
        clk = 1'b0;
        forever #5 clk = ~clk; // 100 MHz style for sim clarity
    end

    // -----------------------------------------------------------------
    // Test sequence
    // -----------------------------------------------------------------
    initial begin
        // wave dump for waveform viewers
        $dumpfile("day11.vcd");
       $dumpvars(0, top_day11_TBv);


        // reset
        rstn = 1'b0;
        #20;
        rstn = 1'b1;

        // run for some cycles to let PC advance through instr_mem
        #400;

        // quick checks (optional): show first few values
        $display("PC after reset: %0d, instr[19:0]=%h", pc, instr);

        #10;
        $finish;
    end

endmodule

