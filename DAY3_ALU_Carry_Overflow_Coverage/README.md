
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


##**WAVEFORM SCREENSHOTS**
<img width="1907" height="910" alt="DAY3overflow-carry" src="https://github.com/user-attachments/assets/708263c6-78ba-4fbc-bf19-df8d1002ecfc" />
<img width="1849" height="422" alt="DAY3-pverflow-carry" src="https://github.com/user-attachments/assets/0507b796-b264-4678-b5cc-3a530ee8dc19" />



