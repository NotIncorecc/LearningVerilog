module xorGate(
    input a,
    input b,
    output c
);
    assign c = (a & ~b) | (~a & b);
endmodule