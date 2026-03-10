# RISC-V Pipelined Processor

A Verilog-based implementation of a RISC-V processor featuring both a **sequential (single-cycle)** design and a **5-stage pipelined** design, developed for educational purposes in Computer Architecture.

---

## 📁 Repository Structure

```
RISCV_Pipelined-Processor/
├── Sequential/        # Single-cycle RISC-V processor implementation
└── Pipelined/         # 5-stage pipelined RISC-V processor implementation
```

---

## 🏗️ Architecture Overview

### Sequential (Single-Cycle) Processor
The `Sequential` directory contains a non-pipelined, single-cycle implementation of the RISC-V processor. Every instruction completes within a single clock cycle, making it straightforward to understand but limited in performance.

### Pipelined Processor
The `Pipelined` directory contains a 5-stage pipelined implementation of the RISC-V processor. The classic five stages are:

| Stage | Name | Description |
|-------|------|-------------|
| IF | Instruction Fetch | Fetches the instruction from instruction memory |
| ID | Instruction Decode | Decodes the instruction and reads register values |
| EX | Execute | Performs ALU operations |
| MEM | Memory Access | Reads from or writes to data memory |
| WB | Write Back | Writes results back to the register file |

The pipelined design improves throughput by overlapping the execution of multiple instructions across the five stages.

---

## ⚙️ Features

- Implements the **RV32I** base integer instruction set
- Supports R-type, I-type, S-type, B-type, U-type, and J-type instructions
- **Sequential version**: Simple, easy-to-follow single-cycle datapath
- **Pipelined version**:
  - 5-stage pipeline (IF → ID → EX → MEM → WB)
  - Pipeline registers between each stage
  - Hazard handling (data/control hazards)

---

## 🛠️ Tools & Requirements

- **HDL Language**: Verilog
- **Simulator**: [ModelSim](https://www.intel.com/content/www/us/en/software/programmable/quartus-prime/model-sim.html) or any Verilog-compatible simulator (e.g., [Icarus Verilog](http://iverilog.icarus.com/), [EDA Playground](https://www.edaplayground.com/))

---

## 🚀 Getting Started

### Using ModelSim

1. Clone the repository:
   ```bash
   git clone https://github.com/DevangBordoloi/RISCV_Pipelined-Processor.git
   cd RISCV_Pipelined-Processor
   ```

2. Open **ModelSim** and set the working directory to either `Sequential/` or `Pipelined/`:
   ```tcl
   cd /path/to/RISCV_Pipelined-Processor/Pipelined
   ```

3. Compile all Verilog source files:
   ```tcl
   vlog *.v
   ```

4. Run the simulation using the testbench:
   ```tcl
   vsim tb_top
   run -all
   ```

5. View waveforms in the Wave window to inspect signal behavior across pipeline stages.

### Using Icarus Verilog (iverilog)

```bash
# Navigate to the desired implementation
cd Pipelined

# Compile
iverilog -o sim *.v

# Run
vvp sim
```

---

## 📌 Supported Instructions (RV32I Subset)

| Type | Instructions |
|------|-------------|
| **R-Type** | `ADD`, `SUB`, `AND`, `OR`, `XOR`, `SLL`, `SRL`, `SRA`, `SLT`, `SLTU` |
| **I-Type** | `ADDI`, `ANDI`, `ORI`, `XORI`, `SLTI`, `SLTIU`, `SLLI`, `SRLI`, `SRAI`, `LW` |
| **S-Type** | `SW` |
| **B-Type** | `BEQ`, `BNE`, `BLT`, `BGE`, `BLTU`, `BGEU` |
| **U-Type** | `LUI`, `AUIPC` |
| **J-Type** | `JAL`, `JALR` |

---

## 📚 Background

This project demonstrates the fundamental concepts of processor design:

- **Datapath** construction and control signal generation
- **Register file**, ALU, immediate generation, and memory units
- **Pipeline hazards**: structural, data, and control hazards
- **Forwarding** and **stalling** mechanisms to resolve data hazards
- **Branch resolution** and pipeline flushing for control hazards

---

## 🧑‍💻 Author

**Devang Bordoloi**
- GitHub: [@DevangBordoloi](https://github.com/DevangBordoloi)

---

## 📄 License

This project is open-source. Feel free to use and build upon it for educational purposes.
