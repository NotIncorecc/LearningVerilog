
module norGate_tb;

  // Parameters

  //Ports
  reg a;
  reg b;
  wire c;

  norGate  norGate_inst (
    .a(a),
    .b(b),
    .c(c)
  );

    initial begin
        // Waveform Dumping
        $dumpfile("norGate_waves.vcd");
        $dumpvars(0, norGate_tb);

        // Test Cases
        a = 0; b = 0; #10;
        a = 0; b = 1; #10;
        a = 1; b = 0; #10;
        a = 1; b = 1; #10;

        $finish; // End simulation
    end

endmodule