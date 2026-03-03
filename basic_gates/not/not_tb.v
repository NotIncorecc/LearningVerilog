
module notGate_tb;

  // Parameters

  //Ports
  reg a;
  wire c;

  notGate  notGate_inst (
    .a(a),
    .c(c)
  );

//always #5  clk = ! clk ;
    initial begin
        // Waveform Dumping
        $dumpfile("notGate_waves.vcd");
        $dumpvars(0, notGate_tb);

        // Test Cases
        a = 0; #10;
        a = 1; #10;

        $finish; // End simulation
    end

endmodule