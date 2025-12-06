##**DAY-6 — Multicycle ALU (Start/Busy/Valid Handshake)

Project Documentation**

Overview

This module implements a multicycle ALU that processes one operation over multiple clock cycles rather than completing in a single cycle.
This helps model real-world ALUs inside CPUs, DSP blocks, and hardware accelerators where:

Some ops take multiple cycles

Handshake signals coordinate data flow

The ALU interacts with upstream and downstream pipeline stages

This project introduces FSM-based operation, valid/ready handshake, and busy signaling.

Supported operations
Opcode	Operation	Notes
000	ADD	multi-cycle compute
001	SUB	multi-cycle compute
010	AND	1-cycle
011	OR	1-cycle
100	XOR	1-cycle
101	SLT	signed comparison
110	MUL	multi-cycle “shift-add”
111	RESERVED	used for testing
Handshake signals
Signal	Direction	Meaning
in_valid	Input	Drives new operation request
in_ready	Output	ALU is ready to accept new work
busy	Output	ALU is computing (stalling new ops)
out_valid	Output	Result is ready
Result	Output	8-bit computed result
Design Architecture

The ALU uses a Finite State Machine (FSM):

States

IDLE

ALU is ready

Waits for in_valid & in_ready

EXEC

ALU computes for 2–10 cycles depending on opcode

busy = 1

DONE

Output is valid for one cycle

Returns to IDLE

This models real CPU ALUs used in:

In-order processors

DSP blocks

Multicycle arithmetic units

Testbench Features

✔ Directed tests
✔ 20+ random tests with handshake timing
✔ Automatic scoreboard
✔ Cycle-accurate checking
✔ Busy-validation checking
✔ Latency validation for MUL & ADD/SUB



##**Waveform verification**

<img width="1898" height="636" alt="DAY6" src="https://github.com/user-attachments/assets/727ae5ef-52d4-4c83-be8c-689e63e2a95f" />

<img width="991" height="525" alt="DAY6Tcl" src="https://github.com/user-attachments/assets/30ecd3af-3548-49f7-b0a3-a4c8fe2405e7" />



busy correctly asserted during multi-cycle phases

in_ready de-asserts when ALU is busy

out_valid pulses only when result matches

No X/Z states except during reset
