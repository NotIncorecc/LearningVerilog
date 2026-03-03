
module full_adder_tb;

  // Parameters

  //Ports
  reg a;
  reg b;
  reg carry_in;
  wire sum;
  wire carry_out;

  full_adder  full_adder_inst (
    .a(a),
    .b(b),
    .carry_in(carry_in),
    .sum(sum),
    .carry_out(carry_out)
  );

//always #5  clk = ! clk ;
    initial begin
        // Waveform Dumping
        $dumpfile("full_adder_waves.vcd");
        $dumpvars(0, full_adder_tb);

        // Test Cases
        a = 0; b = 0; carry_in = 0; #10;
        a = 0; b = 0; carry_in = 1; #10;
        a = 0; b = 1; carry_in = 0; #10;
        a = 0; b = 1; carry_in = 1; #10;
        a = 1; b = 0; carry_in = 0; #10;
        a = 1; b = 0; carry_in = 1; #10;
        a = 1; b = 1; carry_in = 0; #10;
        a = 1; b = 1; carry_in = 1; #10;

        $finish; // End simulation
    end

endmodule