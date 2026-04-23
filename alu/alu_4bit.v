module alu_4bit (
    input [3:0] a,      // Operand A
    input  [3:0] b,      // Operand B
    input  [3:0] select, 
    input cin,
    output reg [3:0] result,  // Result
    output reg carry          // Carry/borrow flag
);
    always @(*) begin
        result = 4'b0000;
        carry = 1'b0;

        case (select)
            4'b0000: begin // Transfer A
                result = a;
            end

            4'b0001: begin // A + 1
                {carry, result} = a + 4'b0001;
            end

            4'b0010: begin // A + B
                {carry, result} = a + b;
            end

            4'b0011: begin // A + B + 1
                {carry, result} = a + b + 4'b0001;
            end

            4'b0100: begin // A - B
                result = a - b;
                carry = 1'b0;
            end

            4'b0101: begin // A - B (alternate encoding)
                result = a - b;
                carry = 1'b0;
            end

            4'b0110: begin // A - 1
                result = a - 4'b0001;
                carry = (a == 4'b0000);
            end

            4'b0111: begin // Transfer A (alternate encoding)
                result = a;
            end

            4'b1000: begin // Arithmetic shift right
                result = {a[3], a[3:1]};
            end

            4'b1001: begin // AND
                result = a & b;
            end

            4'b1010: begin // OR
                result = a | b;
            end

            4'b1011: begin // XOR
                result = a ^ b;
            end

            4'b1100: begin // Rotate left
                result = {a[2:0], a[3]};
            end

            4'b1101: begin // NOT A
                result = ~a;
            end

            default: begin
                result = 4'b0000;
                carry = 1'b0;
            end
        endcase
    end

endmodule
