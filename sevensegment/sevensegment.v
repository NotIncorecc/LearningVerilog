// BCD to 7-Segment Decoder (Active-Low Outputs)
// Segments: seg[6:0] = {g, f, e, d, c, b, a}
module bcd_to_7seg (
    input  [3:0] bcd,      // 4-bit BCD input (0–9)
    output reg [6:0] seg   // 7-segment output (active-low)
);

    always @(*) begin
        case (bcd)
            4'd0: seg = 7'b100_0000;  // 0
            4'd1: seg = 7'b111_1001;  // 1
            4'd2: seg = 7'b010_0100;  // 2
            4'd3: seg = 7'b011_0000;  // 3
            4'd4: seg = 7'b001_1001;  // 4
            4'd5: seg = 7'b001_0010;  // 5
            4'd6: seg = 7'b000_0010;  // 6
            4'd7: seg = 7'b111_1000;  // 7
            4'd8: seg = 7'b000_0000;  // 8
            4'd9: seg = 7'b001_0000;  // 9
            default: seg = 7'bxxxxxxx; // "Don't Care" optimization
        endcase
    end

endmodule