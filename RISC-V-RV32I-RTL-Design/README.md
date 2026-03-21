# RISC-V RV32I RTL Design using Verilog HDL

This repository contains my implementation and study work for a **RISC-V RV32I RTL Design** project using **Verilog HDL**.  
The project focuses on understanding and verifying the core RTL building blocks of a 32-bit RISC-V processor, including datapath and control-related modules.

## Project Overview

The goal of this project is to learn and implement the fundamental RTL components required for a basic **RISC-V RV32I processor**, and to verify them using **Vivado simulation** and waveform analysis.

This project includes:
- RTL design in Verilog
- module-level testbenches
- simulation-based verification
- waveform analysis
- architecture and learning notes

## Features

- 32-bit RISC-V RV32I based RTL design
- Verilog HDL implementation
- Module-wise verification using testbenches
- Arithmetic, logic, comparison, shift, branch, and memory-related blocks
- Vivado simulation support
- Organized documentation and waveform outputs

## Modules Implemented

- ALU
- Instruction Decoder
- Immediate Generator
- Register File
- Program Counter
- Branch Unit
- Load Unit
- Store Unit
- Write-back Mux / Control Logic
- Top Module Integration

## Tools Used

- Verilog HDL
- Xilinx Vivado
- GTKWave / Vivado Waveform Viewer
- Git and GitHub
## Note
This repository is maintained as a personal learning and verification project based on RISC-V RV32I RTL study material and course-guided exercises.

## Folder Structure

```text
rtl/        -> RTL source files
tb/         -> testbenches
waveforms/  -> simulation screenshots / waveform captures
docs/       -> architecture notes, block diagrams, learning notes
results/    -> test summaries and observations
sim/        -> simulator/project setup notes
