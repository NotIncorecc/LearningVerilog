`timescale 1ns / 1ps

module alu_4bit_tb;

    reg  [3:0] a, b;
    reg  [2:0] op;
    wire [3:0] result;
    wire       zero, carry;

    // Instantiate DUT
    alu_4bit uut (
        .a(a),
        .b(b),
        .op(op),
        .result(result),
        .zero(zero),
        .carry(carry)
    );

    initial begin
        $dumpfile("alu_waves.vcd");
        $dumpvars(0, alu_4bit_tb);

        a = 4'b0101; b = 4'b0011;

        // ADD: 5+3=8
        op = 3'b000; #10;
        $display("t=%0t | op=ADD  a=%b b=%b | result=%b carry=%b zero=%b", $time, a, b, result, carry, zero);

        // SUB: 5-3=2
        op = 3'b001; #10;
        $display("t=%0t | op=SUB  a=%b b=%b | result=%b carry=%b zero=%b", $time, a, b, result, carry, zero);

        // AND: 5&3=1
        op = 3'b010; #10;
        $display("t=%0t | op=AND  a=%b b=%b | result=%b zero=%b", $time, a, b, result, zero);

        // OR: 5|3=7
        op = 3'b011; #10;
        $display("t=%0t | op=OR   a=%b b=%b | result=%b zero=%b", $time, a, b, result, zero);

        // XOR: 5^3=6
        op = 3'b100; #10;
        $display("t=%0t | op=XOR  a=%b b=%b | result=%b zero=%b", $time, a, b, result, zero);

        // NOT: ~5=10
        op = 3'b101; #10;
        $display("t=%0t | op=NOT  a=%b     | result=%b zero=%b", $time, a, result, zero);

        // NAND
        op = 3'b110; #10;
        $display("t=%0t | op=NAND a=%b b=%b | result=%b zero=%b", $time, a, b, result, zero);

        // NOR
        op = 3'b111; #10;
        $display("t=%0t | op=NOR  a=%b b=%b | result=%b zero=%b", $time, a, b, result, zero);

        // Test zero flag: ADD 0+0=0
        a = 4'b0000; b = 4'b0000; op = 3'b000; #10;
        $display("t=%0t | op=ADD  a=%b b=%b | result=%b zero=%b (zero flag)", $time, a, b, result, zero);

        // Test carry: ADD 15+1 = overflow
        a = 4'b1111; b = 4'b0001; op = 3'b000; #10;
        $display("t=%0t | op=ADD  a=%b b=%b | result=%b carry=%b (carry flag)", $time, a, b, result, carry);

        #10;
        $finish;
    end

endmodule
