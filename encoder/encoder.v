module encoder_8to3 (
    input  [7:0] d,
    output [2:0] y
);
    // y[0] is high if d[1], d[3], d[5], or d[7] is high
    assign y[0] = d[1] | d[3] | d[5] | d[7];

    // y[1] is high if d[2], d[3], d[6], or d[7] is high
    assign y[1] = d[2] | d[3] | d[6] | d[7];

    // y[2] is high if d[4], d[5], d[6], or d[7] is high
    assign y[2] = d[4] | d[5] | d[6] | d[7];

endmodule