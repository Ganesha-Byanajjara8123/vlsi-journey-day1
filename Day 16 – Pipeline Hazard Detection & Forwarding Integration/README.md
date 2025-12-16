## Day 16 – Pipeline Hazard Detection & Forwarding Integration

Implemented full pipeline control logic including:
- Load-use hazard detection
- PC stall and IF/ID write control
- ID/EX flush insertion
- EX/MEM and MEM/WB forwarding paths

The design correctly activates control signals only when hazards
are present, demonstrating architecturally correct pipeline behavior.

“Day-16 focuses on integrating hazard detection and forwarding logic.
In my test program, no true RAW hazards occur, so forwarding and stall
signals remain inactive. This confirms correct control behavior —
hazards are handled when required, not forced.”

#Waveform
<img width="1519" height="561" alt="DAY16" src="https://github.com/user-attachments/assets/40bdca77-032f-4027-8f28-162e23d1348b" />

