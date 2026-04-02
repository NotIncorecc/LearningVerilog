`timescale 1ns / 1ps

module encoder_tb;

    // Declarations
    reg  [7:0] d;
    wire [2:0] y;

    // Instantiate DUT
    encoder_8to3 uut (
        .d(d),
        .y(y)
    );

    integer i;

    initial begin
        $dumpfile("encoder_waves.vcd");
        $dumpvars(0, encoder_tb);

        // Test all 8 one-hot inputs
        for (i = 0; i < 8; i = i + 1) begin
            d = (1 << i);
            #10;
            $display("d=%b | y=%d", d, y);
        end

        // Test: no input active
        d = 8'b0000_0000; #10;
        $display("d=%b | y=%b (undefined)", d, y);

        $finish;
    end

endmodule
