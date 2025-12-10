# Day 10 — top_cpu verification

## Summary
This folder contains the verification artifacts for **Day-10**: a small CPU/top module (`top_cpu`) and a self-checking testbench used to validate the datapath + flags (zero, negative, carry, overflow). The testbench runs directed tests followed by randomized checks and compares DUT outputs to a golden model.

All tests passed in Vivado XSim (1,000 ns run).

## Files
- `rtl/top_cpu.v` — top-level CPU / datapath module used in these tests.
- `sim/top_cpu_tb.v` — self-checking Verilog testbench. It:
  - drives operands, then instruction,
  - waits deterministic cycles,
  - computes a golden model internally,
  - prints PASS/FAIL per test.
- `docs/waveform_day10.png` — waveform snapshot (cropped) showing reset, inputs, and outputs.

## How to run (Vivado)
1. Create a Vivado project and add `rtl/top_cpu.v` to sources.  
2. Add `sim/top_cpu_tb.v` to simulation sources.  
3. Launch simulation (Run → Simulate Behavioral Model).  
4. Observe messages in Tcl console. A clean run prints:
5. Save a cropped waveform image to `docs/waveform_day10.png` and commit.

## Notes / Design checks
- Reset sequence is required: testbench asserts reset at time 0 and releases it before issuing tests.  
- Instruction timing: operands are applied, then `instr` is asserted; wait two cycles to let the CPU compute.  
- Golden model in the TB includes add/sub/and/or/xor/slt/shift operations and flag calculations (carry and signed overflow).

## Next steps
- Add small micro-instruction tests to validate control FSM on edge cases.  
- Write a tiny README blurb for LinkedIn showing your progress (examples in repo root).



#waveform image
<img width="953" height="328" alt="image" src="https://github.com/user-attachments/assets/85ccd87d-c2af-47d4-a54f-fc05ae98fbcf" />

#TCL CONSOLE OUTPUT 
<img width="440" height="350" alt="image" src="https://github.com/user-attachments/assets/6b910772-4d68-4b77-9b00-92d140cc6d5f" />


