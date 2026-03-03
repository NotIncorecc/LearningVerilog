module mux4x1_dataflow (
    input [3:0] i,      // 4-bit input bus (i[0], i[1], i[2], i[3])
    input [1:0] s,      // 2-bit select line
    output y            // Scalar output
);

    // Index-select to infer a single 4:1 mux
    assign y = i[s];

endmodule