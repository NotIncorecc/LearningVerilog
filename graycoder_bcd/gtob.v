module bcd_to_gray(
    input [3:0] bcd,
    output [3:0] gray
);

    wire [3:0] binary;
    
    assign binary = bcd;
    assign gray = binary ^ (binary >> 1);

endmodule