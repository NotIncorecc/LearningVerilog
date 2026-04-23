#!/bin/bash
# ============================================================================
# Verilog Automation Script
# Compiles, simulates, generates Yosys synthesis schematics, and waveform PNGs
# Usage: ./automate.sh [folder_name]  (omit folder to run for all)
# ============================================================================

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Color codes
GREEN='\033[0;32m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

# Module configurations: folder|design_file|testbench|top_module
MODULES=(
    "priority_encoder|priority_encoder.v|priority_encoder_tb.v|priority_encoder_8to3"
    "encoder|encoder.v|encoder_tb.v|encoder_8to3"
    "decoder|decoder.v|decoder_tb.v|decoder_3to8"
    "flip_flop|flip_flop.v|flip_flop_tb.v|d_flip_flop"
    "sevensegment|sevensegment.v|sevensegment_tb.v|bcd_to_7seg"
    "sipo_register|sipo_register.v|sipo_register_tb.v|sipo_4bit"
    "d_flip_flop|d_flip_flop.v|d_flip_flop_tb.v|d_flip_flop"
    "jk_flip_flop|jk_flip_flop.v|jk_flip_flop_tb.v|jk_flip_flop"
    "alu|alu.v|alu_tb.v|alu_4bit"
    "pipo_register|pipo_register.v|pipo_register_tb.v|pipo_register"
)

process_module() {
    local config="$1"
    IFS='|' read -r folder design tb top_module <<< "$config"

    local dir="${SCRIPT_DIR}/${folder}"
    echo -e "\n${CYAN}═══════════════════════════════════════════════════════════${NC}"
    echo -e "${CYAN}  Processing: ${YELLOW}${folder}${NC}"
    echo -e "${CYAN}═══════════════════════════════════════════════════════════${NC}"

    cd "$dir"

    # Step 1: Compile
    echo -e "\n${GREEN}[1/4]${NC} Compiling with iverilog..."
    iverilog -o test.out "$design" "$tb"
    echo "  ✓ Compiled → test.out"

    # Step 2: Simulate
    echo -e "${GREEN}[2/4]${NC} Running simulation..."
    vvp test.out -vcd 2>&1 | head -20
    local vcd_file=$(ls *.vcd 2>/dev/null | head -1)
    echo "  ✓ Simulation complete → ${vcd_file}"

    # Step 3: Yosys synthesis + schematic image
    echo -e "${GREEN}[3/4]${NC} Generating Yosys synthesis schematic..."
    yosys -q -p "read_verilog ${design}; proc; opt; show -format png -prefix synthesis -viewer none" 2>&1
    echo "  ✓ Synthesis schematic → synthesis.png"

    # Step 4: Waveform image
    echo -e "${GREEN}[4/4]${NC} Generating waveform image..."
    python3 "${SCRIPT_DIR}/generate_waveform.py" "$vcd_file" "waveform.png"
    echo "  ✓ Waveform image → waveform.png"

    # Summary
    echo -e "\n${GREEN}  ✓ All outputs:${NC}"
    ls -lh test.out *.vcd synthesis.png waveform.png 2>/dev/null | awk '{print "    " $NF " (" $5 ")"}'
}

# Main
echo -e "${YELLOW}╔═══════════════════════════════════════════════════════════╗${NC}"
echo -e "${YELLOW}║       Verilog Automation: Compile → Simulate → Image     ║${NC}"
echo -e "${YELLOW}╚═══════════════════════════════════════════════════════════╝${NC}"

if [ -n "$1" ]; then
    # Process a specific module
    found=0
    for config in "${MODULES[@]}"; do
        IFS='|' read -r folder _ _ _ <<< "$config"
        if [ "$folder" = "$1" ]; then
            process_module "$config"
            found=1
            break
        fi
    done
    if [ "$found" -eq 0 ]; then
        echo -e "${RED}Error: Module '$1' not found. Available: ${MODULES[*]%%|*}${NC}"
        exit 1
    fi
else
    # Process all modules
    for config in "${MODULES[@]}"; do
        process_module "$config"
    done
fi

echo -e "\n${GREEN}╔═══════════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║                    All tasks complete!                    ║${NC}"
echo -e "${GREEN}╚═══════════════════════════════════════════════════════════╝${NC}"
