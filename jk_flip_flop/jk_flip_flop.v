module jk_flip_flop (
    input      clk,
    input      rst,
    input      j,
    input      k,
    output reg q,
    output     q_bar
);

    assign q_bar = ~q;

    always @(posedge clk) begin
        if (rst)
            q <= 1'b0;
        else
            q <= (j & ~q) | (~k & q);
    end

endmodule