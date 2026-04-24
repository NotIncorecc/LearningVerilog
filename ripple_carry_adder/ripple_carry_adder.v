// Full Adder: single-bit building block for the ripple carry adder
module full_adder(
    input  A,
    input  B,
    input  Cin,
    output Sum,
    output Cout
);
    assign Sum  = A ^ B ^ Cin;
    assign Cout = (A & B) | (B & Cin) | (A & Cin);
endmodule

// Parameterized N-bit Ripple Carry Adder
// Default width is 4 bits; override with #(N) at instantiation time.
module ripple_carry_adder #(parameter N = 4)(
    input  [N-1:0] A,
    input  [N-1:0] B,
    input          Cin,
    output [N-1:0] Sum,
    output         Cout
);
    wire [N:0] carry;           // carry[0] = Cin, carry[N] = Cout
    assign carry[0] = Cin;

    genvar i;
    generate
        for (i = 0; i < N; i = i + 1) begin : fa_stage
            full_adder fa (
                .A   (A[i]),
                .B   (B[i]),
                .Cin (carry[i]),
                .Sum (Sum[i]),
                .Cout(carry[i+1])
            );
        end
    endgenerate

    assign Cout = carry[N];
endmodule
