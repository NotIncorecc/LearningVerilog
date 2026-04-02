`timescale 1ns / 1ps

module priority_encoder_tb;

    // Declarations
    reg  [7:0] d;
    wire [2:0] y;
    wire valid;

    // Instantiate DUT
    priority_encoder_8to3 uut (
        .d(d),
        .y(y),
        .valid(valid)
    );

    initial begin
        $dumpfile("priority_encoder_waves.vcd");
        $dumpvars(0, priority_encoder_tb);

        // Test: No input active
        d = 8'b0000_0000; #10;
        $display("d=%b | y=%d valid=%b", d, y, valid);

        // Test: Single inputs
        d = 8'b0000_0001; #10;
        $display("d=%b | y=%d valid=%b", d, y, valid);

        d = 8'b0000_0100; #10;
        $display("d=%b | y=%d valid=%b", d, y, valid);

        d = 8'b1000_0000; #10;
        $display("d=%b | y=%d valid=%b", d, y, valid);

        // Test: Multiple inputs — highest priority wins
        d = 8'b0101_0010; #10;
        $display("d=%b | y=%d valid=%b", d, y, valid);

        d = 8'b1010_1010; #10;
        $display("d=%b | y=%d valid=%b", d, y, valid);

        d = 8'b0000_0110; #10;
        $display("d=%b | y=%d valid=%b", d, y, valid);

        d = 8'b1111_1111; #10;
        $display("d=%b | y=%d valid=%b", d, y, valid);

        $finish;
    end

endmodule
