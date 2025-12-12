# Day 12 — Full IF → ID → EX Pipeline Integration (3-Stage CPU Mini-Datapath)

This day extends the previous Day-11 pipeline by connecting all three stages
into a complete datapath:

**IF Stage**
- Program Counter (PC)
- Instruction memory fetch
- Outputs `instr_if`

**IF/ID Pipeline Register**
- Holds PC and instruction for one clock
- Ensures clean stage separation

**ID Stage (Decoder)**
- Splits instruction into:
  - `opcode`
  - operand A (8-bit)
  - operand B (8-bit)
- Outputs `opcode_id`, `A_id`, `B_id`

**ID/EX Pipeline Register**
- Buffers decoded values into execute stage

**EX Stage (ALU)**
- Performs arithmetic/logical operations:
  - ADD, SUB, AND, OR, XOR, SLT, SLL, SRL
- Output: `alu_out`

---

## 📁 Files Included

### RTL
- `instr_mem.v` — simple ROM with sample instructions  
- `if_stage.v` — PC + instruction fetch  
- `pipe_if_id.v` — IF → ID pipeline register  
- `id_stage.v` — opcode / operand decoder  
- `pipe_id_ex.v` — ID → EX pipeline register  
- `alu.v` — 8-bit ALU used in EX stage  
- `top_day12.v` — full 3-stage datapath integration  

### Testbench
- `top_day12_tb.v` — drives reset/clock, observes pipeline timing  

### Waveforms (without ZOOM from00ns - 420ns)
<img width="947" height="322" alt="image" src="https://github.com/user-attachments/assets/f36b7b8f-4df1-45a8-8b53-4e791d4bd405" />


 — pipeline behavior visualized

 
###(WITH ZOOM from 00ns - 150ns)
<img width="940" height="380" alt="DAY12 1" src="https://github.com/user-attachments/assets/7267b771-ed4b-45f7-b5a0-71c5f70edaeb" />


## 🧪 Simulation Behavior (Expected)

1. **PC increments** every cycle after reset  
2. IF stage fetches instructions from ROM  
3. IF/ID register holds instruction one cycle  
4. ID decoder extracts:
   - opcode  
   - src A  
   - src B  
5. ID/EX register delays these values properly  
6. ALU computes result using the decoded operands  
7. Final `alu_out` matches the expected arithmetic/logic operation  

Pipeline advances one instruction per cycle after initial fill (classic 3-stage flow).

---

## ▶ How to Run (Vivado)

1. Add `rtl/` and `tb/` sources to project  
2. Set **top_day12_tb** as simulation top  
3. Run Behavioral Simulation  
4. Add signals:
   - `pc`, `instr_if`, `instr_id`, `opcode_id`, `opcode_ex`,  
     `A_id`, `B_id`, `A_ex`, `B_ex`, `alu_out`
5. Observe clean stage-by-stage propagation and correct ALU result

---

## ✔ Summary

Day-12 completes a functioning **pipelined datapath**:
- Instruction fetch  
- Decode  
- Execution via ALU  
- Stage-register separation  
- Fully synthesizable modules  

This is now a real CPU-like datapath — not just isolated modules.


