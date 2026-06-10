# 5-Stage Pipelined RISC-V Processor with Advanced Hazard Mitigation & Exception Handling

This repository contains the hardware description (HDL) of a high-performance, **5-stage pipelined RISC-V processor** (Fetch, Decode, Execute, Memory, Writeback). Designed for efficiency and robust error handling, this microarchitecture goes beyond standard academic pipelines by integrating a specialized forwarding network to eliminate specific memory hazards and implementing full supervisor-level exception tracking.

---

## 🚀 Special Architectural Features & Design Highlights

While standard 5-stage pipelines rely heavily on performance-killing stall cycles (hazard units) to resolve data dependencies, this design introduces custom hardware bypasses and strict ISA compliance features.

### 1. Optimized Memory-to-Memory Forwarding (Zero-Stall Bypass)
In a typical RISC-V pipeline, back-to-back memory operations—such as loading a value from memory and immediately storing it to another address trigger a hazard unit stall. This occurs because the data isn't available until the end of the Memory stage.

* **My Solution:** This design implements an **Advanced Memory-to-Memory Forwarding Path**.
* **How it works:** Instead of stalling the pipeline for a cycle, a dedicated bypass route captures the emerging data at the output of the Data Memory read port and directly injects it into the Write Data input of the Memory stage for the subsequent store instruction.
* **Impact:** Eliminates typical RAW (Read-After-Write) data hazard stalls for consecutive memory transfers, maximizing IPC (Instructions Per Cycle) throughput.

### 2. Robust Hardware Exception Handling
The processor features a robust, hardware-level Exception Handling Unit capable of identifying runtime anomalies, flushing the corrupted pipeline stages, and gracefully routing control to a trap handler. Supported exceptions include:
* Instruction Address Misaligned
* Illegal Instruction
* Breakpoint / Environment Call (`ecall`)
* Load/Store Address Misaligned

---

## 🧠 Deep Dive: Exception Architecture (`scause` & `sepc`)

When an exception occurs (e.g., an illegal instruction is decoded), the processor stops the problematic instruction from updating the architectural state, flushes the pipeline downstream to prevent cascading errors, and jumps to the pre-configured trap vector address. 

To manage this, the processor implements dedicated Control and Status Registers (CSRs).
### `sepc` (Supervisor Exception Program Counter)
The `sepc` register is a 32-bit register that automatically captures the exact virtual address of the instruction that caused the exception or trap.
* For synchronous exceptions (like an illegal opcode or a misaligned load), `sepc` points **directly to the faulting instruction itself**.
* This allows the trap handler software to inspect the exact instruction that failed, fix the state if necessary, and either re-execute it or skip it upon executing an `sret` (Supervisor Trap Return) instruction.

### `scause` (Supervisor Cause Register)
The `scause` register indicates the precise reason the trap was taken. 

---

## 📐 Processor Architecture & Datapath Layout
The Processor follows **Harvard Architecture** with separate Memories for Instruction and Data fetching.This provides facility to read instruction and access data in memory in the same clock cycle

---

## 🛠️ Instruction Set Architecture (ISA) Support

The processor core currently decodes and executes the following core RISC-V instructions:

| Instruction Category | Assembly Mnemonic | Description |
| :--- | :--- | :--- |
| **I-Type (Arithmetic)** | `addi rd, rs1, imm` | Add Immediate |
| | `andi rd, rs1, imm` | Bitwise AND Immediate |
| | `ori rd, rs1, imm`  | Bitwise OR Immediate |
| | `xori rd, rs1, imm` | Bitwise XOR Immediate |
| **R-Type (Arithmetic)** | `add rd, rs1, rs2`  | Add Registers |
| | `sub rd, rs1, rs2`  | Subtract Registers |
| **R-Type (Bitwise)** | `and rd, rs1, rs2`  | Bitwise AND Registers |
| | `or rd, rs1, rs2`   | Bitwise OR Registers |
| | `xor rd, rs1, rs2`  | Bitwise XOR Registers |
| **S-Type (Memory Write)**| `sd rs2, offset(rs1)`| Store Doubleword (64-bit) |
| **I-Type (Memory Read)** | `ld rd, offset(rs1)` | Load Doubleword (64-bit) |
| **B-Type (Control Flow)**| `beq rs1, rs2, offset`| Branch if Equal (PC Relative) |
| | `bne rs1, rs2, offset`| Branch if Not Equal (PC Relative) |

---

## 💻 Simulation Instructions

This design is validated using Xilinx Vivado .Synthesis and RTL analysis using Linter have been done. Further implementation of processor on FPGA blocks has also been generated
