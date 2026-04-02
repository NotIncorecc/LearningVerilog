`timescale 1ns / 1ps

module sevensegment_tb;

    // Declarations
    reg  [3:0] bcd;
    wire [6:0] seg;

    // Instantiate DUT
    bcd_to_7seg uut (
        .bcd(bcd),
        .seg(seg)
    );

    integer i;

    initial begin
        $dumpfile("sevensegment_waves.vcd");
        $dumpvars(0, sevensegment_tb);

        bcd = 4'd0;

        // Sweep through all 16 possible inputs
        for (i = 0; i < 16; i = i + 1) begin
            bcd = i;
            #10;
            $display("BCD=%0d (4'b%b) | seg=%b", bcd, bcd, seg);
        end

        #10;
        $finish;
    end

endmodule
