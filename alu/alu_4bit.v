module alu_4bit (
    input [3:0] a,      // Operand A
    input  [3:0] b,      // Operand B
    input  [3:0] select, 
    input cin,
    output reg [3:0] result,  // Result
    output reg carry          // Carry/borrow flag
);
    reg [4:0] temp;

    always @(*) begin
        result = 4'b0000;
        carry = 1'b0;
        temp = 5'b0;

        case (select[3:2])
            2'b00: begin
                // Arithmetic group from table, selected by S1:S0 and Cin.
                case (select[1:0])
                    2'b00: temp = {1'b0, a} + cin;                 // F=A or A+1
                    2'b01: temp = {1'b0, a} + {1'b0, b} + cin;     // F=A+B or A+B+1
                    2'b10: temp = {1'b0, a} + {1'b0, ~b} + cin;    // F=A+~B or A+~B+1
                    2'b11: temp = {1'b0, a} + 5'b0_1111 + cin;     // F=A-1 or A
                    default: temp = 5'b0;
                endcase
                {carry, result} = temp;
            end

            2'b01: begin
                case (select[1:0])
                    2'b00: result = a & b;
                    2'b01: result = a | b;
                    2'b10: result = a ^ b;
                    2'b11: result = ~a;
                    default: result = 4'b0;
                endcase
                carry = 1'b0;
            end

            2'b10: begin
                result = a >> 1;
                carry = 1'b0;
            end

            2'b11: begin
                result = a << 1;
                carry = 1'b0;
            end
        endcase
    end

endmodule
