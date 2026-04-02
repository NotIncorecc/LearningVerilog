`timescale 1ns / 1ps

module flip_flop_tb;

    // Declarations
    reg  clk;
    reg  rst;
    reg  d;
    wire q;
    wire q_bar;

    // Instantiate DUT
    d_flip_flop uut (
        .clk(clk),
        .rst(rst),
        .d(d),
        .q(q),
        .q_bar(q_bar)
    );

    // Clock generation: 10ns period (5ns high, 5ns low)
    always #5 clk = ~clk;

    initial begin
        $dumpfile("flip_flop_waves.vcd");
        $dumpvars(0, flip_flop_tb);

        // Initialize
        clk = 0; rst = 1; d = 0;
        #12; // Hold reset for a bit
        $display("t=%0t | rst=%b d=%b | q=%b q_bar=%b", $time, rst, d, q, q_bar);

        // Release reset
        rst = 0;

        // Test: d=0 → q should stay 0
        d = 0; #10;
        $display("t=%0t | rst=%b d=%b | q=%b q_bar=%b", $time, rst, d, q, q_bar);

        // Test: d=1 → q should become 1 on next rising edge
        d = 1; #10;
        $display("t=%0t | rst=%b d=%b | q=%b q_bar=%b", $time, rst, d, q, q_bar);

        // Test: d=0 → q should become 0 on next rising edge
        d = 0; #10;
        $display("t=%0t | rst=%b d=%b | q=%b q_bar=%b", $time, rst, d, q, q_bar);

        // Test: d=1 again
        d = 1; #10;
        $display("t=%0t | rst=%b d=%b | q=%b q_bar=%b", $time, rst, d, q, q_bar);

        // Test: Assert reset while running
        rst = 1; #10;
        $display("t=%0t | rst=%b d=%b | q=%b q_bar=%b (reset asserted)", $time, rst, d, q, q_bar);

        rst = 0; d = 1; #10;
        $display("t=%0t | rst=%b d=%b | q=%b q_bar=%b (reset released)", $time, rst, d, q, q_bar);

        #20;
        $finish;
    end

endmodule
