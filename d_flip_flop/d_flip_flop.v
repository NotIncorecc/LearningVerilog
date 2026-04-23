// D Flip-Flop with Synchronous Reset
module d_flip_flop (
    input  clk,       // Clock signal
    input  rst,       // Synchronous reset (active-high)
    input  d,         // Data input
    output reg q,     // Output
    output     q_bar  // Complementary output
);

    assign q_bar = ~q;

    always @(posedge clk) begin
        if (rst)
            q <= 1'b0;
        else
            q <= d;
    end

endmodule
