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

Output summary from Tcl console:
==== ALU Directed Tests Start ====
RUN: ADD 5+3
TEST 1 PASS
RUN: ADD 10+5
TEST 2 PASS
RUN: ADD 15+1 (overflow)
TEST 3 PASS
RUN: ADD 7+8
TEST 4 PASS
RUN: SUB 10-3
TEST 5 PASS
RUN: SUB 5-5 (zero)
TEST 6 PASS
RUN: SUB 3-10 (neg)
TEST 7 PASS
RUN: AND 13 & 7
TEST 8 PASS
RUN: AND 0 & 15 (zero)
TEST 9 PASS
RUN: OR 13 | 6
TEST 10 PASS
RUN: OR 0 | 0 (zero)
TEST 11 PASS
RUN: XOR 13 ^ 6
TEST 12 PASS
RUN: XOR 10 ^ 10 (zero)
TEST 13 PASS
RUN: SLT 5 < 10
TEST 14 PASS
RUN: SLT 10 < 5
TEST 15 PASS
RUN: SLT 5 < 5
TEST 16 PASS
RUN: SLT -7 < 2
TEST 17 PASS
RUN: SLT -2 < -6
TEST 18 PASS
==== Directed Tests Done ====
==== Running 30 random tests (Day-2) ====
RUN: RANDOM 0: Op=2 A=0xb B=0xc
TEST 19 PASS
RUN: RANDOM 1: Op=3 A=0xe B=0x0
TEST 20 PASS
RUN: RANDOM 2: Op=5 A=0xe B=0xb
TEST 21 PASS
RUN: RANDOM 3: Op=3 A=0xb B=0x9
TEST 22 PASS
RUN: RANDOM 4: Op=4 A=0x8 B=0x8
TEST 23 PASS
RUN: RANDOM 5: Op=0 A=0x2 B=0x3
TEST 24 PASS
RUN: RANDOM 6: Op=0 A=0xb B=0xb
TEST 25 PASS
RUN: RANDOM 7: Op=3 A=0x0 B=0xd
TEST 26 PASS
RUN: RANDOM 8: Op=4 A=0xe B=0x9
TEST 27 PASS
RUN: RANDOM 9: Op=0 A=0x4 B=0x9
TEST 28 PASS
RUN: RANDOM 10: Op=3 A=0xd B=0x7
TEST 29 PASS
RUN: RANDOM 11: Op=2 A=0x1 B=0xb
TEST 30 PASS
RUN: RANDOM 12: Op=3 A=0x3 B=0x8
TEST 31 PASS
RUN: RANDOM 13: Op=2 A=0xe B=0x9
TEST 32 PASS
RUN: RANDOM 14: Op=2 A=0x2 B=0xd
TEST 33 PASS
RUN: RANDOM 15: Op=1 A=0xd B=0xb
TEST 34 PASS
RUN: RANDOM 16: Op=4 A=0x3 B=0xe
TEST 35 PASS
RUN: RANDOM 17: Op=2 A=0x1 B=0xb
TEST 36 PASS
RUN: RANDOM 18: Op=2 A=0x9 B=0xf
TEST 37 PASS
RUN: RANDOM 19: Op=1 A=0xd B=0x0
TEST 38 PASS
RUN: RANDOM 20: Op=2 A=0xd B=0x9
TEST 39 PASS
RUN: RANDOM 21: Op=1 A=0xb B=0x7
TEST 40 PASS
RUN: RANDOM 22: Op=2 A=0x5 B=0x4
TEST 41 PASS
RUN: RANDOM 23: Op=3 A=0xd B=0x0
TEST 42 PASS
RUN: RANDOM 24: Op=2 A=0x6 B=0x5
TEST 43 PASS
RUN: RANDOM 25: Op=2 A=0x9 B=0x2
TEST 44 PASS
RUN: RANDOM 26: Op=3 A=0x2 B=0x9
TEST 45 PASS
RUN: RANDOM 27: Op=1 A=0x0 B=0x2
TEST 46 PASS
RUN: RANDOM 28: Op=2 A=0xe B=0x4
TEST 47 PASS
RUN: RANDOM 29: Op=0 A=0x1 B=0x5
TEST 48 PASS
==== COVERAGE SUMMARY (Day-2) ====
ADD  (000): 4
SUB  (001): 4
AND  (010): 11
OR   (011): 7
XOR  (100): 3
SLT  (101): 1  (SLT_true=0, SLT_false=1)
Coverage written to coverage_report.csv
==== Tests complete: total=48, errors=0 ====
ALL PASSED
$finish called at time : 107 ns : File "C:/Users/DELL/VLSI_DAY2ALU/VLSI_DAY2ALU.srcs/sim_1/new/ALU_TB.v" Line 228


