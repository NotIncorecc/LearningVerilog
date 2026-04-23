`timescale 1ns / 1ps

module jk_flip_flop_tb;

    // Declarations
    reg  clk;
    reg  rst;
    reg  j, k;
    wire q;
    wire q_bar;

    // Instantiate DUT
    jk_flip_flop uut (
        .clk(clk),
        .rst(rst),
        .j(j),
        .k(k),
        .q(q),
        .q_bar(q_bar)
    );

    // Clock generation: 10ns period
    always #5 clk = ~clk;

    initial begin
        $dumpfile("jk_flip_flop_waves.vcd");
        $dumpvars(0, jk_flip_flop_tb);

        // Initialize & reset
        clk = 0; rst = 1; j = 0; k = 0;
        #10;
        $display("t=%0t | rst=%b J=%b K=%b | q=%b q_bar=%b (reset)", $time, rst, j, k, q, q_bar);

        rst = 0;

        // J=0, K=0 → Hold
        j = 0; k = 0; #10;
        $display("t=%0t | J=%b K=%b | q=%b q_bar=%b (hold)", $time, j, k, q, q_bar);

        // J=1, K=0 → Set
        j = 1; k = 0; #10;
        $display("t=%0t | J=%b K=%b | q=%b q_bar=%b (set)", $time, j, k, q, q_bar);

        // J=0, K=0 → Hold
        j = 0; k = 0; #10;
        $display("t=%0t | J=%b K=%b | q=%b q_bar=%b (hold)", $time, j, k, q, q_bar);

        // J=0, K=1 → Reset
        j = 0; k = 1; #10;
        $display("t=%0t | J=%b K=%b | q=%b q_bar=%b (reset)", $time, j, k, q, q_bar);

        // J=1, K=0 → Set again
        j = 1; k = 0; #10;
        $display("t=%0t | J=%b K=%b | q=%b q_bar=%b (set)", $time, j, k, q, q_bar);

        // J=1, K=1 → Toggle
        j = 1; k = 1; #10;
        $display("t=%0t | J=%b K=%b | q=%b q_bar=%b (toggle)", $time, j, k, q, q_bar);

        // J=1, K=1 → Toggle again
        j = 1; k = 1; #10;
        $display("t=%0t | J=%b K=%b | q=%b q_bar=%b (toggle)", $time, j, k, q, q_bar);

        #20;
        $finish;
    end

endmodule
