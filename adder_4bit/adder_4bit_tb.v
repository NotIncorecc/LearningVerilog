module adder_4bit_tb;
    reg [3:0] A;
    reg [3:0] B;
    reg Cin;
    wire [3:0] Sum;
    wire Cout;

    adder_4bit uut (
        .A(A),
        .B(B),
        .Cin(Cin),
        .Sum(Sum),
        .Cout(Cout)
    );

    initial begin
        //Icarus Verilog- name of the file to create [cite: 145]
        $dumpfile("adder_waves.vcd"); 
        //Icarus Verilog dumps all signals in this module (level 0) [cite: 146]
        $dumpvars(0, adder_4bit_tb); 
        
        $display("A  B  Cin | Sum Cout");
        $monitor("%d  %d  %b   | %d   %b", A, B, Cin, Sum, Cout);

        //Simple addition
        A = 4'd2; B = 4'd3; Cin = 1'b0; #10;
        //Addition with Cin
        A = 4'd5; B = 4'd5; Cin = 1'b1; #10;
        //Testing Overflow (Cout)
        A = 4'd15; B = 4'd1; Cin = 1'b0; #10;
        //Max values
        A = 4'hf; B = 4'hf; Cin = 1'b1; #10;
        $finish; // End the simulation
    end
endmodule