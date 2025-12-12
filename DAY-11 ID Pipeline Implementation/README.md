DAY-11 — IF → IF/ID → ID Pipeline Implementation

This day marks the transition from isolated verification tasks to actual CPU microarchitecture.
I implemented the first part of a pipelined processor:

IF Stage (Instruction Fetch)

IF/ID Pipeline Register

ID Stage (Instruction Decode)

This builds the foundation for a real pipelined CPU.

🔧 Modules Implemented
1️⃣ instr_mem.v

A 20-bit instruction memory

[19:16] → opcode  
[15:8]  → operand A  
[7:0]   → operand B


Pre-loaded with 8 ALU-style instructions.

2️⃣ if_stage.v

Maintains program counter (PC)

Fetches instruction from memory

Handles stalls (pipeline freeze)

3️⃣ pipe_if_id.v

Classic pipeline register:

Introduces one-cycle delay

Transfers PC and instruction to ID stage

Clears on reset

Freezes on stall

4️⃣ id_stage.v

Decodes 20-bit IR into:

opcode

operand A

operand B

Latches the instruction for stable decode

🚦 Pipeline Timing Validation

PC increments correctly:
00 → 01 → 02 → …

Instruction flow is smooth:
instr → instr_id with exactly one cycle delay.

Decoded outputs match expected A/B/opcode values.

✔ No X
✔ No Z
✔ No hazards
✔ Clean waveform
✔ Fully functional 2-stage pipeline

📷 Waveform Summary

PC correctly increments

IF/ID register delays values by one cycle

ID stage produces valid opcode/A/B for every instruction

(You will add your waveform image here)

🧠 What I Learned

How real CPUs fetch & decode instructions

How pipeline registers work in HDL

Why decoding must use registered instruction, not combinational input

Clean pipeline timing discipline

Basics of microarchitecture design



#Waveform image

<img width="951" height="262" alt="image" src="https://github.com/user-attachments/assets/addaccf8-9389-401a-90e3-3f6ba3491d27" />

