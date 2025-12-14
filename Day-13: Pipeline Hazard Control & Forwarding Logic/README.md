Day-13: Pipeline Hazard Control & Forwarding Logic
📌 Objective

Integrate hazard detection and data forwarding logic into the pipelined datapath to prepare the CPU for true back-to-back instruction execution without stalls.

This stage focuses on architectural correctness, not full functional forwarding (which requires register file + writeback in later stages).

🧠 What Was Implemented

✔ Forwarding Unit

Detects EX/MEM and MEM/WB data hazards

Generates forwardA and forwardB control signals

Ready to mux ALU operands from later pipeline stages

✔ Hazard Detection Unit

Detects load-use hazards

Generates:

stall

if_id_write

id_ex_flush

✔ Pipeline Control Integration

Forwarding and hazard units connected into top_day13

Pipeline flow verified using waveform inspection

No unintended stalls or deadlocks

📊 Verification Status

Simulation completed successfully

PC progression and ALU outputs verified

Forwarding logic remains idle (expected) due to absence of register file & writeback stage

Structural correctness confirmed

#Waveform
<img width="1919" height="460" alt="Screenshot 2025-12-14 092737" src="https://github.com/user-attachments/assets/384cd01b-05a7-49bb-aaa5-c415477892fd" />

