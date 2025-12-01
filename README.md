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



Day-2 title
“Day 2 — Randomized Testing + Functional Coverage for ALU”

What’s new in Day-2

Random stimulus

Golden reference model

Functional coverage (opcode hit counts)

Directed + Random test combination

How to run simulation
create project → add alu.v + alu_tb_day2.v → run simulation

Waveform screenshot:
<img width="953" height="487" alt="DAY2-4-bitALU" src="https://github.com/user-attachments/assets/04035f58-c9cb-4527-a82e-17170fa22bbd" />

Output summary from Tcl console:(screenshot images)
<img width="927" height="765" alt="Screenshot 2025-12-01 234915" src="https://github.com/user-attachments/assets/96acc2fb-eb51-4dd6-89fe-6b200f9813fb" />
<img width="865" height="765" alt="Screenshot 2025-12-01 234949" src="https://github.com/user-attachments/assets/1a809df6-0688-4494-b43e-4a4df08ae134" />
<img width="329" height="415" alt="image" src="https://github.com/user-attachments/assets/6d5774df-386b-401a-975c-d6d91ac0de6d" />
<img width="646" height="205" alt="image" src="https://github.com/user-attachments/assets/ce033fed-74b0-45c1-937a-d9d339f26291" />




