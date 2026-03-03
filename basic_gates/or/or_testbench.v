
module orGate_tb;

  // Parameters

  //Ports
  reg a;
  reg b;
  wire c;

  orGate  orGate_inst (
    .a(a),
    .b(b),
    .c(c)
  );

    initial begin
        // Waveform Dumping
        $dumpfile("orGate_waves.vcd");
        $dumpvars(0, orGate_tb);

        // Test Cases
        a = 0; b = 0; #10;
        a = 0; b = 1; #10;
        a = 1; b = 0; #10;
        a = 1; b = 1; #10;

        $finish; // End simulation
    end

endmodule