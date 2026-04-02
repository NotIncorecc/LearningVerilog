`timescale 1ns / 1ps

module sipo_register_tb;

    // Declarations
    reg  clk;
    reg  rst;
    reg  serial_in;
    wire [3:0] parallel_out;

    // Instantiate DUT
    sipo_4bit uut (
        .clk(clk),
        .rst(rst),
        .serial_in(serial_in),
        .parallel_out(parallel_out)
    );

    // Clock generation: 10ns period
    always #5 clk = ~clk;

    initial begin
        $dumpfile("sipo_register_waves.vcd");
        $dumpvars(0, sipo_register_tb);

        // Initialize
        clk = 0; rst = 1; serial_in = 0;
        #12;
        $display("t=%0t | rst=%b serial_in=%b | parallel_out=%b", $time, rst, serial_in, parallel_out);

        // Release reset
        rst = 0;

        // Shift in pattern: 1, 0, 1, 1 → expect parallel_out = 1011
        serial_in = 1; #10;
        $display("t=%0t | serial_in=%b | parallel_out=%b", $time, serial_in, parallel_out);

        serial_in = 0; #10;
        $display("t=%0t | serial_in=%b | parallel_out=%b", $time, serial_in, parallel_out);

        serial_in = 1; #10;
        $display("t=%0t | serial_in=%b | parallel_out=%b", $time, serial_in, parallel_out);

        serial_in = 1; #10;
        $display("t=%0t | serial_in=%b | parallel_out=%b", $time, serial_in, parallel_out);

        // Continue shifting: 0, 1 → observe shift behavior
        serial_in = 0; #10;
        $display("t=%0t | serial_in=%b | parallel_out=%b", $time, serial_in, parallel_out);

        serial_in = 1; #10;
        $display("t=%0t | serial_in=%b | parallel_out=%b", $time, serial_in, parallel_out);

        // Test reset mid-operation
        rst = 1; #10;
        $display("t=%0t | rst=%b | parallel_out=%b (reset asserted)", $time, rst, parallel_out);

        rst = 0; serial_in = 1; #10;
        $display("t=%0t | rst=%b serial_in=%b | parallel_out=%b (reset released)", $time, rst, serial_in, parallel_out);

        #20;
        $finish;
    end

endmodule
