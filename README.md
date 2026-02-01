# RISC-V Pipeline CPU

## Overview
This project implements a **RISC-V based pipelined CPU** using **Verilog HDL**.
The processor follows the RISC-V instruction set architecture and is designed
using a **multi-stage pipeline** to improve instruction throughput and overall
performance.

---

## Motivation
Single-cycle processors suffer from low performance due to long instruction
execution time. By introducing **instruction pipelining**, multiple instructions
can be executed in parallel across different stages, significantly improving
CPU throughput.

---

## Pipeline Architecture
The processor is divided into the following pipeline stages:

1. **Instruction Fetch (IF)** – Fetches instruction from instruction memory  
2. **Instruction Decode (ID)** – Decodes instruction and reads registers  
3. **Execute (EX)** – Performs ALU operations and address calculations  
4. **Memory Access (MEM)** – Accesses data memory for load/store instructions  
5. **Write Back (WB)** – Writes results back to the register file  

This design supports **3-stage / 5-stage pipeline** implementations depending on
configuration.

---

## Features
- RISC-V compliant instruction execution
- Multi-stage pipelined architecture
- Improved throughput over single-cycle design
- Modular Verilog implementation
- Suitable for academic and learning purposes

---

## Files Included
- `if_stage.v` – Instruction Fetch stage  
- `id_stage.v` – Instruction Decode stage  
- `ex_stage.v` – Execute stage  
- `mem_stage.v` – Memory Access stage  
- `wb_stage.v` – Write Back stage  
- `control_unit.v` – Control logic  
- `register_file.v` – Register file  
- `alu.v` – Arithmetic Logic Unit  
- `tb_riscv_pipeline.v` – Testbench  
- Waveform screenshots / reports (if included)  
- Vivado project files (`.xpr`, `.srcs`) – optional  

---

## Tools Used
- Verilog HDL  
- Xilinx Vivado  
- Git & GitHub  

---

## Simulation & Verification
- Functional verification performed using a Verilog testbench
- Correct execution of arithmetic, load, and store instructions verified
- Pipeline behavior observed using simulation waveforms

---

## Applications
- CPU microarchitecture studies
- RISC-V based processor design
- Computer architecture education
- VLSI and digital design learning

---

## Conclusion
The **RISC-V Pipeline CPU** project demonstrates how pipelining improves processor
performance by overlapping instruction execution. The modular design makes it
easy to understand, modify, and extend for further research or enhancements.

---

## Author
**Aashi Awasthi**  

