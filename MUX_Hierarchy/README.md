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
