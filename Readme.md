# Verilog Simulation and Synthesis Workflow

This documentation describes the process to compile Verilog code, generate waveforms, and view schematics.

## Compilation and Simulation

1. **Compile Verilog to VVP (Value Change Dump)**
    ```bash
    iverilog -o output.vvp your_file.v your_testbench.v
    ```
    - `iverilog`: Verilog compiler (open-source)
    - `-o output.vvp`: Output executable file
    - Compiles Verilog source files into VVP format

2. **Run Simulation with VVP**
    ```bash
    vvp output.vvp -vcd
    ```
    - `vvp`: Verilog simulation engine
    - `-vcd`: Generates Value Change Dump waveform file (dump.vcd)

3. **View Waveforms**
    ```bash
    gtkwave dump.vcd
    ```
    - Open generated VCD file in waveform viewer

## Synthesis and Schematic Viewing

1. **Synthesize with Yosys**
    ```bash
    yosys -p "read_verilog your_file.v; synth_ice40 -json output.json"
    ```
    - `yosys`: Open-source synthesis tool
    - Converts RTL to netlist/schematic representation

2. **View Schematic**
    ```bash
    yosys -p "read_json output.json; show"
    ```
    - Displays circuit schematic diagram

## Complete Workflow

```bash
iverilog -o output.vvp design.v testbench.v
vvp output.vvp -vcd
gtkwave dump.vcd &
yosys -p "read_verilog design.v; synth_ice40 -json output.json"
yosys -p "read_json output.json; show"
```
