
module xorGate_tb;

  // Parameters

  //Ports
  reg a;
  reg b;
  wire c;

  xorGate  xorGate_inst (
    .a(a),
    .b(b),
    .c(c)
  );

//always #5  clk = ! clk ;
    initial begin
        // Waveform Dumping
        $dumpfile("xorGate_waves.vcd");
        $dumpvars(0, xorGate_tb);

        // Test Cases
        a = 0; b = 0; #10;
        a = 0; b = 1; #10;
        a = 1; b = 0; #10;
        a = 1; b = 1; #10;

        $finish; // End simulation
    end

endmodule