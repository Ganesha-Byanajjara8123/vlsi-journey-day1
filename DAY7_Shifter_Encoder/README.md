##DAY-7 — 8-bit Barrel Shifter + Priority Encoder (with Self-Checking Random Testbench)
📌 Project Summary

This module combines two commonly used components in digital design:

8-bit Barrel Shifter

Supports:

Logical Left Shift

Logical Right Shift

Rotate Left

Rotate Right

Mode select: 00 = LSL, 01 = LSR, 10 = ROL, 11 = ROR

8-bit Priority Encoder

Finds the index of the MSB=1 in the shifted output

pe_valid = 1 when shifted output ≠ 0

Both blocks are integrated into a single module, and a self-checking, constrained-random testbench verifies correctness.

📌 Features
Barrel Shifter

Zero-delay, combinational implementation

Continuous assignment using bit slicing

Supports all four standard shift/rotate modes

Priority Encoder

Scans from MSB → LSB (bit 7 to bit 0)

Returns first '1' position

Safe default when no bits are set

pe_valid flag for downstream logic

📌 Testbench Highlights

Fully automated scoreboard

Golden reference functions:

golden_shift()

golden_pe()

Random stimulus for:

Input vector in

Shift amount shamt

Mode selection

$display PASS/FAIL logs

Zero mismatches achieved

##Simulation Result
=== DAY-7 TEST START ===
ALL TESTS PASSED (Day-7 Shift+Encode)
errors = 0

Waveform contains:

Matching shifted and exp_shift

Matching pe_out and exp_pe

Correct pe_valid behavior

No unknown (X) states after reset

##Simulation Waveform

<img width="947" height="276" alt="image" src="https://github.com/user-attachments/assets/d0ed2cd2-dd7c-41e5-9591-d268d6ef0ee8" />
