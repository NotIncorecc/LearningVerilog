module alu_4bit (
    input [3:0] a,      // Operand A
    input  [3:0] b,      // Operand B
    input  [3:0] select, 
    input cin,
    output reg [3:0] result,  // Result
    output reg carry          // Carry/borrow flag
)
    wire c1, c2, c3;

    alu_1bit bit0 (
        .a(a[0]),
        .b(b[0]),
        .select(select),
        .carry(cin),        // What should the very first carry-in be?
        .shift_in_l(a[1]),   // Neighbor to the left
        .shift_in_r(1'b0),   // Nothing to the right of bit 0
        .result(result[0]),
        .carry_out(c1)
    );

    alu_1bit bit1 (
        .a(a[1]),
        .b(b[1]),
        .select(select),
        .carry(c1),           // Carry from bit 0
        .shift_in_l(a[2]),   // Neighbor to the left
        .shift_in_r(a[0]), // Shift in from the right is the result of the previous bit
        .result(result[1]),
        .carry_out(c2)
    );

    alu_1bit bit2 (
        .a(a[2]),
        .b(b[2]),
        .select(select),
        .carry(c2),           // Carry from bit 1
        .shift_in_l(a[3]),   // Neighbor to the left
        .shift_in_r(a[1]), // Shift in from the right is the result of the previous bit
        .result(result[2]),
        .carry_out(c3)
    );

    alu_1bit bit3 (
        .a(a[3]),
        .b(b[3]),
        .select(select),
        .carry(c3),           // Carry from bit 2
        .shift_in_l(1'b0),   // Nothing to the left of bit 3
        .shift_in_r(a[2]), // Shift in from the right is the result of the previous bit
        .result(result[3]),
        .carry_out(carry)
    );

endmodule
