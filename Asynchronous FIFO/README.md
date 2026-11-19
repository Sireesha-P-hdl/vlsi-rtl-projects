# Asynchronous FIFO (16 x 8-bit) in Verilog HDL

## 🧠 Project Overview

I designed an **asynchronous FIFO** that moves bytes safely between two clocks that have nothing to do with each other: a **7 ns write clock** and an **11 ns read clock**.

Storing the data is the easy part. The hard part is letting each side know where the other side's pointer is, without ever catching a half-changed value. That is what **Gray code** and **two-flop synchronizers** are for, and this project is mostly about those two ideas.

---

# 🚀 Key Features

✅ 16 locations x 8 bits

✅ Separate write and read clocks, each with its own active-low reset

✅ 5-bit write and read pointers (4 address bits plus 1 lap bit)

✅ Pointers cross between the clocks in Gray code, through two flip-flops

✅ Registered full and empty flags

✅ Self-checking testbench that follows the pointers step by step

---

# 📖 Background

## Why an asynchronous FIFO?

When one part of a chip runs on one clock and another part runs on a different clock, you cannot pass data straight across. A FIFO with its own write side and read side is the standard way to do it safely.

## Why Gray code?

From one count to the next, Gray code changes exactly one bit. The other clock may sample the pointer right while it is changing, but with only one bit moving it sees either the old value or the new value, never a mix of both.

## Why two flip-flops?

A flip-flop that samples a signal at the wrong moment can go metastable for a short time. Passing the pointer through two flip-flops gives it a full clock cycle to settle before anything uses it.

## Why 5-bit pointers for 16 slots?

Four bits are enough to pick a slot. The fifth bit counts laps around the memory. Without it, "full" and "empty" would look the same, because in both cases the two pointers point at the same slot.

---

# 🏗 Design

### FIFO Specification

| Field | Description |
|---|---|
| Depth | 16 locations |
| Data width | 8 bits |
| Address width | 4 bits |
| Pointer width | 5 bits (address plus lap bit) |
| Write clock | 7 ns in the testbench |
| Read clock | 11 ns in the testbench |
| Reset | Active-low, one per clock (wrst_n and rrst_n) |
| Read | rdata always shows the word at the read pointer |
| Synchronizers | Two flip-flops in each direction |

### Port Description

| Port | Description |
|---|---|
| wclk | Input, 1 bit. Write clock |
| wrst_n | Input, 1 bit. Write-side reset, active low |
| winc | Input, 1 bit. Write request |
| wdata | Input, 8 bits. Data to write |
| wfull | Output, 1 bit. The FIFO is full, so writes are ignored |
| rclk | Input, 1 bit. Read clock |
| rrst_n | Input, 1 bit. Read-side reset, active low |
| rinc | Input, 1 bit. Read request |
| rdata | Output, 8 bits. Data at the read pointer |
| rempty | Output, 1 bit. The FIFO is empty, so there is nothing to read |

### Modules

| Module | What it does |
|---|---|
| fifo_mem | The 16 x 8-bit memory, written on wclk |
| sync_w2r | Passes the write pointer to the read side through two flip-flops |
| sync_r2w | Passes the read pointer to the write side through two flip-flops |
| wptr_full | The write pointer, its Gray code, and the full flag |
| rptr_empty | The read pointer, its Gray code, and the empty flag |
| async_fifo | The top level that connects them all |

---

# 🔄 How the Pointers Work

Each pointer counts in binary, and the low 4 bits pick the slot. Before crossing to the other clock, the pointer is turned into Gray code with gray = bin ^ (bin >> 1).

| Pointer | Binary | Gray | Slot |
|---|---|---|---|
| 0 | 00000 | 00000 | 0 |
| 1 | 00001 | 00001 | 1 |
| 2 | 00010 | 00011 | 2 |
| 3 | 00011 | 00010 | 3 |
| 4 | 00100 | 00110 | 4 |
| 5 | 00101 | 00111 | 5 |
| 16 | 10000 | 11000 | 0 (one lap later) |
| 19 | 10011 | 11010 | 3 (one lap later) |

### Empty

The FIFO is empty when the read pointer has caught up with the write pointer, so their Gray codes are equal.

### Full

The FIFO is full when the write pointer is exactly one lap (16) ahead of the read pointer. In Gray code, a pointer 16 ahead has its top two bits flipped and the other three bits the same.

| Read pointer | Its Gray code | Top 2 bits flipped | Write pointer that makes it full |
|---|---|---|---|
| 0 | 00000 | 11000 | 16 (Gray 11000) |
| 3 | 00010 | 11010 | 19 (Gray 11010) |

The flags can be a little late, because each side sees the other pointer two flip-flops after it changed. That is safe: the FIFO may say full or empty for a moment too long, but never the other way round.

---

# 🧪 Testbench and Verification

The testbench keeps its own copy of every byte the FIFO accepts (mem_cpy) and checks each read against it. Each input is set tsetup (2 ns) before a rising clock edge and held for thold (2 ns) after it, so the FIFO always sees stable values. Reads are checked just before the read edge, because rdata already shows the word that is about to be read.

### Test Steps

| Step | What happens | What is checked |
|---|---|---|
| 1 | Reset | Empty is 1, full is 0 |
| 2 | Write 5 bytes | Write pointer 5, Gray 00111 |
| 3 | Wait for the crossing | Empty turns off on the read side |
| 4 | Read 3 bytes | Data comes out in order, read pointer 3, Gray 00010 |
| 5 | Write until full | 14 more writes fit, write pointer 19, Gray 11010, full turns on |
| 6 | One more write | It is blocked, nothing changes |
| 7 | Read everything | All 16 bytes come out in order, then empty is 1 again |

### Test Configuration

| Parameter | Value |
|---|---|
| Write clock (wcycle) | 7 ns |
| Read clock (rcycle) | 11 ns |
| Setup before the clock edge (tsetup) | 2 ns |
| Hold after the clock edge (thold) | 2 ns |
| Data written | 01 to 13 (hex), then EE while full |

---

# 📊 Results

| Check | Result |
|---|---|
| Good design | PASS |
| Pointers printed | write 5 = 00111, read 3 = 00010, write 19 = 11010 |
| Extra write while full | Blocked |
| Read back | 04 to 13 (hex), in order |

### Does the testbench catch real bugs?

I broke the design on purpose in five ways, and the testbench failed every time.

| Broken version | Result |
|---|---|
| Full compares without flipping the top 2 bits | FAIL, 21 errors |
| Memory written even when full | FAIL, 1 error |
| Gray conversion shifted the wrong way | FAIL, 4 errors |
| Empty compares binary with Gray | FAIL, 1 error |
| Write pointer moves even when full | FAIL, 1 error |

---

# 📉 Simulation

![Waveform](screenshots/fifo_waveform.png)

*Figure 1: Vivado waveform of the full test. The write clock is 7 ns and the read clock is 11 ns.*

![Console, PASS](screenshots/fifo_pass.png)

*Figure 2: Console output, with the pointer values and PASS.*

In simulation the FIFO memory and the testbench copy both start at 0, so after reset nothing in the waveform is red (unknown). Only the first few nanoseconds, before the reset, show red.

---

# 📂 Repository Structure

```text
Async FIFO/
│
├── Async_fifo.v
├── self_tb.v
├── screenshots/
│   ├── fifo_waveform.png
│   └── fifo_pass.png
└── README.md
```

---

# ⚙️ How to Run

1. Open Xilinx Vivado and create a new project.
2. Add `Async_fifo.v` as a design source and `self_tb.v` as a simulation source.
3. Choose Run Simulation, then Run Behavioral Simulation.
4. Type the following in the Tcl Console to run the test to the end:

```text
run all
```

---

# 🎓 What I Learned

- Why pointers must cross between clocks in Gray code: one bit changes at a time, so the other side never sees a mixed value.
- Why two flip-flops: they give a metastable value time to settle.
- How one extra pointer bit tells full from empty.
- My first test run read every value one position early. The FIFO was fine; the testbench was sampling a combinational read at the wrong moment. Now my testbench checks rdata just before the read edge.

---

# 👩‍💻 Author

Sireesha P

Department of Electronics and Communication Engineering

Dayananda Sagar University, Bengaluru

LinkedIn: https://www.linkedin.com/in/sireesha-p-ec
