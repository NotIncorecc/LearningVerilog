`timescale 1ns / 1ps

module basic_tb;

    // 1. Declarations
    reg x;
    reg y;
    wire z;

    // 2. Instantiate the Gate
    andGate uut (
        .x(x),
        .y(y),
        .z(z)
    );

    // 3. The simulation block
    initial begin
        // These lines generate the data for GTKWave [cite: 142, 145, 146]
        $dumpfile("andGate_waves.vcd"); 
        $dumpvars(0, basic_tb); 

        // Apply test cases with delays
        x = 0; y = 0; #10;
        x = 0; y = 1; #10;
        x = 1; y = 0; #10;
        x = 1; y = 1; #10;

        $finish; // Stop the simulation
    end

endmodule