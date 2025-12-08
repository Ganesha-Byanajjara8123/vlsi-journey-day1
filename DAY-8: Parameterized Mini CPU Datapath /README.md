# DAY-8: Parameterized Mini CPU Datapath (8/16/32-bit)

This module introduces scalable hardware design using Verilog parameters.
The datapath integrates:
- ALU (ADD, SUB, AND, OR, XOR, SLT)
- Shifter (SLL, SRL)
- Flag Unit (Zero, Negative, Carry, Overflow)

## Key Learning Outcomes
- Designing reusable RTL using parameters (`WIDTH=8/16/32`)
- Creating modular datapath components
- Combining ALU + Shifter + Flags using opcode-based selection
- Understanding signed/unsigned arithmetic behavior
- Building an architecture aligned with real-world CPU datapaths

## Files Included
- `datapath_core.v`  → Parameterized datapath RTL
- `datapath_core_TB.v` → Basic directed testbench

## Simulation Result
All directed tests passed:
- ADD, SUB, AND, OR, XOR
- SLT (signed compare)
- SLL and SRL (shift left/right logical)

Waveform confirms correct result selection and flag behavior.

## Next Step
Day-9 will introduce:
- Scoreboard
- Constrained random testing
- Functional coverage
- Automated pass/fail reporting

This transforms the datapath into a fully verified component.

##Waveforms 

<img width="934" height="278" alt="image" src="https://github.com/user-attachments/assets/64de3a46-26b3-499e-9d63-bbf170fc3d7d" />


