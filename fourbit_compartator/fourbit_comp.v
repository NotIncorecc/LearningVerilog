module fourbit_comp (
    input [3:0] a,
    input [3:0] b,
    output eq,
    output gt,
    output lt
);

    assign eq = (a == b) ? 1'b1 : 1'b0;
    assign gt = (a > b) ? 1'b1 : 1'b0;
    assign lt = (a < b) ? 1'b1 : 1'b0;

endmodule
