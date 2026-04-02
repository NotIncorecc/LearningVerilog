#!/usr/bin/env python3
"""
Waveform image generator: Parses VCD files and renders clean waveform PNGs.
Usage: python3 generate_waveform.py <vcd_file> <output_png>
"""
import sys
import os
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt
import matplotlib.patches as mpatches
from vcdvcd import VCDVCD

def render_waveform(vcd_path, output_path):
    vcd = VCDVCD(vcd_path)

    # Collect all signals, deduplicate by short name (keep deepest hierarchy)
    all_signals = [sig for sig in vcd.signals if sig != '$end']
    seen_names = {}
    for sig in all_signals:
        short = sig.split('.')[-1] if '.' in sig else sig
        # Keep the deepest (longest path) version
        if short not in seen_names or len(sig) > len(seen_names[short]):
            seen_names[short] = sig
    signals = list(seen_names.values())

    if not signals:
        print(f"No signals found in {vcd_path}")
        return

    n_signals = len(signals)
    fig_height = max(3, n_signals * 1.2 + 1)
    fig, axes = plt.subplots(n_signals, 1, figsize=(16, fig_height), sharex=True)
    if n_signals == 1:
        axes = [axes]

    # Dark theme
    fig.patch.set_facecolor('#1e1e2e')

    colors = ['#89b4fa', '#a6e3a1', '#f9e2af', '#f38ba8', '#cba6f7',
              '#94e2d5', '#fab387', '#74c7ec', '#b4befe', '#f5c2e7']

    for idx, sig in enumerate(signals):
        ax = axes[idx]
        ax.set_facecolor('#1e1e2e')

        signal_data = vcd[sig]
        tv = signal_data.tv  # list of (time, value) tuples

        if not tv:
            continue

        # Get short signal name (last part)
        short_name = sig.split('.')[-1] if '.' in sig else sig

        color = colors[idx % len(colors)]

        # Determine if multi-bit
        first_val = tv[0][1]
        is_bus = len(first_val) > 1 and first_val not in ('0', '1', 'x', 'z', 'X', 'Z')

        # Get time range
        all_times = [int(t) for t, v in tv]
        max_time = max(all_times) if all_times else 100
        # Extend to the end time from VCD
        end_time = int(vcd.endtime) if hasattr(vcd, 'endtime') and vcd.endtime else max_time

        if is_bus:
            # Draw bus-style waveform (boxes with hex values)
            for i in range(len(tv)):
                t_start = int(tv[i][0])
                t_end = int(tv[i + 1][0]) if i + 1 < len(tv) else end_time
                val = tv[i][1]

                # Draw box
                width = t_end - t_start
                rect = mpatches.FancyBboxPatch(
                    (t_start, 0.1), width, 0.8,
                    boxstyle="round,pad=0.02",
                    facecolor=color + '20',
                    edgecolor=color,
                    linewidth=1.5
                )
                ax.add_patch(rect)

                # Label with hex value
                try:
                    hex_val = hex(int(val, 2))
                except (ValueError, TypeError):
                    hex_val = val
                ax.text(t_start + width / 2, 0.5, hex_val,
                       ha='center', va='center', fontsize=8,
                       color=color, fontweight='bold', fontfamily='monospace')

            ax.set_ylim(-0.1, 1.1)
        else:
            # Draw digital (0/1) step waveform
            times = []
            values = []
            for i in range(len(tv)):
                t = int(tv[i][0])
                try:
                    v = int(tv[i][1])
                except ValueError:
                    v = 0
                times.append(t)
                values.append(v)
                # Extend to next transition
                if i + 1 < len(tv):
                    t_next = int(tv[i + 1][0])
                    times.append(t_next)
                    values.append(v)
                else:
                    times.append(end_time)
                    values.append(v)

            ax.fill_between(times, values, alpha=0.15, color=color, step='post')
            ax.step(times, values, where='post', color=color, linewidth=2)
            ax.set_ylim(-0.2, 1.4)

        # Style each subplot
        ax.set_ylabel(short_name, rotation=0, labelpad=80, ha='left', va='center',
                      fontsize=10, color='#cdd6f4', fontweight='bold', fontfamily='monospace')
        ax.set_yticks([0, 1])
        ax.set_yticklabels(['0', '1'], fontsize=8, color='#6c7086')
        ax.tick_params(axis='x', colors='#6c7086')
        ax.tick_params(axis='y', colors='#6c7086')
        ax.grid(True, axis='x', alpha=0.2, color='#45475a', linestyle='--')
        for spine in ax.spines.values():
            spine.set_color('#45475a')

    # X-axis label on bottom
    axes[-1].set_xlabel('Time (simulation units)', fontsize=11, color='#a6adc8')

    # Title
    base_name = os.path.splitext(os.path.basename(vcd_path))[0]
    fig.suptitle(f'Waveform: {base_name}', fontsize=14, color='#cdd6f4',
                fontweight='bold', y=0.98)

    plt.tight_layout(rect=[0.08, 0.02, 1, 0.96])
    plt.savefig(output_path, dpi=150, facecolor=fig.get_facecolor(),
                edgecolor='none', bbox_inches='tight')
    plt.close()
    print(f"Waveform saved: {output_path}")


if __name__ == '__main__':
    if len(sys.argv) != 3:
        print(f"Usage: {sys.argv[0]} <vcd_file> <output_png>")
        sys.exit(1)

    render_waveform(sys.argv[1], sys.argv[2])
