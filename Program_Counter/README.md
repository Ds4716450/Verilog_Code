# Program Counter (PC)

## Overview

A Program Counter (PC) is a sequential digital circuit used in a processor to store the address of the next instruction to be executed.

## Function

The Program Counter:

- Stores the current instruction address.
- Increments to point to the next instruction.
- Can be loaded with a new address during jump/branch operations.
- Updates on the active clock edge.
- Can be reset to a known value.

## RTL Design

The Program Counter is implemented using Verilog HDL.

### Main Signals

| Signal | Direction | Description |
|--------|-----------|-------------|
| clk | Input | Clock signal |
| reset | Input | Reset signal |
| pc_next | Input | Next PC value |
| pc | Output | Current program counter value |

## Files

- `Program_Counter.v` - RTL design
- `Program_Counter_tb.v` - Testbench
- `Program_Counter.JPG` - Block diagram
- `README.md` - Project documentation

## Simulation

Example using Icarus Verilog:

```bash
iverilog -o sim Program_Counter.v Program_Counter_tb.v
vvp sim
