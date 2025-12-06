// ===============================
// DAY-6 MULTI-CYCLE ALU WITH HANDSHAKE
// ===============================

module ALU_Multicycle_Handshake (
    input wire         clk,
    input wire         rst,

    // Handshake input
    input wire         in_valid,
    output wire        in_ready,

    // Data input
    input wire [3:0]   A,
    input wire [3:0]   B,
    input wire [2:0]   OpCode,

    // Handshake output
    output reg         out_valid,

    // Data output
    output reg [7:0]   Result,

    // Status
    output reg         busy
);

    // Opcodes
    localparam OP_ADD = 3'b000,
               OP_SUB = 3'b001,
               OP_AND = 3'b010,
               OP_OR  = 3'b011,
               OP_XOR = 3'b100,
               OP_SLT = 3'b101,
               OP_MUL = 3'b110;

    // FSM states
    localparam IDLE = 0,
               EXEC = 1,
               DONE = 2;

    reg [1:0] state, next_state;

    // Internal registers
    reg [3:0] A_reg, B_reg;
    reg [2:0] Op_reg;
    reg [2:0] cycle_cnt;
    reg [7:0] mul_temp;

    // Ready only when IDLE
    assign in_ready = (state == IDLE);

    // FSM state control
    always @(posedge clk or posedge rst) begin
        if (rst)
            state <= IDLE;
        else
            state <= next_state;
    end

    // Next state logic
    always @(*) begin
        next_state = state;
        case (state)

            IDLE: begin
                if (in_valid)
                    next_state = EXEC;
            end

            EXEC: begin
                if (Op_reg == OP_MUL) begin
                    if (cycle_cnt == 3)
                        next_state = DONE;
                end else begin
                    next_state = DONE;  // 1-cycle ops
                end
            end

            DONE: begin
                next_state = IDLE;
            end
        endcase
    end

    // Main datapath
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            busy      <= 0;
            out_valid <= 0;
            Result    <= 0;
            cycle_cnt <= 0;

        end else begin
            out_valid <= 0;  // default

            case (state)

                // =========================
                // IDLE → Accept Inputs
                // =========================
                IDLE: begin
                    busy <= 0;
                    if (in_valid) begin
                        A_reg  <= A;
                        B_reg  <= B;
                        Op_reg <= OpCode;
                        cycle_cnt <= 0;
                        busy <= 1;
                    end
                end

                // =========================
                // EXEC → Perform Operation
                // =========================
                EXEC: begin
                    
                    if (Op_reg == OP_MUL) begin
                        // multi-cycle: 4 cycles
                        if (cycle_cnt == 0)
                            mul_temp <= A_reg * B_reg;
                        
                        cycle_cnt <= cycle_cnt + 1;

                        if (cycle_cnt == 3)
                            Result <= mul_temp;

                    end else begin
                        // single-cycle ops
                        case (Op_reg)
                            OP_ADD: Result <= A_reg + B_reg;
                            OP_SUB: Result <= A_reg - B_reg;
                            OP_AND: Result <= A_reg & B_reg;
                            OP_OR : Result <= A_reg | B_reg;
                            OP_XOR: Result <= A_reg ^ B_reg;
                            OP_SLT: Result <= ($signed(A_reg) < $signed(B_reg)) ? 8'd1 : 8'd0;
                            default: Result <= 8'hXX;
                        endcase
                    end
                end

                // =========================
                // DONE → Output valid
                // =========================
                DONE: begin
                    out_valid <= 1;
                    busy      <= 0;
                end

            endcase
        end
    end

endmodule

