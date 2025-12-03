
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


##**Tcl console output**

==== ALU Day-3 Tests Start ====
RUN: ADD 5+3
TEST 1 PASS
RUN: ADD 10+5
TEST 2 PASS
RUN: ADD 15+1 (overflow unsigned)
TEST 3 PASS
RUN: ADD 7+8
TEST 4 PASS
RUN: SUB 10-3
TEST 5 PASS
RUN: SUB 5-5 (zero)
TEST 6 PASS
RUN: SUB 3-10 (neg)
TEST 7 PASS
RUN: AND 13 & 7
TEST 8 PASS
RUN: AND 0 & 15 (zero)
TEST 9 PASS
RUN: OR 13 | 6
TEST 10 PASS
RUN: OR 0 | 0 (zero)
TEST 11 PASS
RUN: XOR 13 ^ 6
TEST 12 PASS
RUN: XOR 10 ^ 10 (zero)
TEST 13 PASS
RUN: SLT 5 < 10
TEST 14 PASS
RUN: SLT 10 < 5
TEST 15 PASS
RUN: SLT 5 < 5
TEST 16 PASS
RUN: SLT -7 < 2
TEST 17 PASS
RUN: SLT -2 < -6
TEST 18 PASS
==== Directed Tests Done ====
==== Running 50 random tests (Day-3) ====
RUN: RANDOM 0: Op=5 A=0x4 B=0x1
TEST 19 PASS
RUN: RANDOM 1: Op=5 A=0x3 B=0xd
TEST 20 PASS
RUN: RANDOM 2: Op=3 A=0x5 B=0x2
TEST 21 PASS
RUN: RANDOM 3: Op=5 A=0xd B=0x6
TEST 22 PASS
RUN: RANDOM 4: Op=1 A=0xd B=0xc
TEST 23 PASS
RUN: RANDOM 5: Op=4 A=0x6 B=0x5
TEST 24 PASS
RUN: RANDOM 6: Op=6 A=0x5 B=0x7
TEST 25 PASS
RUN: RANDOM 7: Op=4 A=0xf B=0x2
TEST 26 PASS
RUN: RANDOM 8: Op=2 A=0x8 B=0x5
TEST 27 PASS
RUN: RANDOM 9: Op=5 A=0xd B=0xd
TEST 28 PASS
RUN: RANDOM 10: Op=6 A=0x3 B=0xa
TEST 29 PASS
RUN: RANDOM 11: Op=7 A=0x0 B=0xa
TEST 30 PASS
RUN: RANDOM 12: Op=5 A=0x6 B=0x3
TEST 31 PASS
RUN: RANDOM 13: Op=5 A=0x3 B=0xb
TEST 32 PASS
RUN: RANDOM 14: Op=3 A=0x2 B=0xe
TEST 33 PASS
RUN: RANDOM 15: Op=2 A=0xf B=0x3
TEST 34 PASS
RUN: RANDOM 16: Op=2 A=0xa B=0xc
TEST 35 PASS
RUN: RANDOM 17: Op=4 A=0xa B=0x1
TEST 36 PASS
RUN: RANDOM 18: Op=1 A=0x8 B=0x9
TEST 37 PASS
RUN: RANDOM 19: Op=4 A=0x6 B=0x6
TEST 38 PASS
RUN: RANDOM 20: Op=7 A=0xc B=0xa
TEST 39 PASS
RUN: RANDOM 21: Op=1 A=0x1 B=0x5
TEST 40 PASS
RUN: RANDOM 22: Op=4 A=0xb B=0xa
TEST 41 PASS
RUN: RANDOM 23: Op=1 A=0x5 B=0x1
TEST 42 PASS
RUN: RANDOM 24: Op=1 A=0x2 B=0xc
TEST 43 PASS
RUN: RANDOM 25: Op=5 A=0xf B=0x8
TEST 44 PASS
RUN: RANDOM 26: Op=3 A=0xf B=0xc
TEST 45 PASS
RUN: RANDOM 27: Op=4 A=0x9 B=0x9
TEST 46 PASS
RUN: RANDOM 28: Op=2 A=0x7 B=0x1
TEST 47 PASS
RUN: RANDOM 29: Op=0 A=0xc B=0x2
TEST 48 PASS
RUN: RANDOM 30: Op=0 A=0x7 B=0xd
TEST 49 PASS
RUN: RANDOM 31: Op=5 A=0xe B=0xd
TEST 50 PASS
RUN: RANDOM 32: Op=1 A=0xf B=0x3
TEST 51 PASS
RUN: RANDOM 33: Op=5 A=0x8 B=0xb
TEST 52 PASS
RUN: RANDOM 34: Op=0 A=0xf B=0xa
TEST 53 PASS
RUN: RANDOM 35: Op=4 A=0x6 B=0xe
TEST 54 PASS
RUN: RANDOM 36: Op=3 A=0xa B=0x6
TEST 55 PASS
RUN: RANDOM 37: Op=3 A=0x3 B=0xf
TEST 56 PASS
RUN: RANDOM 38: Op=1 A=0xf B=0x4
TEST 57 PASS
RUN: RANDOM 39: Op=4 A=0xb B=0x6
TEST 58 PASS
RUN: RANDOM 40: Op=0 A=0x9 B=0xd
TEST 59 PASS
RUN: RANDOM 41: Op=3 A=0x5 B=0x5
TEST 60 PASS
RUN: RANDOM 42: Op=0 A=0x9 B=0x4
TEST 61 PASS
RUN: RANDOM 43: Op=0 A=0xa B=0xb
TEST 62 PASS
RUN: RANDOM 44: Op=5 A=0xc B=0xa
TEST 63 PASS
RUN: RANDOM 45: Op=0 A=0x3 B=0x6
TEST 64 PASS
RUN: RANDOM 46: Op=2 A=0x7 B=0xa
TEST 65 PASS
RUN: RANDOM 47: Op=0 A=0x8 B=0x9
TEST 66 PASS
RUN: RANDOM 48: Op=0 A=0x4 B=0x3
TEST 67 PASS
RUN: RANDOM 49: Op=7 A=0x9 B=0xb
TEST 68 PASS
==== COVERAGE SUMMARY (Day-3) ====
ADD  (000): 9
SUB  (001): 7
AND  (010): 5
OR   (011): 6
XOR  (100): 8
SLT  (101): 10  (SLT_true=2, SLT_false=8)
CARRY asserted   : 8 times
OVERFLOW asserted: 4 times
Coverage written to coverage_report.csv
==== Tests complete: total=68, errors=0 ====
ALL TESTS PASSED
