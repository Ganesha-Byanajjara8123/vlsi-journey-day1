
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



Shifts and rotates use only B[1:0] to determine amount (0–3).

Status Flags
Flag	Meaning
Zero	Result = 0
Neg	Most significant bit = 1 (signed negative)
Parity	XOR reduction → 1 means odd number of 1s

These flags are essential in processor design (branch conditions, error detection, etc).



##How to Simulate (Vivado)

Create new project

Add files:

ALU_Day5.v

ALU_Day5_TB.v

Set ALU_Day5_TB.v as top module

Run simulation → You should see:

==== TEST COMPLETE. Errors=0 ====

##**Waveform Snapshot**:

<img width="1889" height="565" alt="Screenshot 2025-12-05 224946" src="https://github.com/user-attachments/assets/6c64eeac-4511-4a53-96fb-74700b0d4fe8" />

