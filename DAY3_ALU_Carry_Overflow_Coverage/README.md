# DAY 3 — ALU with Carry, Overflow, and Functional Coverage

## What I learned
- The difference between carry-out (unsigned) & overflow (signed)
- How to compute signed overflow logic
- How to extend the ALU without breaking existing functionality
- How to build functional coverage in a pure Verilog testbench
- How to export coverage metrics (CSV)

## New Features Added
- Carry flag
- Overflow flag
- Extended coverage tracking (carry, overflow, SLT)
- 50 random tests for better stimulus spread

## Results
- 0 failures out of 68 tests
- Coverage exported to `coverage_report.csv`

#Waveform images
<img width="1907" height="910" alt="Screenshot 2025-12-02 230203" src="https://github.com/user-attachments/assets/daa227b4-0d64-424e-b957-5f62e4bb7921" />
<img width="1849" height="429" alt="Screenshot 2025-12-02 230246" src="https://github.com/user-attachments/assets/1418d9d4-9813-48c1-84b3-c753bc636198" />


