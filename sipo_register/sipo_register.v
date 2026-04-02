// 4-Bit Serial-In Parallel-Out (SIPO) Shift Register
module sipo_4bit (
    input  clk,                    // Clock signal
    input  rst,                    // Asynchronous reset (active-high)
    input  serial_in,              // Serial data input
    output reg [3:0] parallel_out  // 4-bit parallel output
);

    always @(posedge clk or posedge rst) begin
        if (rst)
            parallel_out <= 4'b0000;
        else
            parallel_out <= {parallel_out[2:0], serial_in};  // Shift left, new bit enters LSB
    end

endmodule
