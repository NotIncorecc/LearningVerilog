module bcd_to_gray_tb;

  // Parameters

  //Ports
  reg [3:0] bcd;
  wire [3:0] gray;

  bcd_to_gray  bcd_to_gray_inst (
    .bcd(bcd),
    .gray(gray)
  );

    initial begin
        // Waveform Dumping
        $dumpfile("bcd_to_gray_waves.vcd");
        $dumpvars(0, bcd_to_gray_tb);

        // Test Cases
        bcd = 4'b0000; #10; // 0
        bcd = 4'b0001; #10; // 1
        bcd = 4'b0010; #10; // 2
        bcd = 4'b0011; #10; // 3
        bcd = 4'b0100; #10; // 4
        bcd = 4'b0101; #10; // 5
        bcd = 4'b0110; #10; // 6
        bcd = 4'b0111; #10; // 7
        bcd = 4'b1000; #10; // 8
        bcd = 4'b1001; #10; // 9

        $finish; // End simulation
    end

endmodule