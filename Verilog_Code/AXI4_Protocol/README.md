# AXI4 Slave RTL Design and Verification

## Overview

This project implements and verifies a simplified AXI4 Slave interface using Verilog/SystemVerilog.

The design includes AXI read and write transactions with burst support and a memory-based slave.

The project was developed to understand AXI4 protocol handshaking, burst transactions, byte-enable writes, backpressure, and RTL-level verification.

---

## Features

- AXI4 Write Address Channel
- AXI4 Write Data Channel
- AXI4 Write Response Channel
- AXI4 Read Address Channel
- AXI4 Read Data Channel
- VALID/READY handshake mechanism
- FIXED burst
- INCR burst
- WRAP burst
- WSTRB byte-level write enable
- WLAST handling
- RLAST handling
- Read backpressure using RREADY
- Write response backpressure using BREADY
- Memory-based read/write operation
- Self-checking testbench
- Waveform-based debugging

---

## AXI4 Channel Structure

### Write Transaction

The AXI write transaction consists of three channels:

```text
AW (Write Address)
        ↓
W  (Write Data)
        ↓
B  (Write Response)

#Read Transaction
The AXI read transaction consists of two channels:
AR (Read Address)
        ↓
R  (Read Data)

A transfer occurs when both VALID and READY are asserted:
VALID && READY = Transfer

##Burst Types
#FIXED Burst
The address remains unchanged for every beat.
Address → 4
          4
          4
          4
FIXED bursts are useful for repeated accesses to the same address

#INCR Burst
The address increments after each beat.
For a 32-bit data bus:
Beat 0 → Address 0
Beat 1 → Address 4
Beat 2 → Address 8
Beat 3 → Address 12

#WRAP Burst
The address increments and then wraps back to the beginning of the defined wrap region.
Starting address = 4
Burst length     = 4 beats
Bytes per beat   = 4

Addresses:

4 → 8 → 12 → 0

#WSTRB Support
The design supports byte-level write enables using WSTRB.
For a 32-bit data bus:
WSTRB[0] → DATA[7:0]
WSTRB[1] → DATA[15:8]
WSTRB[2] → DATA[23:16]
WSTRB[3] → DATA[31:24]
A WSTRB bit of 1 updates the corresponding byte, while 0 preserves the previous byte.
Previous memory = AAAABBBB
WDATA           = 11223344
WSTRB           = 0001

Result          = AAAABB44

##Backpressure Verification
The testbench also verifies AXI backpressure behavior.

#Read Channel
When:
RVALID = 1
RREADY = 0
the slave keeps the read data available until the master becomes ready.

#Write Response
When:
BVALID = 1
BREADY = 0
the slave keeps the response asserted until the master accepts it.

##Project Structure
AXI4/
│
├── README.md
│
├── rtl/
│   └── axi4_slave_independent.v
│
├── tb/
│   └── axi4_slave_tv.v
│
└── simulation/
    ├── AXI Complete Data flow.JPG
    ├── AXI Read Data Sequences.JPG
    ├── AXI Wire Data Sequence.JPG
    └── simulation result.JPG

##Verification
The testbench performs checks for:

Write response (BRESP)
Memory contents after write transactions
Burst address behavior
WSTRB byte-level updates
Read data
Read burst sequence
RLAST on the final read beat
Read backpressure
Write response backpressure

Example expected WRAP write:
MEM[4]  = AAAABB44
MEM[8]  = CCCC77DD
MEM[12] = EEAAFFFF
MEM[0]  = DD345678
The corresponding read transaction returns the same values in burst order.

 the AXI4 project. This will make your GitHub project much more professional and explain what you actually implemented.

Your current structure is:

AXI4
├── rtl
│   └── axi4_slave_independent.v
├── simulation
│   ├── AXI Complete Data flow.JPG
│   ├── AXI Read Data Sequences.JPG
│   ├── AXI Wire Data Sequence.JPG
│   └── simulation result.JPG
└── tb
    └── axi4_slave_tv.v

I suggest:

AXI4
├── README.md
├── rtl
│   └── axi4_slave_independent.v
├── simulation
│   ├── AXI Complete Data flow.JPG
│   ├── AXI Read Data Sequences.JPG
│   ├── AXI Wire Data Sequence.JPG
│   └── simulation result.JPG
└── tb
    └── axi4_slave_tv.v
README.md content

Use this:

# AXI4 Slave RTL Design and Verification

## Overview

This project implements and verifies a simplified AXI4 Slave interface using Verilog/SystemVerilog.

The design includes AXI read and write transactions with burst support and a memory-based slave.

The project was developed to understand AXI4 protocol handshaking, burst transactions, byte-enable writes, backpressure, and RTL-level verification.

---

## Features

- AXI4 Write Address Channel
- AXI4 Write Data Channel
- AXI4 Write Response Channel
- AXI4 Read Address Channel
- AXI4 Read Data Channel
- VALID/READY handshake mechanism
- FIXED burst
- INCR burst
- WRAP burst
- WSTRB byte-level write enable
- WLAST handling
- RLAST handling
- Read backpressure using RREADY
- Write response backpressure using BREADY
- Memory-based read/write operation
- Self-checking testbench
- Waveform-based debugging

---

## AXI4 Channel Structure

### Write Transaction

The AXI write transaction consists of three channels:

```text
AW (Write Address)
        ↓
W  (Write Data)
        ↓
B  (Write Response)
Read Transaction

The AXI read transaction consists of two channels:

AR (Read Address)
        ↓
R  (Read Data)

A transfer occurs when both VALID and READY are asserted:

VALID && READY = Transfer
Burst Types
FIXED Burst

The address remains unchanged for every beat.

Address → 4
          4
          4
          4

FIXED bursts are useful for repeated accesses to the same address.

INCR Burst

The address increments after each beat.

For a 32-bit data bus:

Beat 0 → Address 0
Beat 1 → Address 4
Beat 2 → Address 8
Beat 3 → Address 12
WRAP Burst

The address increments and then wraps back to the beginning of the defined wrap region.

Example:

Starting address = 4
Burst length     = 4 beats
Bytes per beat   = 4

Addresses:

4 → 8 → 12 → 0
WSTRB Support

The design supports byte-level write enables using WSTRB.

For a 32-bit data bus:

WSTRB[0] → DATA[7:0]
WSTRB[1] → DATA[15:8]
WSTRB[2] → DATA[23:16]
WSTRB[3] → DATA[31:24]

A WSTRB bit of 1 updates the corresponding byte, while 0 preserves the previous byte.

Example:

Previous memory = AAAABBBB
WDATA           = 11223344
WSTRB           = 0001

Result          = AAAABB44
Backpressure Verification

The testbench also verifies AXI backpressure behavior.

Read Channel

When:

RVALID = 1
RREADY = 0

the slave keeps the read data available until the master becomes ready.

Write Response

When:

BVALID = 1
BREADY = 0

the slave keeps the response asserted until the master accepts it.

Project Structure
AXI4/
│
├── README.md
│
├── rtl/
│   └── axi4_slave_independent.v
│
├── tb/
│   └── axi4_slave_tv.v
│
└── simulation/
    ├── AXI Complete Data flow.JPG
    ├── AXI Read Data Sequences.JPG
    ├── AXI Wire Data Sequence.JPG
    └── simulation result.JPG
Simulation

The design can be simulated using Icarus Verilog.

Compile:

iverilog -g2012 -o sim axi4_slave_independent.v axi4_slave_tv.v

Run:

vvp sim

The testbench generates a VCD waveform file:

wave.vcd

The waveform can be viewed using GTKWave.

Verification

The testbench performs checks for:

Write response (BRESP)
Memory contents after write transactions
Burst address behavior
WSTRB byte-level updates
Read data
Read burst sequence
RLAST on the final read beat
Read backpressure
Write response backpressure

Example expected WRAP write:

MEM[4]  = AAAABB44
MEM[8]  = CCCC77DD
MEM[12] = EEAAFFFF
MEM[0]  = DD345678

The corresponding read transaction returns the same values in burst order.

##Tools Used
Verilog/SystemVerilog
Icarus Verilog
GTKWave
Quartus Prime
Git/GitHub

##Learning Outcomes
Through this project, I developed practical understanding of:
AXI4 channel architecture
AXI VALID/READY handshaking
Burst transactions
FIXED, INCR and WRAP addressing
Byte-enable writes using WSTRB
Backpressure handling
RTL simulation and debugging
Self-checking testbench development
FPGA synthesis flow




