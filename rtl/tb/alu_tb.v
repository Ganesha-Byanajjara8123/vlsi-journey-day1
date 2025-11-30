
// ALU_TB.v
module ALU_TB;

    // Inputs to the ALU
    reg [3:0] A;
    reg [3:0] B;
    reg [2:0] OpCode;

    // Outputs from the ALU
    wire [3:0] Result;
    wire SLT_Flag;
    wire Zero_Flag;

    // Instantiate the Unit Under Test (UUT)
    ALU uut (
        .A(A),
        .B(B),
        .OpCode(OpCode),
        .Result(Result),
        .SLT_Flag(SLT_Flag),
        .Zero_Flag(Zero_Flag)
    );

    // OpCode Definitions (matching the ALU module)
    localparam OP_ADD = 3'b000;
    localparam OP_SUB = 3'b001;
    localparam OP_AND = 3'b010;
    localparam OP_OR  = 3'b011;
    localparam OP_XOR = 3'b100;
    localparam OP_SLT = 3'b101;

    // Test counter and error counter
    integer test_count = 0;
    integer error_count = 0;

    // Function to run a test and check the result
    task run_test;
        input [3:0] expected_result;
        input expected_slt;
        input expected_zero;
        input [100:0] test_name;
        
        begin
            // Wait for a short time for the combinational logic to settle
            #1; 
            
            test_count = test_count + 1;
            
            if (Result == expected_result && SLT_Flag == expected_slt && Zero_Flag == expected_zero) begin
                $display("--- Test %0d PASS: %s ---", test_count, test_name);
            end else begin
                $display("--- Test %0d **FAIL**: %s ---", test_count, test_name);
                $display("       Inputs: A=%d, B=%d, OpCode=%b", A, B, OpCode);
                $display("       Expected Result=%d, SLT=%b, Zero=%b", expected_result, expected_slt, expected_zero);
                $display("       Actual   Result=%d, SLT=%b, Zero=%b", Result, SLT_Flag, Zero_Flag);
                error_count = error_count + 1;
            end
        end
    endtask

    initial begin
        $display("-------------------------------------------");
        $display("   4-bit ALU Testbench Simulation Start    ");
        $display("-------------------------------------------");

        // ---------------------------------------------------
        // 1. ADDITION TESTS (OpCode 000)
        // ---------------------------------------------------
        OpCode = OP_ADD;
        A = 4'd5; B = 4'd3;  // 5 + 3 = 8
        run_test(4'd8, 1'b0, 1'b0, "ADD: 5 + 3 = 8"); 
        
        A = 4'd10; B = 4'd5; // 10 + 5 = 15 (Max 4-bit is 15)
        run_test(4'd15, 1'b0, 1'b0, "ADD: 10 + 5 = 15"); 
        
        A = 4'd1; B = 4'd0;  // 1 + 0 = 1
        run_test(4'd1, 1'b0, 1'b0, "ADD: 1 + 0 = 1"); 

        A = 4'd15; B = 4'd1; // 15 + 1 = 16 (overflow, result is 0)
        run_test(4'd0, 1'b0, 1'b1, "ADD: 15 + 1 = 0 (Overflow)"); 

        // ---------------------------------------------------
        // 2. SUBTRACTION TESTS (OpCode 001)
        // ---------------------------------------------------
        OpCode = OP_SUB;
        A = 4'd10; B = 4'd3; // 10 - 3 = 7
        run_test(4'd7, 1'b0, 1'b0, "SUB: 10 - 3 = 7"); 
        
        A = 4'd5; B = 4'd5;  // 5 - 5 = 0 (Zero Flag test)
        run_test(4'd0, 1'b0, 1'b1, "SUB: 5 - 5 = 0 (Zero)"); 
        
        A = 4'd3; B = 4'd10; // 3 - 10 = -7 (In 4-bit 2's complement: -7 is 1001)
        run_test(4'b1001, 1'b0, 1'b0, "SUB: 3 - 10 = -7 (1001)"); 
        
        // ---------------------------------------------------
        // 3. LOGICAL AND TESTS (OpCode 010)
        // ---------------------------------------------------
        OpCode = OP_AND;
        A = 4'b1101; B = 4'b0111; // 13 & 7 = 0101 (5)
        run_test(4'b0101, 1'b0, 1'b0, "AND: 13 & 7 = 5"); 
        
        A = 4'b0000; B = 4'b1111; // 0 & 15 = 0 (Zero Flag test)
        run_test(4'b0000, 1'b0, 1'b1, "AND: 0 & 15 = 0 (Zero)"); 
        
        // ---------------------------------------------------
        // 4. LOGICAL OR TESTS (OpCode 011)
        // ---------------------------------------------------
        OpCode = OP_OR;
        A = 4'b1101; B = 4'b0110; // 13 | 6 = 1111 (15)
        run_test(4'b1111, 1'b0, 1'b0, "OR: 13 | 6 = 15"); 
        
        A = 4'b0000; B = 4'b0000; // 0 | 0 = 0 (Zero Flag test)
        run_test(4'b0000, 1'b0, 1'b1, "OR: 0 | 0 = 0 (Zero)"); 

        // ---------------------------------------------------
        // 5. LOGICAL XOR TESTS (OpCode 100)
        // ---------------------------------------------------
        OpCode = OP_XOR;
        A = 4'b1101; B = 4'b0110; // 13 ^ 6 = 1011 (11)
        run_test(4'b1011, 1'b0, 1'b0, "XOR: 13 ^ 6 = 11"); 
        
        A = 4'b1010; B = 4'b1010; // 10 ^ 10 = 0 (Zero Flag test)
        run_test(4'b0000, 1'b0, 1'b1, "XOR: 10 ^ 10 = 0 (Zero)"); 
        
        // ---------------------------------------------------
        // 6. SLT (Set Less Than) TESTS (OpCode 101)
        // Note: SLT uses signed comparison in this model.
        // ---------------------------------------------------
        OpCode = OP_SLT;
        // Case 1: A < B (Signed: 5 < 10) -> Result=1, SLT_Flag=1
        A = 4'd5; B = 4'd10; 
        run_test(4'd1, 1'b1, 1'b0, "SLT 1: 5 < 10 (True)"); 
        
        // Case 2: A > B (Signed: 10 > 5) -> Result=0, SLT_Flag=0
        A = 4'd10; B = 4'd5;
        run_test(4'd0, 1'b0, 1'b1, "SLT 2: 10 < 5 (False, Zero=1)"); 
        
        // Case 3: A = B (Signed: 5 = 5) -> Result=0, SLT_Flag=0
        A = 4'd5; B = 4'd5;
        run_test(4'd0, 1'b0, 1'b1, "SLT 3: 5 < 5 (False, Zero=1)"); 
        
        // Case 4: Signed comparison (A is negative, B is positive)
        // A = 4'b1001 (-7), B = 4'b0010 (2). -7 < 2 is True.
        A = 4'b1001; B = 4'b0010;
        run_test(4'd1, 1'b1, 1'b0, "SLT 4: -7 < 2 (True)"); 

        // Case 5: Signed comparison (Both negative)
        // A = 4'b1110 (-2), B = 4'b1010 (-6). -2 < -6 is False.
        A = 4'b1110; B = 4'b1010;
        run_test(4'd0, 1'b0, 1'b1, "SLT 5: -2 < -6 (False)"); 
        
        // Case 6: SLT resulting in 0
        A = 4'd1; B = 4'd1;
        run_test(4'd0, 1'b0, 1'b1, "SLT 6: 1 < 1 (False, Zero=1)"); 
        
        // ---------------------------------------------------
        // 7. ADDITIONAL MIXED TESTS
        // ---------------------------------------------------
        OpCode = OP_ADD;
        A = 4'd7; B = 4'd8; // 7 + 8 = 15
        run_test(4'd15, 1'b0, 1'b0, "ADD: 7 + 8 = 15"); 

        OpCode = OP_SUB;
        A = 4'd0; B = 4'd1; // 0 - 1 = -1 (1111)
        run_test(4'b1111, 1'b0, 1'b0, "SUB: 0 - 1 = -1"); 
        
        OpCode = OP_AND;
        A = 4'd15; B = 4'd15; // 15 & 15 = 15
        run_test(4'd15, 1'b0, 1'b0, "AND: 15 & 15 = 15"); 

        $display("-------------------------------------------");
        $display("   Simulation Complete: %0d Tests Executed", test_count);
        if (error_count == 0) begin
            $display("   *** ALL TESTS PASSED! ***");
        end else begin
            $display("   *** %0d FAILED TEST(S) FOUND! *** ", error_count);
        end
        $display("-------------------------------------------");
        
        $finish; // Stop the simulation
    end

endmodule
