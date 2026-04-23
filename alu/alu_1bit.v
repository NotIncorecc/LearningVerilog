module alu_1bit (
    input a,      // Operand A
    input b,      // Operand B
    input [3:0] select,
    input carry,
    input shift_in_l,
    input shift_in_r,
    output reg result,
    output reg carry_out
);

    always @(*) begin
        case (select[3:2])
            2'b00: begin // arithmetic operations
                case ({select[1:0], carry})
                    3'b000: {carry_out, result} = {1'b0,a};
                    3'b001: {carry_out, result} = a + 1'b1;
                    3'b010: {carry_out, result} = a + b;
                    3'b011: {carry_out, result} = a + b + 1'b1;
                    3'b100: {carry_out, result} = a + ~b;
                    3'b101: {carry_out, result} = a + ~b + 1'b1;
                    3'b110: {carry_out, result} = a + 1'b1; // Adding the bit-equivalent of -1
                    3'b111: {carry_out, result} = {1'b0,a};
                    default: {carry_out, result} = 2'b00;
                endcase
            end
            2'b01: begin // logical operations
                case (select[1:0])
                    2'b00: result = a & b; // AND
                    2'b01: result = a | b; // OR
                    2'b10: result = a ^ b; // XOR
                    2'b11: result = ~a;    // NOT
                    default: result = 1'b0;
                endcase
            end
            2'b10: begin
                result = shift_in_r;  // Shift right
            end
            2'b11: begin
                result = shift_in_l;  // Shift left
            end
        endcase
    end

endmodule