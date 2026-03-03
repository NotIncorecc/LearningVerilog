
module xnorGate_tb;

  // Parameters

  //Ports
  reg a;
  reg b;
  wire c;

  xnorGate  xnorGate_inst (
    .a(a),
    .b(b),
    .c(c)
  );

//always #5  clk = ! clk ;
    initial begin
        // Waveform Dumping
        $dumpfile("xnorGate_waves.vcd");
        $dumpvars(0, xnorGate_tb);

        // Test Cases
        a = 0; b = 0; #10;
        a = 0; b = 1; #10;
        a = 1; b = 0; #10;
        a = 1; b = 1; #10;

        $finish; // End simulation
    end

endmodule