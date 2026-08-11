# Finite State Machine (FSM) using Verilog HDL

## 1. Project Overview

A Finite State Machine (FSM) is a sequential digital circuit used to model systems that operate through a defined set of states.

In this project, a Finite State Machine is designed and implemented using Verilog HDL. The design demonstrates state transitions based on input conditions and clocked operation.

The project includes:

- FSM state definition
- State transition logic
- Output logic
- Clocked sequential operation
- Reset operation
- RTL simulation
- Self-checking verification
- RTL synthesis

---

## 2. Functional Description

The FSM operates through a predefined sequence of states.

At every active clock edge, the FSM evaluates the current state and input conditions and transitions to the appropriate next state.

The basic FSM operation consists of three main parts:

1. **State Register** – Stores the current state.
2. **Next-State Logic** – Determines the next state based on the current state and inputs.
3. **Output Logic** – Generates the required output based on the FSM state and/or inputs.

The general FSM flow is:

```text
             +----------------+
             |   Next-State   |
       Input |     Logic      |
        ---->|                |
             +-------+--------+
                     |
                     v
             +----------------+
       Clock |  State Register |
        ---->|                |
             +-------+--------+
                     |
                Current State
                     |
                     v
             +----------------+
             |  Output Logic  |
             +-------+--------+
                     |
                     v
                   Output
## 3. 'FSM Operation'
The FSM operates according to the following sequence:
```text
Reset
  |
  v
Initial State
  |
  v
Input Condition
  |
  v
Next-State Logic
  |
  v
State Register
  |
  v
New State
  |
  +----> Output Logic

## 4. RTL Design
The RTL implementation is written in Verilog HDL and is available in:
RTL/Finite_State_Machine.v
```text
The RTL describes the sequential state register and combinational logic required for state transitions and output generation.

## 5. Testbench
The verification testbench is available in:
Testbench/Finite_State_Machine_tb.v
```text
The testbench is used to verify:
Reset behavior
Clock operation
State transitions
Input conditions
Output behavior
Expected FSM operation

## 6. Self-Checking Verification
A self-checking verification result is provided in:
self_checking_Response/FSM_Self_Testing_Response.JPG
```text
The self-checking testbench compares the actual output/state behavior with the expected behavior and helps identify functional mismatches automatically.

## 7. Simulation
The simulation result is available in:
Simulation/Simulation_Result.JPG
```text
The simulation waveform demonstrates the relationship between:
Clock
Reset
Input signals
FSM state
Output signals 

## 8. Synthesis
The synthesized netlist is available in:
Synthesis/Finite_State_Machine_netlist.v
```text
Synthesis converts the Verilog RTL description into a gate-level/netlist representation for further implementation and analysis.

## 9. Project Structure
```text
Finite_State_Machine/
│
├── RTL/
│   └── Finite_State_Machine.v
│
├── Testbench/
│   └── Finite_State_Machine_tb.v
│
├── Simulation/
│   └── Simulation_Result.JPG
│
├── Block_Diagram/
│   └── FSM_Block_Diagram.JPG
│
├── Synthesis/
│   └── Finite_State_Machine_netlist.v
│
├── self_checking_Response/
│   └── FSM_Self_Testing_Response.JPG
│
└── README.md