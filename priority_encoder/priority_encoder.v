// 8:3 Priority Encoder
// Higher-indexed input has higher priority
module priority_encoder_8to3 (
    input  [7:0] d,      // 8-bit input
    output reg [2:0] y,   // 3-bit encoded output
    output reg valid      // High when at least one input is active
);

    always @(*) begin
        if (d[7])      begin y = 3'd7; valid = 1'b1; end
        else if (d[6]) begin y = 3'd6; valid = 1'b1; end
        else if (d[5]) begin y = 3'd5; valid = 1'b1; end
        else if (d[4]) begin y = 3'd4; valid = 1'b1; end
        else if (d[3]) begin y = 3'd3; valid = 1'b1; end
        else if (d[2]) begin y = 3'd2; valid = 1'b1; end
        else if (d[1]) begin y = 3'd1; valid = 1'b1; end
        else if (d[0]) begin y = 3'd0; valid = 1'b1; end
        else           begin y = 3'd0; valid = 1'b0; end
    end

endmodule
