// 4-bit ALU
// op: 3-bit operation select
//  000 -> ADD  (a + b)
//  001 -> SUB  (a - b)
//  010 -> AND  (a & b)
//  011 -> OR   (a | b)
//  100 -> XOR  (a ^ b)
//  101 -> NOT  (~a)
//  110 -> NAND (~(a & b))
//  111 -> NOR  (~(a | b))
module alu_4bit (
    input  [3:0] a,      // Operand A
    input  [3:0] b,      // Operand B
    input  [2:0] op,     // Operation select
    output reg [3:0] result,  // Result
    output reg zero,          // Zero flag
    output reg carry          // Carry/borrow flag
);
    reg [4:0] temp;

    always @(*) begin
        carry = 1'b0;
        case (op)
            3'b000: begin temp = {1'b0, a} + {1'b0, b}; result = temp[3:0]; carry = temp[4]; end  // ADD
            3'b001: begin temp = {1'b0, a} - {1'b0, b}; result = temp[3:0]; carry = temp[4]; end  // SUB
            3'b010: begin result = a & b; end   // AND
            3'b011: begin result = a | b; end   // OR
            3'b100: begin result = a ^ b; end   // XOR
            3'b101: begin result = ~a;   end    // NOT
            3'b110: begin result = ~(a & b); end // NAND
            3'b111: begin result = ~(a | b); end // NOR
            default: result = 4'b0000;
        endcase
        zero = (result == 4'b0000) ? 1'b1 : 1'b0;
    end

endmodule
