# vlsi-journey-day1

<img width="1909" height="709" alt="Screenshot 2025-11-30 111842" src="https://github.com/user-attachments/assets/0d0f0aff-944f-453e-9998-ee8acbb0a126" />

# 4-bit ALU — Project Documentation

## Project summary
This repository contains a _clean, synthesizable_ 4-bit ALU (Arithmetic Logic Unit) implemented in Verilog, together with a self-checking testbench and simulation artifacts.  
The ALU supports basic arithmetic and logical operations and provides flags for SLT (set-less-than) and Zero. This mini-project demonstrates RTL coding discipline, combinational logic, and verification basics suitable for an entry-level VLSI/verification portfolio.

“ADD/SUB are treated as unsigned arithmetic (4-bit truncated).
SLT uses signed 4-bit comparison.”

---

## Features / Supported operations
- **Width:** 4 bits (result truncated to 4 bits; internal arithmetic uses 5-bit temp to capture carry/overflow)
- **Operations (Opcode → Operation):**

| Opcode (binary) | Opcode (hex) | Operation |
|-----------------|--------------|----------:|
| `000`           | `0x0`        | ADD (A + B) |
| `001`           | `0x1`        | SUB (A - B) |
| `010`           | `0x2`        | AND (A & B) |
| `011`           | `0x3`        | OR  (A | B) |
| `100`           | `0x4`        | XOR (A ^ B) |
| `101`           | `0x5`        | SLT (Set Less Than, signed comparison) |

- **Flags**
  - `SLT_Flag` — asserted when A < B interpreting A and B as signed 4-bit two's complement values.
  - `Zero_Flag` — asserted when the 4-bit `Result` equals `0`.

---

## Files in this folder
- `rtl/alu.v` — Synthesizable 4-bit ALU (main RTL).
- `rtl/tb/alu_tb.v` — Self-checking testbench that runs directed tests and produces a waveform .
- `docs/waveform.png` — Cropped simulation waveform snapshot (committed).
- `docs/README.md` — (this file) project documentation and run instructions.

---

## How to run simulation(In Vivado) 

Vivado==>create project==>Add source ==> Create file(ALU.v-design & ALU_TB.v-simulation)==>wirte the codes==>run simulation==>get waveform


