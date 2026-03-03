module fourbit_comp_tb;

  // Parameters

  //Ports
  reg [3:0] a;
  reg [3:0] b;
  wire eq;
  wire gt;
  wire lt;

  fourbit_comp  fourbit_comp_inst (
    .a(a),
    .b(b),
    .eq(eq),
    .gt(gt),
    .lt(lt)
  );

    initial begin
        // Waveform Dumping
        $dumpfile("fourbit_comp_waves.vcd");
        $dumpvars(0, fourbit_comp_tb);

        // Test Cases
        a = 4'b0000; b = 4'b0000; #10; // eq=1, gt=0, lt=0
        a = 4'b0001; b = 4'b0000; #10; // eq=0, gt=1, lt=0
        a = 4'b0000; b = 4'b0001; #10; // eq=0, gt=0, lt=1
        a = 4'b1010; b = 4'b0101; #10; // eq=0, gt=1, lt=0
        a = 4'b0101; b = 4'b1010; #10; // eq=0, gt=0, lt=1

        $finish; // End simulation
    end

endmodule