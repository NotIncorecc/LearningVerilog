# Walkthrough: 7-Segment Decoder & SIPO Register

## Files Created/Modified

| File | Action |
|------|--------|
| [sevensegment.v](file:///home/gokulganesan/Documents/verilogDDlab/sevensegment/sevensegment.v) | Rewrote — BCD→7seg decoder (active-low) |
| [sevensegment_tb.v](file:///home/gokulganesan/Documents/verilogDDlab/sevensegment/sevensegment_tb.v) | New — sweeps all 16 BCD inputs |
| [sipo_register.v](file:///home/gokulganesan/Documents/verilogDDlab/sipo_register/sipo_register.v) | New — 4-bit SIPO shift register |
| [sipo_register_tb.v](file:///home/gokulganesan/Documents/verilogDDlab/sipo_register/sipo_register_tb.v) | New — shifts pattern `1011`, tests reset |
| [automate.sh](file:///home/gokulganesan/Documents/verilogDDlab/automate.sh) | Added 2 entries to `MODULES` array |

## Verification Results

Both modules ran through the full automation pipeline ([./automate.sh](file:///home/gokulganesan/Documents/verilogDDlab/automate.sh)) — ✅ compile, ✅ simulate, ✅ Yosys synthesis, ✅ waveform generation.

### 7-Segment Decoder

Digits 0–9 produce correct active-low segment patterns; inputs 10–15 output all-blank (`1111111`).

````carousel
![7-Segment Synthesis Schematic](/home/gokulganesan/.gemini/antigravity/brain/0de78afb-2685-467f-a1c9-b429e0e82cba/sevensegment_synthesis.png)
<!-- slide -->
![7-Segment Waveform](/home/gokulganesan/.gemini/antigravity/brain/0de78afb-2685-467f-a1c9-b429e0e82cba/sevensegment_waveform.png)
````

### SIPO Register

Shifting in `1,0,1,1` → `parallel_out = 1011` ✅. Mid-operation reset clears output to `0000` ✅.

````carousel
![SIPO Synthesis Schematic](/home/gokulganesan/.gemini/antigravity/brain/0de78afb-2685-467f-a1c9-b429e0e82cba/sipo_synthesis.png)
<!-- slide -->
![SIPO Waveform](/home/gokulganesan/.gemini/antigravity/brain/0de78afb-2685-467f-a1c9-b429e0e82cba/sipo_waveform.png)
````
