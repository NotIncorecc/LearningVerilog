module full_subtractor(
    input a,           // Minuend
    input b,           // Subtrahend
    input b_in,        // Borrow input
    output difference, // Difference output
    output b_out       // Borrow output
);

    assign difference = a ^ b ^ b_in;
    assign b_out = (~a & b) | ((~(a ^ b)) & b_in);

endmodule