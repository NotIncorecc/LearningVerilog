
module mux4x1_dataflow_tb;

  // Ports
  reg [3:0] i;
  reg [1:0] s;
  wire y;

  mux4x1_dataflow  mux4x1_dataflow_inst (
    .i(i),
    .s(s),
    .y(y)
  );

//always #5  clk = ! clk ;
    integer si;
    initial begin
      // Waveform Dumping
      $dumpfile("mux4x1_waves.vcd");
      $dumpvars(0, mux4x1_dataflow_tb);

      // Test Cases
      i = 4'b0001;
      for (si = 0; si < 4; si = si + 1) begin
        s = si[1:0];
        #10;
      end

      i = 4'b1010;
      for (si = 0; si < 4; si = si + 1) begin
        s = si[1:0];
        #10;
      end

      i = 4'b1111;
      for (si = 0; si < 4; si = si + 1) begin
        s = si[1:0];
        #10;
      end

      $finish; // End simulation
    end

endmodule