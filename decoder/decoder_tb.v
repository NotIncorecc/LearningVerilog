`timescale 1ns / 1ps

module decoder_tb;

    // Declarations
    reg  [2:0] a;
    reg  en;
    wire [7:0] y;

    // Instantiate DUT
    decoder_3to8 uut (
        .a(a),
        .en(en),
        .y(y)
    );

    integer i;

    initial begin
        $dumpfile("decoder_waves.vcd");
        $dumpvars(0, decoder_tb);

        // Test: Enable LOW — output should be 0
        en = 0;
        for (i = 0; i < 8; i = i + 1) begin
            a = i[2:0];
            #10;
            $display("en=%b a=%d | y=%b", en, a, y);
        end

        // Test: Enable HIGH — normal decoding
        en = 1;
        for (i = 0; i < 8; i = i + 1) begin
            a = i[2:0];
            #10;
            $display("en=%b a=%d | y=%b", en, a, y);
        end

        $finish;
    end

endmodule
