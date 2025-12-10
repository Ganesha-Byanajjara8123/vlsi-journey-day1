`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10.12.2025 22:29:42
// Design Name: 
// Module Name: top_cpu
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


// top_cpu.v
module top_cpu (
    input clk, rstn,
    input [3:0] instr,
    input [7:0] inA, inB,
    output [7:0] result,
    output zero, neg, carry, ovf
);
    // datapath instance (assumes datapath_core uses A,B,OpCode and outputs flags)
    wire dp_ready;
    wire [7:0] dp_res;
    wire dp_z, dp_n, dp_c, dp_v;

    // control outputs
    wire [7:0] dp_A, dp_B;
    wire [3:0] dp_op;
    wire dp_start;
    wire [1:0] state_out;

    ctrl_fsm u_ctrl(
        .clk(clk), .rstn(rstn),
        .instr(instr),
        .A(inA), .B(inB),
        .dp_A(dp_A), .dp_B(dp_B), .dp_op(dp_op), .dp_start(dp_start),
        .dp_ready(dp_ready),
        .dp_result(dp_res),
        .dp_zero(dp_z),
        .dp_neg(dp_n),
        .dp_carry(dp_c),
        .dp_ovf(dp_v),
        .state_out(state_out)
    );

    // datapath_core must be adapted to have handshake signals if combinational:
    // treat dp_ready = 1'b1 for pure combinational; or make it combinational ready
    datapath_core #(.WIDTH(8)) u_dp (
        .A(dp_A), .B(dp_B), .OpCode(dp_op),
        .Result(result), .Zero(zero), .Neg(neg), .Carry(carry), .Overflow(ovf)
    );

    // If datapath_core is combinational, set dp_ready = 1
    assign dp_ready = 1'b1; // immediate ready

endmodule


