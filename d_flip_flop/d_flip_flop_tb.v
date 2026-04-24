`timescale 1ns / 1ps

module d_flip_flop_tb;

    // Declarations
    reg  clk;
    reg  rst;
    reg  d;
    wire q;
    wire q_bar;
    integer pass_count;
    integer fail_count;

    // Instantiate DUT
    d_flip_flop uut (
        .clk(clk),
        .rst(rst),
        .d(d),
        .q(q),
        .q_bar(q_bar)
    );

    // Clock generation: 10ns period
    always #5 clk = ~clk;

    task check_outputs;
        input exp_q;
        input exp_q_bar;
        input [255:0] test_name;
        begin
            if ((q !== exp_q) || (q_bar !== exp_q_bar)) begin
                fail_count = fail_count + 1;
                $display("FAIL | t=%0t | %0s | exp(q,q_bar)=(%b,%b) got=(%b,%b)",
                         $time, test_name, exp_q, exp_q_bar, q, q_bar);
            end else begin
                pass_count = pass_count + 1;
                $display("PASS | t=%0t | %0s | q=%b q_bar=%b",
                         $time, test_name, q, q_bar);
            end
        end
    endtask

    initial begin
        $dumpfile("d_flip_flop_waves.vcd");
        $dumpvars(0, d_flip_flop_tb);

        // Initialize
        clk = 1'b0;
        rst = 1'b1;
        d = 1'b0;
        pass_count = 0;
        fail_count = 0;

        // Hold synchronous reset for two rising edges
        repeat (2) @(posedge clk);
        #1;
        check_outputs(1'b0, 1'b1, "reset hold");

        // Release reset and apply edge-aligned test vectors
        rst = 1'b0;

        d = 1'b0;
        @(posedge clk);
        #1;
        check_outputs(1'b0, 1'b1, "d=0 capture");

        d = 1'b1;
        @(posedge clk);
        #1;
        check_outputs(1'b1, 1'b0, "d=1 capture");

        d = 1'b0;
        @(posedge clk);
        #1;
        check_outputs(1'b0, 1'b1, "d toggles to 0");

        d = 1'b1;
        @(posedge clk);
        #1;
        check_outputs(1'b1, 1'b0, "d toggles to 1");

        // Assert reset during operation (takes effect on clock edge)
        rst = 1'b1;
        d = 1'b1;
        @(posedge clk);
        #1;
        check_outputs(1'b0, 1'b1, "reset asserted in run");

        // Release reset and capture again
        rst = 1'b0;
        d = 1'b1;
        @(posedge clk);
        #1;
        check_outputs(1'b1, 1'b0, "post-reset capture");

        $display("SUMMARY | PASS=%0d FAIL=%0d", pass_count, fail_count);
        $finish;
    end

endmodule
