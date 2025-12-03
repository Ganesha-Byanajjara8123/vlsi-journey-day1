DAY-4 — Pipelined ALU (1-Cycle Latency + Valid Handshake + Scoreboard Verification)
🔥 Overview

In Day-4, we upgraded the ALU from a simple combinational design (Day1–Day3) into a synchronous, pipelined ALU with one-cycle latency.
This matches how real hardware works inside CPUs, DSPs and accelerator datapaths.

Key upgrades:

Added clk, rst_n, in_valid, out_valid

Outputs update one cycle after inputs arrive

Added Carry and Overflow flags in a registered stage

Built a latency-aware scoreboard (essential in real verification/UVM)

Achieved 100% PASS on directed + random tests

🧠 What I Learned (Core Concepts)
✔ 1. Why pipelining is required

Real hardware cannot be purely combinational for everything.
Long combinational paths → timing failures → low frequency.
Pipeline registers break the logic into stages.

✔ 2. 1-cycle pipeline latency

Inputs at cycle N produce outputs at cycle N+1.
So the testbench cannot compare results in the same cycle.

✔ 3. Valid handshake

in_valid=1 → inputs are meaningful

out_valid=1 → output belongs to previous input
This is extremely common in AXI-Stream, DSP blocks, ALUs, NoCs, FIFOs, etc.

✔ 4. Scoreboard with expected-value delay

We compute an expected result for each input and store it.
Next cycle, when out_valid=1, we compare DUT vs expected.

##WAVEFORM SCREENSHOTS
<img width="1892" height="912" alt="DAY4 1 (2)" src="https://github.com/user-attachments/assets/679a3b81-7dbc-4354-b773-b8bc4898ddf5" />
<img width="1889" height="583" alt="DAY4 1 (1)" src="https://github.com/user-attachments/assets/9a97f190-7778-4f5d-88d8-d764de9b1705" />

##Tcl consol
<img width="718" height="847" alt="DAY4TCL" src="https://github.com/user-attachments/assets/45a660fa-4022-425b-a44f-e77bbdc4ade9" />
<img width="1451" height="607" alt="DAY-4Tcl" src="https://github.com/user-attachments/assets/02a0a75a-e006-4c6e-9331-db201972d9f7" />


