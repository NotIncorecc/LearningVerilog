`timescale 1ns / 1ps

module alu_4bit_tb;

    reg [3:0] a, b;
    reg [3:0] select;
    reg cin;
    wire [3:0] result;
    wire carry;
    reg [4:0] expected;

    integer total_tests;
    integer passed_tests;
    integer failed_tests;
    integer i;

    reg [3:0] vec_a [0:5];
    reg [3:0] vec_b [0:5];

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
        total_tests = 0;
        passed_tests = 0;
        failed_tests = 0;

        vec_a[0] = 4'h0; vec_b[0] = 4'h0;
        vec_a[1] = 4'h1; vec_b[1] = 4'h7;
        vec_a[2] = 4'h5; vec_b[2] = 4'h3;
        vec_a[3] = 4'h8; vec_b[3] = 4'h4;
        vec_a[4] = 4'hF; vec_b[4] = 4'h1;
        vec_a[5] = 4'hA; vec_b[5] = 4'h5;

        $display("\n=== Checking ALU against provided function table ===");

        // Arithmetic rows: 0000..0111 with cin as table input
        for (i = 0; i < 6; i = i + 1) begin
            run_and_check(vec_a[i], vec_b[i], 4'b0000, 1'b0, "0000: F=A");
            run_and_check(vec_a[i], vec_b[i], 4'b0000, 1'b1, "0000: F=A+1");
            run_and_check(vec_a[i], vec_b[i], 4'b0001, 1'b0, "0001: F=A+B");
            run_and_check(vec_a[i], vec_b[i], 4'b0001, 1'b1, "0001: F=A+B+1");
            run_and_check(vec_a[i], vec_b[i], 4'b0010, 1'b0, "0010: F=A+~B");
            run_and_check(vec_a[i], vec_b[i], 4'b0010, 1'b1, "0010: F=A+~B+1");
            run_and_check(vec_a[i], vec_b[i], 4'b0011, 1'b0, "0011: F=A-1");
            run_and_check(vec_a[i], vec_b[i], 4'b0011, 1'b1, "0011: F=A");
        end

        // Logical rows: 01xx, cin is don't-care in table, test both values.
        for (i = 0; i < 6; i = i + 1) begin
            run_and_check(vec_a[i], vec_b[i], 4'b0100, 1'b0, "0100x: F=A&B");
            run_and_check(vec_a[i], vec_b[i], 4'b0100, 1'b1, "0100x: F=A&B");
            run_and_check(vec_a[i], vec_b[i], 4'b0101, 1'b0, "0101x: F=A|B");
            run_and_check(vec_a[i], vec_b[i], 4'b0101, 1'b1, "0101x: F=A|B");
            run_and_check(vec_a[i], vec_b[i], 4'b0110, 1'b0, "0110x: F=A^B");
            run_and_check(vec_a[i], vec_b[i], 4'b0110, 1'b1, "0110x: F=A^B");
            run_and_check(vec_a[i], vec_b[i], 4'b0111, 1'b0, "0111x: F=~A");
            run_and_check(vec_a[i], vec_b[i], 4'b0111, 1'b1, "0111x: F=~A");
        end

        // Shift rows: 10xx and 11xx, both lower bits and cin are don't-care.
        for (i = 0; i < 6; i = i + 1) begin
            run_and_check(vec_a[i], vec_b[i], 4'b1000, 1'b0, "10xxx: F=shr A");
            run_and_check(vec_a[i], vec_b[i], 4'b1001, 1'b1, "10xxx: F=shr A");
            run_and_check(vec_a[i], vec_b[i], 4'b1010, 1'b0, "10xxx: F=shr A");
            run_and_check(vec_a[i], vec_b[i], 4'b1011, 1'b1, "10xxx: F=shr A");

            run_and_check(vec_a[i], vec_b[i], 4'b1100, 1'b0, "11xxx: F=shl A");
            run_and_check(vec_a[i], vec_b[i], 4'b1101, 1'b1, "11xxx: F=shl A");
            run_and_check(vec_a[i], vec_b[i], 4'b1110, 1'b0, "11xxx: F=shl A");
            run_and_check(vec_a[i], vec_b[i], 4'b1111, 1'b1, "11xxx: F=shl A");
        end

        $display("\nTotal: %0d, Passed: %0d, Failed: %0d", total_tests, passed_tests, failed_tests);
        if (failed_tests == 0)
            $display("ALU matches the provided table.");
        else
            $display("ALU does NOT exactly match the provided table.");

        $finish;
    end

    task run_and_check(
        input [3:0] in_a,
        input [3:0] in_b,
        input [3:0] sel,
        input in_cin,
        input [8*24-1:0] label
    );
        begin
            a = in_a;
            b = in_b;
            select = sel;
            cin = in_cin;
            #1;

            expected = expected_from_table(in_a, in_b, sel, in_cin);
            total_tests = total_tests + 1;

            if ({carry, result} === expected) begin
                passed_tests = passed_tests + 1;
            end else begin
                failed_tests = failed_tests + 1;
                $display("FAIL %0d | %s | A=%b B=%b S=%b Cin=%b | exp={%b,%b} got={%b,%b}",
                         total_tests, label, in_a, in_b, sel, in_cin,
                         expected[4], expected[3:0], carry, result);
            end
        end
    endtask

    function [4:0] expected_from_table(
        input [3:0] in_a,
        input [3:0] in_b,
        input [3:0] sel,
        input in_cin
    );
        reg [4:0] temp;
        begin
            temp = 5'b0;
            case (sel[3:2])
                2'b00: begin
                    case (sel[1:0])
                        2'b00: temp = {1'b0, in_a} + in_cin;
                        2'b01: temp = {1'b0, in_a} + {1'b0, in_b} + in_cin;
                        2'b10: temp = {1'b0, in_a} + {1'b0, ~in_b} + in_cin;
                        2'b11: temp = {1'b0, in_a} + 5'b0_1111 + in_cin;
                    endcase
                end
                2'b01: begin
                    case (sel[1:0])
                        2'b00: temp = {1'b0, (in_a & in_b)};
                        2'b01: temp = {1'b0, (in_a | in_b)};
                        2'b10: temp = {1'b0, (in_a ^ in_b)};
                        2'b11: temp = {1'b0, (~in_a)};
                    endcase
                end
                2'b10: temp = {1'b0, (in_a >> 1)};
                2'b11: temp = {1'b0, (in_a << 1)};
            endcase

            expected_from_table = temp;
        end
    endfunction

endmodule