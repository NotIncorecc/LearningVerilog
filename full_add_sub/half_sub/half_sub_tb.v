
module half_sub_tb;

  // Parameters

  //Ports
  reg a;
  reg b;
  wire diff;
  wire borrow;

  half_sub  half_sub_inst (
    .a(a),
    .b(b),
    .diff(diff),
    .borrow(borrow)
  );

    initial begin
        // Waveform Dumping
        $dumpfile("half_sub_waves.vcd");
        $dumpvars(0, half_sub_tb);

        // Test Cases
        a = 0; b = 0; #10;
        a = 0; b = 1; #10;
        a = 1; b = 0; #10;
        a = 1; b = 1; #10;

        $finish; // End simulation
    end
//always #5  clk = ! clk ;

endmodule