##**DAY-15: Pipeline Hazard Detection & Data Forwarding (RTL)**
Objective

Implement and verify pipeline control mechanisms required for a real CPU:

Load-use hazard detection

Pipeline stall & flush control

EX/MEM and MEM/WB data forwarding

This day focuses on correctness of control, not ISA completeness.

Implemented Blocks
✅ Instruction Fetch (IF)

Program Counter update controlled by pc_write

PC stalls correctly during load-use hazards

✅ IF/ID Pipeline Register

Write enable controlled by if_id_write

Holds state during stalls

✅ ID/EX Pipeline Register

Supports flush on hazard detection

Prevents incorrect instruction propagation

✅ Hazard Detection Unit

Detects load-use hazards using:

id_ex_memread

id_ex_rd

if_id_rs1 / if_id_rs2

Generates:

pc_write

if_id_write

id_ex_flush

✅ Forwarding Unit

Resolves data hazards using:

EX/MEM forwarding

MEM/WB forwarding

Outputs:

forwardA

forwardB

✅ EX Stage (ALU)

Uses forwarded operands via mux selection

Correct execution without pipeline stalls

Verified Behavior (Simulation)

PC stalls correctly on hazards

IF/ID register holds during stall

ID/EX flushed on load-use hazard

Forwarding paths activate when required

No uncontrolled X-propagation in datapath

#Waveform
<img width="938" height="267" alt="DAY15-veryhard" src="https://github.com/user-attachments/assets/d9991656-709d-4595-96d9-287cb30cabf8" />

