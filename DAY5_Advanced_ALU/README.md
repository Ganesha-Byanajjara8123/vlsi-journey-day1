
##**DAY-5 — Advanced ALU (Shifts, Rotates, Flags)** — Project Documentation
Overview

Day-5 extends the ALU from previous days into a feature-rich CPU-style ALU supporting:

Arithmetic

Logical operations

Comparison (SLT)

Shift operations (SLL, SRL, SRA)

Rotate operations (ROL, ROR)

Status flags (Zero, Negative, Parity)

Full self-checking testbench with random testing

This version resembles what real RISC architectures use in pipeline execute stages.

Supported Operations
Opcode (hex)	Operation	Description
0	ADD	A + B
1	SUB	A - B
2	AND	A & B
3	OR	`A
4	XOR	A ^ B
5	SLT	Set-Less-Than (signed compare)
6	SHIFT, ROT	Funct selects:
00 = SLL
01 = SRL
10 = SRA
11 = ROL
7	SHIFT, ROT	Same structure but using rotates and arithmetic shifts

Shifts and rotates use only B[1:0] to determine amount (0–3).

Status Flags
Flag	Meaning
Zero	Result = 0
Neg	Most significant bit = 1 (signed negative)
Parity	XOR reduction → 1 means odd number of 1s

These flags are essential in processor design (branch conditions, error detection, etc).



How to Simulate (Vivado)

Create new project

Add files:

ALU_Day5.v

ALU_Day5_TB.v

Set ALU_Day5_TB.v as top module

Run simulation → You should see:

==== TEST COMPLETE. Errors=0 ====

##**Waveform Snapshot**:

<img width="1889" height="565" alt="Screenshot 2025-12-05 224946" src="https://github.com/user-attachments/assets/6c64eeac-4511-4a53-96fb-74700b0d4fe8" />

