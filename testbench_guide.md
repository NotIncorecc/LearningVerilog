Optimizing tool selection...**Combinational Testbench Checklist (Standard Format)**

1. `timescale` declared.
2. Testbench module created (`*_tb`) with no ports.
3. DUT inputs declared as `reg`, DUT outputs as `wire`.
4. DUT instantiated with clear port mapping.
5. Wave dump added:
```verilog
$dumpfile("name.vcd");
$dumpvars(0, tb_name);
```
6. Inputs initialized to known values at start.
7. For each testcase:
   1. Apply input vector.
   2. Wait small settle delay (`#1` to `#5`).
   3. Compare expected vs actual (`if`/`!==`).
   4. Print PASS/FAIL message with vector details.
8. Include corner vectors:
   1. all-zeros
   2. all-ones
   3. alternating (`1010`, `0101`)
   4. one-bit changes (toggle one input at a time)
9. Keep pass/fail counters (`integer pass, fail`).
10. End with summary print + `$finish`.

Minimal combinational testcase pattern:
```verilog
a = 0; b = 1; sel = 0; #1;
if (y !== 0) begin fail = fail + 1; $display("FAIL ..."); end
else begin pass = pass + 1; $display("PASS ..."); end
```

---

**Sequential Testbench Checklist (Standard Format)**

1. `timescale` declared.
2. Testbench module created (`*_tb`) with no ports.
3. DUT inputs as `reg`, outputs as `wire`.
4. DUT instantiated.
5. Clock generator added:
```verilog
initial clk = 0;
always #5 clk = ~clk;   // 10ns period
```
6. Wave dump added.
7. Inputs/reset initialized before first clock edge.
8. Reset phase handled correctly:
   1. assert reset
   2. wait required edges (`@(posedge clk)`)
   3. deassert reset
9. Stimulus aligned to edges:
   1. set inputs before active edge
   2. wait active edge (`@(posedge clk)`)
   3. small delay `#1` to observe updated outputs
10. For each testcase:
    1. drive inputs
    2. wait clock edge
    3. check expected state/output
    4. log PASS/FAIL
11. Include stateful corner cases:
    1. reset during operation
    2. back-to-back input changes
    3. hold same input for multiple cycles
    4. transitions around reset release
12. Use pass/fail counters and final summary.
13. End with `$finish`.

Minimal sequential testcase pattern:
```verilog
d = 1'b1;          // drive before edge
@(posedge clk);    // sample happens here
#1;                // allow nonblocking assignment update
if (q !== 1'b1) begin fail = fail + 1; $display("FAIL ..."); end
else begin pass = pass + 1; $display("PASS ..."); end
```

---

**Reusable “Standard Skeleton”**

```verilog
`timescale 1ns/1ps
module dut_tb;
  // 1) Declarations
  reg  ...inputs...;
  wire ...outputs...;
  integer pass = 0, fail = 0;

  // 2) DUT
  dut uut (...);

  // 3) Clock (sequential only)
  // initial clk = 0;
  // always #5 clk = ~clk;

  // 4) Optional checker task
  task check;
    input cond;
    input [255:0] name;
    begin
      if (!cond) begin fail = fail + 1; $display("FAIL: %0s @%0t", name, $time); end
      else begin pass = pass + 1; $display("PASS: %0s @%0t", name, $time); end
    end
  endtask

  // 5) Stimulus
  initial begin
    $dumpfile("dut_waves.vcd");
    $dumpvars(0, dut_tb);

    // init/reset
    // testcases
    // summary

    $display("RESULT: PASS=%0d FAIL=%0d", pass, fail);
    $finish;
  end
endmodule
```

---

If you want, I can now convert your D flip-flop testbench into this exact pass/fail checklist format so you can reuse it as a base file for all future labs.