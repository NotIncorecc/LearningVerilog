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

    it may not work sometimes so use
    ```bash
    iverilog -g2012 -o output.vvp alu_4bit.v alu_4bit_tb.v
vvp output.vvp
    ```
    - this command will run the alu code if you go run this in the appropriate folder

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

Everything is automated! Here's what was created:

### New Files
- **`automate.sh`** — Single command to compile, simulate, and generate all images
- **`generate_waveform.py`** — Python VCD→PNG renderer (matplotlib, dark theme)

### Generated Outputs (per module)
| File | Source |
|---|---|
| `synthesis.png` | Yosys → Graphviz circuit schematic |
| `waveform.png` | Python/matplotlib VCD waveform plot |

### Usage
```bash
./automate.sh              # Run all 4 modules
./automate.sh flip_flop    # Run a specific module
```

To add new experiments, add an entry to the `MODULES` array in `automate.sh`. Check the walkthrough for sample output images.