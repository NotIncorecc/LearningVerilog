`timescale 1ns / 1ps

module alu_4bit_tb;

    reg [3:0] a, b;
    reg [3:0] select;
    reg cin;
    wire [3:0] result;
    wire carry;

    // Instantiate the ALU
    alu_4bit dut (
        .a(a),
        .b(b),
        .select(select),
        .cin(cin),
        .result(result),
        .carry(carry)
    );

    initial begin
        $dumpfile("alu_waves.vcd");
        $dumpvars(0, alu_4bit_tb);

        // Test heading
        $display("\n================== ALU 4-bit Testbench ==================");
        $display("Testing all ALU operations: Arithmetic, Logical, Shifts\n");

        // ==================== ARITHMETIC OPERATIONS ====================
        $display("========== ARITHMETIC OPERATIONS (select[3:2] = 00) ==========");

        // Test 1: Transfer A (select = 0000, cin = 0)
        $display("\n--- Test 1: Transfer A (select = 4'b0000, cin = 0) ---");
        test_operation(4'b0001, 4'b0101, 4'b0000, 1'b0, "Transfer A (should be 0001)");

        // Test 2: A + 1 (select = 0001, cin = 1)
        $display("\n--- Test 2: A + 1 (select = 4'b0001, cin = 1) ---");
        test_operation(4'b0101, 4'b0000, 4'b0001, 1'b1, "A + 1 (should be 0110)");
        test_operation(4'b1111, 4'b0000, 4'b0001, 1'b1, "A + 1 with overflow (should be 0000, carry=1)");

        // Test 3: A + B (select = 0010, cin = 0)
        $display("\n--- Test 3: A + B (select = 4'b0010, cin = 0) ---");
        test_operation(4'b0011, 4'b0010, 4'b0010, 1'b0, "3 + 2 (should be 0101)");
        test_operation(4'b1000, 4'b0100, 4'b0010, 1'b0, "8 + 4 (should be 1100)");
        test_operation(4'b1111, 4'b0001, 4'b0010, 1'b0, "15 + 1 with overflow (should be 0000, carry=1)");

        // Test 4: A + B + 1 (select = 0011, cin = 1)
        $display("\n--- Test 4: A + B + 1 (select = 4'b0011, cin = 1) ---");
        test_operation(4'b0010, 4'b0011, 4'b0011, 1'b1, "2 + 3 + 1 (should be 0110)");
        test_operation(4'b1111, 4'b1111, 4'b0011, 1'b1, "15 + 15 + 1 with overflow (should be 1111, carry=1)");

        // Test 5: A - B (A + ~B, select = 0100, cin = 0)
        $display("\n--- Test 5: A - B (A + ~B, select = 4'b0100, cin = 0) ---");
        test_operation(4'b0101, 4'b0011, 4'b0100, 1'b0, "5 - 3 (should be 0010)");
        test_operation(4'b0011, 4'b0101, 4'b0100, 1'b0, "3 - 5 (should be 1110)");

        // Test 6: A - B (A + ~B + 1, select = 0101, cin = 1)
        $display("\n--- Test 6: A - B (A + ~B + 1, select = 4'b0101, cin = 1) ---");
        test_operation(4'b1000, 4'b0011, 4'b0101, 1'b1, "8 - 3 (should be 0101)");
        test_operation(4'b0101, 4'b1000, 4'b0101, 1'b1, "5 - 8 (should be 1101)");

        // Test 7: A - 1 (select = 0110, cin = 0)
        $display("\n--- Test 7: A - 1 (select = 4'b0110, cin = 0) ---");
        test_operation(4'b0101, 4'b0000, 4'b0110, 1'b0, "5 - 1 (should be 0100)");
        test_operation(4'b0000, 4'b0000, 4'b0110, 1'b0, "0 - 1 (should be 1111, carry=1)");

        // Test 8: Transfer A (select = 0111, cin = 1)
        $display("\n--- Test 8: Transfer A (select = 4'b0111, cin = 1) ---");
        test_operation(4'b1010, 4'b0101, 4'b0111, 1'b1, "Transfer A (should be 1010)");

        // ==================== LOGICAL OPERATIONS ====================
        $display("\n\n========== LOGICAL OPERATIONS (select[3:2] = 01) ==========");

        // Test 9: AND (select = 1001)
        $display("\n--- Test 9: AND (select = 4'b1001) ---");
        test_operation(4'b1010, 4'b0101, 4'b1001, 1'b0, "1010 AND 0101 (should be 0000)");
        test_operation(4'b1111, 4'b0101, 4'b1001, 1'b0, "1111 AND 0101 (should be 0101)");

        // Test 10: OR (select = 1010)
        $display("\n--- Test 10: OR (select = 4'b1010) ---");
        test_operation(4'b1010, 4'b0101, 4'b1010, 1'b0, "1010 OR 0101 (should be 1111)");
        test_operation(4'b0000, 4'b0100, 4'b1010, 1'b0, "0000 OR 0100 (should be 0100)");

        // Test 11: XOR (select = 1011)
        $display("\n--- Test 11: XOR (select = 4'b1011) ---");
        test_operation(4'b1010, 4'b0101, 4'b1011, 1'b0, "1010 XOR 0101 (should be 1111)");
        test_operation(4'b1111, 4'b1111, 4'b1011, 1'b0, "1111 XOR 1111 (should be 0000)");

        // Test 12: NOT A (select = 1101)
        $display("\n--- Test 12: NOT A (select = 4'b1101) ---");
        test_operation(4'b1010, 4'b0000, 4'b1101, 1'b0, "NOT 1010 (should be 0101)");
        test_operation(4'b0000, 4'b0000, 4'b1101, 1'b0, "NOT 0000 (should be 1111)");
        test_operation(4'b1111, 4'b0000, 4'b1101, 1'b0, "NOT 1111 (should be 0000)");

        // ==================== SHIFT OPERATIONS ====================
        $display("\n\n========== SHIFT OPERATIONS ====================");

        // Test 13: Shift Right (select[3:2] = 10)
        $display("\n--- Test 13: Shift Right (select[3:2] = 10) ---");
        test_operation(4'b1101, 4'b0000, 4'b1000, 1'b0, "Shift Right: 1101 (should be 1110, right bit in)");
        test_operation(4'b0101, 4'b0000, 4'b1000, 1'b0, "Shift Right: 0101 (should be 0010, right bit in)");

        // Test 14: Shift Left (select[3:2] = 11)
        $display("\n--- Test 14: Shift Left (select[3:2] = 11) ---");
        test_operation(4'b1101, 4'b0000, 4'b1100, 1'b0, "Shift Left: 1101 (should be 1011, left bit in)");
        test_operation(4'b0101, 4'b0000, 4'b1100, 1'b0, "Shift Left: 0101 (should be 1010, left bit in)");

        // ==================== EDGE CASES ====================
        $display("\n\n========== EDGE CASES AND COMPREHENSIVE TESTS ===========");

        // Test 15: All zeros
        $display("\n--- Test 15: All zeros ---");
        test_operation(4'b0000, 4'b0000, 4'b0010, 1'b0, "0 + 0 (should be 0000)");

        // Test 16: All ones
        $display("\n--- Test 16: All ones ---");
        test_operation(4'b1111, 4'b1111, 4'b0010, 1'b0, "15 + 15 (should be 1110, carry=1)");

        // Test 17: Maximum value operations
        $display("\n--- Test 17: Maximum value operations ---");
        test_operation(4'b1111, 4'b0001, 4'b0010, 1'b0, "15 + 1 (should be 0000, carry=1)");

        // Test 18: Carry propagation with multiple operations
        $display("\n--- Test 18: Carry propagation ---");
        test_operation(4'b0111, 4'b0001, 4'b0010, 1'b0, "7 + 1 (should be 1000, no carry)");
        test_operation(4'b1111, 4'b0000, 4'b0001, 1'b1, "15 + 1 (should be 0000, carry=1)");

        $display("\n\n================== Testbench Complete ==================\n");
        $finish;
    end

    // Task to test an operation
    task test_operation(input [3:0] in_a, input [3:0] in_b, input [3:0] sel, input in_cin, input string description);
        begin
            a = in_a;
            b = in_b;
            select = sel;
            cin = in_cin;
            #10; // Wait for result to settle
            $display("Inputs: A=%b (%0d), B=%b (%0d), Select=%b, Cin=%b | Result=%b (%0d), Carry=%b | %s",
                     a, a, b, b, select, cin, result, result, carry, description);
        end
    endtask

endmodule