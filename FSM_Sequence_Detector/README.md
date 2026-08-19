# Sequence Detector: Moore vs Mealy (Verilog)

Detects the overlapping bit pattern **1011** in a serial stream, implemented
twice — once as a Moore machine and once as a Mealy machine — to compare
state count, output timing, and glitch behaviour.

## Design

Both machines track how much of the pattern has been matched so far, and
handle **overlap**: after a match, the trailing `1` can begin the next one,
so the stream `1011011` produces two detections rather than one.

### Moore — 5 states

| State | Meaning | w=1 | w=0 |
|---|---|---|---|
| s0 | nothing matched | s1 | s0 |
| s1 | saw 1 | s1 | s2 |
| s2 | saw 10 | s3 | s0 |
| s3 | saw 101 | s4 | s2 |
| s4 | saw 1011 | s1 | s2 |

Output: `y = (state == s4)`

### Mealy — 4 states

| State | Meaning | w=1 | w=0 |
|---|---|---|---|
| s0 | nothing matched | s1 | s0 |
| s1 | saw 1 | s1 | s2 |
| s2 | saw 10 | s3 | s0 |
| s3 | saw 101 | s1 | s2 |

Output: `y = (state == s3) && w`

The Mealy machine needs no accepting state — the match is signalled on the
transition out of s3, so s3 with `w=1` goes straight back to s1.

## Comparison

| | Moore | Mealy |
|---|---|---|
| States | 5 | 4 |
| State register width | 3 bits | 2 bits |
| Output depends on | state only | state and input |
| Detection timing | one clock after the final bit | same clock as the final bit |
| Output glitches | none — changes only on state transitions | possible — follows `w` combinationally |

**Trade-off:** Mealy is smaller and responds a cycle earlier, but its output
is combinational and will follow any glitch on the input. Moore's output is
effectively registered and glitch-free, at the cost of an extra state and one
cycle of latency. A registered-Mealy variant gives Mealy's state count with
Moore's clean output, reintroducing the one-cycle delay.

## Verification

Each design has a testbench driving the stream `1011011`, which must produce
**two** detections — the case that fails if overlap is handled incorrectly.

The testbenches differ only in when the output is sampled: the Moore version
reads `y` after the clock edge, the Mealy version reads it within the same
cycle, reflecting the timing difference above.

## Coding notes

- Two-process FSM style: one clocked block for the state register, one
  combinational block for next-state logic.
- `nxt_state = state;` is assigned before the case statement so every path
  through the combinational block has an assignment, preventing latch
  inference.
- Blocking assignments (`=`) in the combinational block, non-blocking (`<=`)
  in the clocked block.

## Tools

Xilinx Vivado 2023.2, Verilog HDL.
