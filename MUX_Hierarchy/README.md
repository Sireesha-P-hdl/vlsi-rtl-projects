# Multiplexer Hierarchy in Verilog

Design and verification of a complete multiplexer building-block hierarchy — from a base 2:1 MUX up to a 16:1 MUX — implemented in four structurally distinct ways and verified for functional equivalence.

## Overview

This project explores how the **same Boolean function** (an N:1 multiplexer) can be implemented using different structural decompositions, and how those choices affect **logic depth** (and therefore propagation delay) in real hardware.

## Modules

| File | Description |
|---|---|
| `mux2_1.v` | Base 2:1 multiplexer (behavioral) |
| `mux4_1.v` | 4:1 multiplexer, direct case-statement implementation |
| `mux4_1_using_2_1.v` | 4:1 multiplexer built hierarchically from three 2:1 MUXes |
| `mux8_1.v` | 8:1 multiplexer, direct case-statement implementation |
| `mux8_1_using_4_1_and_2_1.v` | 8:1 multiplexer built from two 4:1 MUXes + one 2:1 MUX |
| `mux16_1.v` | 16:1 multiplexer, direct case-statement reference model |
| `mux16_1_using_2_1.v` | 16:1 MUX built from 8×(2:1) → 2×(4:1) → 1×(2:1) — 3 logic levels |
| `mux16_1_using_4_1.v` | 16:1 MUX built from 4×(4:1) → 1×(4:1) — 2 logic levels |
| `mux16_1_using_8_1.v` | 16:1 MUX built from 2×(8:1) → 1×(2:1) — 3 logic levels |

## Verification

Two self-checking testbenches are included:
- `mux_hierarchy_tb.v` — verifies the 4:1 and 8:1 hierarchical implementations against their direct case-based counterparts.
- `mux16_1_hierarchy_tb.v` — verifies all three 16:1 implementations against the direct case-based reference model, using an exhaustive sweep of all 16 select values plus 10 randomized (data, select) trials.

**Result:** All 26 test vectors passed (`sim_log.txt`); synthesized cleanly on Xilinx Vivado 2023.2 (part: xc7z007sclg400-2) with 0 errors and 0 warnings.

## Key finding — logic depth and delay

| Implementation | Logic levels | Notes |
|---|---|---|
| 16:1 using 2:1 blocks | 3 | 2:1 → 4:1 → 2:1 chain |
| 16:1 using 4:1 blocks | 2 | Fewest levels — lowest expected propagation delay |
| 16:1 using 8:1 blocks | 3 | 8:1 → 2:1 chain |

All three are functionally identical, but the **4:1-based decomposition has the fewest logic levels**, and would be expected to have the lowest propagation delay in a real gate-level implementation — the same speed/structure trade-off seen when comparing Ripple Carry vs. Carry Lookahead adders.

## Bug found and fixed

During development, the base `mux2_1` module initially used a non-standard select convention (`sel=1 → I[0]`).
## Tools used

- Xilinx Vivado 2023.2 (behavioral simulation + RTL synthesis)
- Verilog HDL

# Multiplexer Design, Verification & Scaling Study (Verilog / Vivado)

Design, functional verification, and post-implementation analysis of a multiplexer family (2:1 → 4:1 → 8:1 → 16:1) in Verilog, including a comparison of multiple structural decompositions of the same function.

**Target:** Xilinx Zynq-7000 `xc7z007sclg400-2` | **Tools:** Vivado 2023.2

---

## 1. What this project does

The same Boolean function — an N:1 multiplexer — can be described in RTL many different ways: as a flat `case` statement, or built hierarchically from smaller mux blocks. This project implements several of those descriptions, verifies they are functionally equivalent, and then measures what they actually become in hardware after synthesis and place-and-route.

Two questions drove the work:

1. Do structurally different RTL descriptions of the same function produce different hardware?
2. How do delay, area, and power scale as mux width increases?

---

## 2. Modules

| Module | Description |
|---|---|
| `mux` | 2:1 multiplexer (behavioral) |
| `mux4_1` | 4:1 multiplexer, direct `case` implementation |
| `mux4_1using2_1` | 4:1 built from three 2:1 blocks |
| `mux_8_1` | 8:1 multiplexer, direct `case` implementation |
| `mux8_1using4_1and2_1` | 8:1 built from two 4:1 + one 2:1 |
| `mux_16_1` | 16:1 multiplexer, direct `case` reference model |
| `mux16_1using2_1` | 16:1 built from 8×(2:1) → 2×(4:1) → 1×(2:1) |
| `mux_16_1using4_1` | 16:1 built from 4×(4:1) → 1×(4:1) |
| `mux_16_1using8_1` | 16:1 built from 2×(8:1) → 1×(2:1) |

---

## 3. Verification

Two self-checking testbenches, using exhaustive select sweeps plus randomised stimulus:

- `mux_hierarchy_tb.v` — checks the 4:1 and 8:1 hierarchical builds against their direct `case` counterparts.
- `mux16_1_hierarchy_tb.v` — checks all three 16:1 hierarchical builds against the direct `case` reference model simultaneously.

**Results:** 26/26 test vectors passed on the 16:1 testbench (16 exhaustive + 10 randomised). All designs also passed **post-synthesis functional simulation**, confirming the synthesised gate-level netlist matches RTL behaviour. Clean synthesis with 0 errors and 0 warnings. Full log in `sim_log.txt`.

### Bug found and fixed

The base 2:1 module was initially written with a non-standard select convention (`sel=1 → I[0]`). It behaved correctly in isolation, but silently produced wrong results once composed hierarchically into the 4:1 and 16:1 builds — the entire select mapping came out reversed. Caught by tracing hierarchical outputs against a reference model; fixed by standardising the base block to `sel=0 → I[0]`, `sel=1 → I[1]`.

*Takeaway: a convention error in a small reusable block propagates silently through everything built on top of it. Self-checking testbenches against an independent reference model catch this; waveform inspection alone does not.*

---

## 4. Post-implementation results

All figures measured after full synthesis + place-and-route, via `report_timing`, `report_utilization`, and `report_power`.

### Scaling across mux width

| Design | Leaf cells | Nets | tpd (max) | Logic / Net delay | Levels | tcd (min) | Total power |
|---|---|---|---|---|---|---|---|
| 2:1 | 5 | 8 | 5.988 ns | 3.368 / 2.619 | 3 | 2.114 ns | 0.448 W |
| 4:1 | 8 | 14 | 6.053 ns | 3.343 / 2.710 | 3 | 2.096 ns | 0.550 W |
| 8:1 | 15 | 26 | 6.441 ns | 3.665 / 2.776 | 4 | 2.194 ns | 0.661 W |
| 16:1 | 28 | 48 | 6.979 ns | 3.811 / 3.169 | 5 | 2.316 ns | 0.805 W |

