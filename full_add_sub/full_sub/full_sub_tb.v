
module full_subtractor_tb;

  // Parameters

  //Ports
  reg a;
  reg b;
  reg b_in;
  wire difference;
  wire b_out;

  full_subtractor  full_subtractor_inst (
    .a(a),
    .b(b),
    .b_in(b_in),
    .difference(difference),
    .b_out(b_out)
  );
    initial begin
        // Waveform Dumping
        $dumpfile("full_subtractor_waves.vcd");
        $dumpvars(0, full_subtractor_tb);

        // Test Cases
        a = 0; b = 0; b_in = 0; #10;
        a = 0; b = 0; b_in = 1; #10;
        a = 0; b = 1; b_in = 0; #10;
        a = 0; b = 1; b_in = 1; #10;
        a = 1; b = 0; b_in = 0; #10;
        a = 1; b = 0; b_in = 1; #10;
        a = 1; b = 1; b_in = 0; #10;
        a = 1; b = 1; b_in = 1; #10;

        $finish; // End simulation
    end
//always #5  clk = ! clk ;

endmodule