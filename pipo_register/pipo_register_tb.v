`timescale 1ns / 1ps

module pipo_register_tb;

    reg        clk;
    reg        rst;
    reg        load;
    reg  [3:0] d;
    wire [3:0] q;

    // Instantiate DUT
    pipo_register uut (
        .clk(clk),
        .rst(rst),
        .load(load),
        .d(d),
        .q(q)
    );

    // Clock generation: 10ns period
    always #5 clk = ~clk;

    initial begin
        $dumpfile("pipo_register_waves.vcd");
        $dumpvars(0, pipo_register_tb);

        // Initialize & reset
        clk = 0; rst = 1; load = 0; d = 4'b0000;
        #10;
        $display("t=%0t | rst=%b load=%b d=%b | q=%b (reset)", $time, rst, load, d, q);

        rst = 0;

        // Load data = 1010
        d = 4'b1010; load = 1; #10;
        $display("t=%0t | rst=%b load=%b d=%b | q=%b (load 1010)", $time, rst, load, d, q);

        // Hold (load=0, d changes but q unchanged)
        d = 4'b0101; load = 0; #10;
        $display("t=%0t | rst=%b load=%b d=%b | q=%b (hold)", $time, rst, load, d, q);

        // Load data = 1111
        d = 4'b1111; load = 1; #10;
        $display("t=%0t | rst=%b load=%b d=%b | q=%b (load 1111)", $time, rst, load, d, q);

        // Load data = 0110
        d = 4'b0110; load = 1; #10;
        $display("t=%0t | rst=%b load=%b d=%b | q=%b (load 0110)", $time, rst, load, d, q);

        // Reset while data loaded
        rst = 1; load = 0; #10;
        $display("t=%0t | rst=%b load=%b d=%b | q=%b (reset asserted)", $time, rst, load, d, q);

        rst = 0; d = 4'b1100; load = 1; #10;
        $display("t=%0t | rst=%b load=%b d=%b | q=%b (load after reset)", $time, rst, load, d, q);

        #20;
        $finish;
    end

endmodule
