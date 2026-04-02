// D Flip-Flop with Asynchronous Reset
module d_flip_flop (
    input  clk,       // Clock signal
    input  rst,       // Asynchronous reset (active-high)
    input  d,         // Data input
    output reg q,     // Output
    output     q_bar  // Complementary output
);

    assign q_bar = ~q;

    always @(posedge clk or posedge rst) begin
        if (rst)
            q <= 1'b0;
        else
            q <= d;
    end

endmodule
