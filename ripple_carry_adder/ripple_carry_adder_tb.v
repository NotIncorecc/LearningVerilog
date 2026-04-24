`timescale 1ns/1ps

module ripple_carry_adder_tb;

    // ---- 4-bit instance ----
    parameter N4 = 4;
    reg  [N4-1:0] A4, B4;
    reg            Cin4;
    wire [N4-1:0] Sum4;
    wire           Cout4;

    ripple_carry_adder #(.N(N4)) uut4 (
        .A   (A4),
        .B   (B4),
        .Cin (Cin4),
        .Sum (Sum4),
        .Cout(Cout4)
    );

    // ---- 8-bit instance ----
    parameter N8 = 8;
    reg  [N8-1:0] A8, B8;
    reg            Cin8;
    wire [N8-1:0] Sum8;
    wire           Cout8;

    ripple_carry_adder #(.N(N8)) uut8 (
        .A   (A8),
        .B   (B8),
        .Cin (Cin8),
        .Sum (Sum8),
        .Cout(Cout8)
    );

    initial begin
        $dumpfile("ripple_carry_adder_waves.vcd");
        $dumpvars(0, ripple_carry_adder_tb);

        // ---- 4-bit tests ----
        $display("=== 4-bit Ripple Carry Adder ===");
        $display("A    B    Cin | Sum  Cout");

        // Simple addition
        A4 = 4'd2;  B4 = 4'd3;  Cin4 = 1'b0; #10;
        $display("%4d %4d  %b   | %4d  %b", A4, B4, Cin4, Sum4, Cout4);

        // Addition with carry-in
        A4 = 4'd5;  B4 = 4'd5;  Cin4 = 1'b1; #10;
        $display("%4d %4d  %b   | %4d  %b", A4, B4, Cin4, Sum4, Cout4);

        // Overflow (Cout asserted)
        A4 = 4'd15; B4 = 4'd1;  Cin4 = 1'b0; #10;
        $display("%4d %4d  %b   | %4d  %b", A4, B4, Cin4, Sum4, Cout4);

        // Max values with carry-in
        A4 = 4'hf;  B4 = 4'hf;  Cin4 = 1'b1; #10;
        $display("%4d %4d  %b   | %4d  %b", A4, B4, Cin4, Sum4, Cout4);

        // Zero addition
        A4 = 4'd0;  B4 = 4'd0;  Cin4 = 1'b0; #10;
        $display("%4d %4d  %b   | %4d  %b", A4, B4, Cin4, Sum4, Cout4);

        // ---- 8-bit tests ----
        $display("\n=== 8-bit Ripple Carry Adder ===");
        $display("A      B    Cin | Sum   Cout");

        // Simple addition
        A8 = 8'd100; B8 = 8'd55;  Cin8 = 1'b0; #10;
        $display("%6d %6d  %b   | %6d  %b", A8, B8, Cin8, Sum8, Cout8);

        // Addition with carry-in
        A8 = 8'd127; B8 = 8'd127; Cin8 = 1'b1; #10;
        $display("%6d %6d  %b   | %6d  %b", A8, B8, Cin8, Sum8, Cout8);

        // Overflow (Cout asserted)
        A8 = 8'd255; B8 = 8'd1;   Cin8 = 1'b0; #10;
        $display("%6d %6d  %b   | %6d  %b", A8, B8, Cin8, Sum8, Cout8);

        // Max values with carry-in
        A8 = 8'hff; B8 = 8'hff;   Cin8 = 1'b1; #10;
        $display("%6d %6d  %b   | %6d  %b", A8, B8, Cin8, Sum8, Cout8);

        $finish;
    end
endmodule
