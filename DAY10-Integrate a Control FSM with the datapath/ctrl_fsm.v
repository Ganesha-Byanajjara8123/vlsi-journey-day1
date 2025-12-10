`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10.12.2025 22:29:14
// Design Name: 
// Module Name: ctrl_fsm
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

// ctrl_fsm.v
module ctrl_fsm (
    input           clk,
    input           rstn,
    input  [3:0]    instr,    // instruction code
    input  [7:0]    A,
    input  [7:0]    B,
    // datapath interface (simple)
    output reg [7:0] dp_A,
    output reg [7:0] dp_B,
    output reg [3:0] dp_op,
    output reg       dp_start,
    input            dp_ready,
    input  [7:0]     dp_result,
    input            dp_zero,
    input            dp_neg,
    input            dp_carry,
    input            dp_ovf,
    output reg [1:0] state_out // debug
);

    localparam IDLE  = 2'd0;
    localparam ISSUE = 2'd1;
    localparam WAIT  = 2'd2;
    localparam DONE  = 2'd3;

    always @(posedge clk or negedge rstn) begin
        if (!rstn) begin
            dp_A     <= 0;
            dp_B     <= 0;
            dp_op    <= 0;
            dp_start <= 0;
            state_out<= IDLE;
        end else begin
            case (state_out)
                IDLE: begin
                    // load operands & issue when instruction provided (non-zero)
                    if (instr !== 4'bxxxx) begin
                        dp_A  <= A;
                        dp_B  <= B;
                        dp_op <= instr;
                        dp_start <= 1'b1;
                        state_out <= ISSUE;
                    end else begin
                        dp_start <= 1'b0;
                    end
                end
                ISSUE: begin
                    dp_start <= 1'b0; // pulse start
                    state_out <= WAIT;
                end
                WAIT: begin
                    if (dp_ready) begin
                        // optionally capture dp_result somewhere or emit done
                        state_out <= DONE;
                    end
                end
                DONE: begin
                    // stay here until external clears instr or reset
                    state_out <= IDLE;
                end
                default: state_out <= IDLE;
            endcase
        end
    end

endmodule


