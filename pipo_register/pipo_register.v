// 4-bit PIPO (Parallel-In Parallel-Out) Register with Synchronous Load and Reset
module pipo_register (
    input        clk,       // Clock signal
    input        rst,       // Synchronous reset (active-high)
    input        load,      // Load enable (active-high)
    input  [3:0] d,         // Parallel data input
    output reg [3:0] q      // Parallel data output
);

    always @(posedge clk) begin
        if (rst)
            q <= 4'b0000;
        else if (load)
            q <= d;
    end

endmodule
