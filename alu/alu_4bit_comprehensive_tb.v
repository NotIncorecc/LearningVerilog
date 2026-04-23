`timescale 1ns / 1ps

module alu_4bit_comprehensive_tb;

    // Test signals
    reg [3:0] a, b;
    reg [3:0] select;
    reg cin;
    wire [3:0] result;
    wire carry;
    
    // Test counters
    integer total_tests = 0;
    integer passed_tests = 0;
    integer failed_tests = 0;

    // Instantiate the ALU
    alu_4bit uut (
        .a(a),
        .b(b),
        .select(select),
        .cin(cin),
        .result(result),
        .carry(carry)
    );

    initial begin
        $dumpfile("alu_waves.vcd");
        $dumpvars(0, alu_4bit_comprehensive_tb);

        $display("\n\n");
        $display("╔════════════════════════════════════════════════════════╗");
        $display("║      ALU 4-bit Comprehensive Testbench                ║");
        $display("║    Testing All Operations and Edge Cases              ║");
        $display("╚════════════════════════════════════════════════════════╝\n");

        // ==================== ARITHMETIC OPERATIONS ====================
        $display("\n┌─ ARITHMETIC OPERATIONS ────────────────────────────────┐");
        
        // Group 1: Transfer and Increment
        $display("\n▶ Transfer and Increment Operations:");
        test_alu(4'b0101, 4'bxxxx, 4'b0000, 1'b0, 4'b0101, 1'b0, "Transfer A");
        test_alu(4'b0101, 4'bxxxx, 4'b0001, 1'b1, 4'b0110, 1'b0, "A + 1");
        test_alu(4'b1111, 4'bxxxx, 4'b0001, 1'b1, 4'b0000, 1'b1, "A + 1 (overflow)");
        test_alu(4'b0000, 4'bxxxx, 4'b0001, 1'b1, 4'b0001, 1'b0, "0 + 1");

        // Group 2: Addition
        $display("\n▶ Addition Operations (A + B):");
        test_alu(4'b0011, 4'b0010, 4'b0010, 1'b0, 4'b0101, 1'b0, "3 + 2 = 5");
        test_alu(4'b1000, 4'b0100, 4'b0010, 1'b0, 4'b1100, 1'b0, "8 + 4 = 12");
        test_alu(4'b1111, 4'b0001, 4'b0010, 1'b0, 4'b0000, 1'b1, "15 + 1 (overflow)");
        test_alu(4'b0111, 4'b1001, 4'b0010, 1'b0, 4'b0000, 1'b1, "7 + 9 (overflow)");
        test_alu(4'b0000, 4'b0000, 4'b0010, 1'b0, 4'b0000, 1'b0, "0 + 0 = 0");
        test_alu(4'b1111, 4'b1111, 4'b0010, 1'b0, 4'b1110, 1'b1, "15 + 15");

        // Group 3: Addition with Carry In
        $display("\n▶ Addition Operations (A + B + 1):");
        test_alu(4'b0010, 4'b0011, 4'b0011, 1'b1, 4'b0110, 1'b0, "2 + 3 + 1 = 6");
        test_alu(4'b1111, 4'b1111, 4'b0011, 1'b1, 4'b1111, 1'b1, "15 + 15 + 1");
        test_alu(4'b1110, 4'b0001, 4'b0011, 1'b1, 4'b0000, 1'b1, "14 + 1 + 1 (overflow)");

        // Group 4: Subtraction (Two's Complement)
        $display("\n▶ Subtraction Operations (A - B using A + ~B):");
        test_alu(4'b0101, 4'b0011, 4'b0100, 1'b0, 4'b0010, 1'b0, "5 - 3 = 2");
        test_alu(4'b1000, 4'b0100, 4'b0100, 1'b0, 4'b0100, 1'b0, "8 - 4 = 4");
        test_alu(4'b0011, 4'b0101, 4'b0100, 1'b0, 4'b1110, 1'b0, "3 - 5 = -2");
        test_alu(4'b0000, 4'b0001, 4'b0100, 1'b0, 4'b1111, 1'b0, "0 - 1 = -1");

        // Group 5: Subtraction (Two's Complement + 1)
        $display("\n▶ Subtraction Operations (A - B using A + ~B + 1):");
        test_alu(4'b1000, 4'b0011, 4'b0101, 1'b1, 4'b0101, 1'b0, "8 - 3 = 5");
        test_alu(4'b1010, 4'b0101, 4'b0101, 1'b1, 4'b0101, 1'b0, "10 - 5 = 5");
        test_alu(4'b0101, 4'b1000, 4'b0101, 1'b1, 4'b1101, 1'b0, "5 - 8 = -3");

        // Group 6: Decrement
        $display("\n▶ Decrement Operation (A - 1):");
        test_alu(4'b0101, 4'bxxxx, 4'b0110, 1'b0, 4'b0100, 1'b0, "5 - 1 = 4");
        test_alu(4'b0001, 4'bxxxx, 4'b0110, 1'b0, 4'b0000, 1'b0, "1 - 1 = 0");
        test_alu(4'b0000, 4'bxxxx, 4'b0110, 1'b0, 4'b1111, 1'b1, "0 - 1 (underflow)");
        test_alu(4'b1000, 4'bxxxx, 4'b0110, 1'b0, 4'b0111, 1'b0, "8 - 1 = 7");

        // ==================== LOGICAL OPERATIONS ====================
        $display("\n\n┌─ LOGICAL OPERATIONS ───────────────────────────────────┐");

        // Group 7: AND
        $display("\n▶ AND Operations:");
        test_alu(4'b1010, 4'b0101, 4'b1001, 1'b0, 4'b0000, 1'b0, "1010 AND 0101 = 0000");
        test_alu(4'b1111, 4'b0101, 4'b1001, 1'b0, 4'b0101, 1'b0, "1111 AND 0101 = 0101");
        test_alu(4'b1111, 4'b1111, 4'b1001, 1'b0, 4'b1111, 1'b0, "1111 AND 1111 = 1111");
        test_alu(4'b0000, 4'b1111, 4'b1001, 1'b0, 4'b0000, 1'b0, "0000 AND 1111 = 0000");

        // Group 8: OR
        $display("\n▶ OR Operations:");
        test_alu(4'b1010, 4'b0101, 4'b1010, 1'b0, 4'b1111, 1'b0, "1010 OR 0101 = 1111");
        test_alu(4'b0000, 4'b0100, 4'b1010, 1'b0, 4'b0100, 1'b0, "0000 OR 0100 = 0100");
        test_alu(4'b1000, 4'b0100, 4'b1010, 1'b0, 4'b1100, 1'b0, "1000 OR 0100 = 1100");
        test_alu(4'b0000, 4'b0000, 4'b1010, 1'b0, 4'b0000, 1'b0, "0000 OR 0000 = 0000");

        // Group 9: XOR
        $display("\n▶ XOR Operations:");
        test_alu(4'b1010, 4'b0101, 4'b1011, 1'b0, 4'b1111, 1'b0, "1010 XOR 0101 = 1111");
        test_alu(4'b1111, 4'b1111, 4'b1011, 1'b0, 4'b0000, 1'b0, "1111 XOR 1111 = 0000");
        test_alu(4'b1010, 4'b1010, 4'b1011, 1'b0, 4'b0000, 1'b0, "1010 XOR 1010 = 0000");
        test_alu(4'b0101, 4'b1010, 4'b1011, 1'b0, 4'b1111, 1'b0, "0101 XOR 1010 = 1111");

        // Group 10: NOT
        $display("\n▶ NOT Operations:");
        test_alu(4'b1010, 4'bxxxx, 4'b1101, 1'b0, 4'b0101, 1'b0, "NOT 1010 = 0101");
        test_alu(4'b0000, 4'bxxxx, 4'b1101, 1'b0, 4'b1111, 1'b0, "NOT 0000 = 1111");
        test_alu(4'b1111, 4'bxxxx, 4'b1101, 1'b0, 4'b0000, 1'b0, "NOT 1111 = 0000");
        test_alu(4'b0001, 4'bxxxx, 4'b1101, 1'b0, 4'b1110, 1'b0, "NOT 0001 = 1110");

        // ==================== SHIFT OPERATIONS ====================
        $display("\n\n┌─ SHIFT OPERATIONS ─────────────────────────────────────┐");

        // Group 11: Shift Right
        $display("\n▶ Shift Right Operations (shift_in_r = a[3]):");
        test_alu(4'b1101, 4'bxxxx, 4'b1000, 1'b0, 4'b1110, 1'b0, "SR: 1101 → 1110");
        test_alu(4'b0101, 4'bxxxx, 4'b1000, 1'b0, 4'b0010, 1'b0, "SR: 0101 → 0010");
        test_alu(4'b1111, 4'bxxxx, 4'b1000, 1'b0, 4'b1111, 1'b0, "SR: 1111 → 1111");
        test_alu(4'b0001, 4'bxxxx, 4'b1000, 1'b0, 4'b0000, 1'b0, "SR: 0001 → 0000");

        // Group 12: Shift Left
        $display("\n▶ Shift Left Operations (shift_in_l = a[0]):");
        test_alu(4'b1101, 4'bxxxx, 4'b1100, 1'b0, 4'b1011, 1'b0, "SL: 1101 → 1011");
        test_alu(4'b0101, 4'bxxxx, 4'b1100, 1'b0, 4'b1010, 1'b0, "SL: 0101 → 1010");
        test_alu(4'b1000, 4'bxxxx, 4'b1100, 1'b0, 4'b0001, 1'b0, "SL: 1000 → 0001");
        test_alu(4'b1111, 4'bxxxx, 4'b1100, 1'b0, 4'b1111, 1'b0, "SL: 1111 → 1111");

        // ==================== EDGE CASES & STRESS TESTS ====================
        $display("\n\n┌─ EDGE CASES & STRESS TESTS ─────────────────────────────┐");

        // Group 13: All zeros and all ones
        $display("\n▶ Boundary Conditions:");
        test_alu(4'b0000, 4'b0000, 4'b0010, 1'b0, 4'b0000, 1'b0, "0 + 0");
        test_alu(4'b1111, 4'b1111, 4'b0010, 1'b0, 4'b1110, 1'b1, "15 + 15");
        test_alu(4'b1111, 4'bxxxx, 4'b0001, 1'b1, 4'b0000, 1'b1, "Max + 1");
        test_alu(4'b0000, 4'bxxxx, 4'b0110, 1'b0, 4'b1111, 1'b1, "Min - 1");

        // Group 14: Single bit operations
        $display("\n▶ Single Bit Operations:");
        test_alu(4'b0001, 4'b0000, 4'b0010, 1'b0, 4'b0001, 1'b0, "1 + 0");
        test_alu(4'b1000, 4'b0000, 4'b0010, 1'b0, 4'b1000, 1'b0, "8 + 0");
        test_alu(4'b0001, 4'b0001, 4'b0010, 1'b0, 4'b0010, 1'b0, "1 + 1");
        test_alu(4'b1000, 4'b1000, 4'b0010, 1'b0, 4'b0000, 1'b1, "8 + 8");

        // Group 15: Carry propagation
        $display("\n▶ Carry Propagation Tests:");
        test_alu(4'b0111, 4'b0001, 4'b0010, 1'b0, 4'b1000, 1'b0, "7 + 1 (no carry)");
        test_alu(4'b1000, 4'b1000, 4'b0010, 1'b0, 4'b0000, 1'b1, "8 + 8 (with carry)");
        test_alu(4'b0111, 4'b1001, 4'b0010, 1'b0, 4'b0000, 1'b1, "7 + 9 (with carry)");

        // Print summary
        print_summary();
        
        $finish;
    end

    // Task: Test ALU operation with verification
    task test_alu(
        input [3:0] in_a, 
        input [3:0] in_b, 
        input [3:0] in_sel, 
        input in_cin,
        input [3:0] exp_result, 
        input exp_carry,
        input string description
    );
    begin
        a = in_a;
        b = in_b;
        select = in_sel;
        cin = in_cin;
        #10;
        
        total_tests = total_tests + 1;
        
        if (result === exp_result && carry === exp_carry) begin
            passed_tests = passed_tests + 1;
            $display("  ✓ PASS | %s", description);
        end else begin
            failed_tests = failed_tests + 1;
            $display("  ✗ FAIL | %s", description);
            $display("          Expected: result=%b (%0d), carry=%b", exp_result, exp_result, exp_carry);
            $display("          Got:      result=%b (%0d), carry=%b", result, result, carry);
        end
    end
    endtask

    // Print test summary
    task print_summary;
    begin
        $display("\n\n┌────────────────────────────────────────────────────────┐");
        $display("║                   TEST SUMMARY                        ║");
        $display("├────────────────────────────────────────────────────────┤");
        $display("║  Total Tests:  %3d                                     ║", total_tests);
        $display("║  Passed:       %3d  ✓                                 ║", passed_tests);
        $display("║  Failed:       %3d  ✗                                 ║", failed_tests);
        if (failed_tests == 0)
            $display("║                                                        ║");
            $display("║              🎉 ALL TESTS PASSED! 🎉                  ║");
        $display("└────────────────────────────────────────────────────────┘\n");
    end
    endtask

endmodule
