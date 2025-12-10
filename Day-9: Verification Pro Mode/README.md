# DAY-9 — Verification Pro: Randomized TB + Scoreboard + Coverage

This step upgrades the datapath to a professionally verified component.

Features:
- Self-checking randomized testbench (NUM_TESTS configurable)
- Golden reference model for result and flags
- Scoreboard that reports result & flag mismatches
- Coverage counters for opcode distribution, SLT truth cases, carry/overflow events
- CSV report generation: `day9_coverage_report.csv`

Run instructions:
1. Add `datapath_core.v` and `datapath_core_verif_TB.v` to Vivado simulation sources.
2. Run behavioral simulation.
3. Examine console for `ALL TESTS PASSED` and open waveform for inspection.


 ##waveform
 #For 2000 test
 <img width="1872" height="733" alt="DAY9 1" src="https://github.com/user-attachments/assets/8e0e394f-cd4f-4041-a65e-38264271e928" />

 #For 10 test
 <img width="1912" height="857" alt="DAY9" src="https://github.com/user-attachments/assets/24f7266c-c667-49b2-a12b-ac34451209fa" />



 

