module top_day14_tb;

    reg clk;
    reg rstn;

    wire [7:0] pc;
    wire [7:0] alu_out;

    top_day14 DUT (
        .clk(clk),
        .rstn(rstn),
        .pc(pc),
        .alu_out(alu_out)
    );

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        rstn = 0;
        #20 rstn = 1;

        #300;
        $display("PC=%d ALU_OUT=%h", pc, alu_out);
        $finish;
    end

endmodule

