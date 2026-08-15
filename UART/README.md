# UART Communication System using Verilog HDL

## 1. Project Overview

Universal Asynchronous Receiver/Transmitter (UART) is a serial communication protocol used to exchange data between digital systems without requiring a separate clock signal.

In this project, a UART communication system is designed and implemented using Verilog HDL.

The design includes:

- Baud rate generator
- UART transmitter
- UART receiver
- FSM-based control logic
- Top-level UART integration
- Testbench-based verification
- Simulation waveform analysis

The complete design demonstrates the RTL development flow from individual modules to top-level integration and functional verification.

---

## 2. UART System Architecture

The UART system consists of the following major blocks:

1. **Baud Rate Generator** – Generates the timing required for UART serial communication.
2. **UART Transmitter (TX)** – Converts parallel data into a serial data stream.
3. **UART Receiver (RX)** – Receives serial data and converts it back into parallel data.
4. **FSM** – Controls the sequence of UART transmission and/or reception operations.
5. **Top Model** – Integrates the UART functional blocks into a complete system.

### UART Data Flow

```text
                 +----------------------+
                 |   Baud Rate Generator|
                 +----------+-----------+
                            |
                         Baud Tick
                            |
                            v
+-------------+      +-------------+      Serial Data
| Parallel    |----->| UART TX     |-------------------->
| Data        |      | Transmitter |
+-------------+      +-------------+

                         Serial Data
                              |
                              v
                     +----------------+
                     | UART RX        |
                     | Receiver       |
                     +-------+--------+
                             |
                             v
                       Parallel Data

3. UART Communication
UART communication is asynchronous, meaning that the transmitter and receiver do not share a common clock.
A typical UART frame consists of:
Idle     Start      Data Bits        Stop
  1        0       D0 D1 ... Dn       1
  |        |             |            |
  +--------+-------------+------------+
The transmitter serializes the data and sends it through the TX line.
The receiver samples the RX line and reconstructs the transmitted data.

4. Baud Rate Generator
The baud rate generator produces the timing required for UART communication.
The generated baud timing is used by the transmitter and receiver FSMs to control:
.Start-bit timing
.Data-bit timing
.Sampling points
.Stop-bit timing
The RTL implementation is available in:
Generator/buard_rate_generator.v
Note: The filename currently uses buard_rate_generator.v. Keep the filename consistent with the RTL/module references.

5. UART Transmitter
The UART transmitter converts parallel input data into a serial stream.
The general transmission sequence is:
Idle
  |
  v
Start Bit
  |
  v
Data Bits
  |
  v
Stop Bit
  |
  v
Idle
The transmitter FSM controls the different stages of the UART transmission process.
RTL implementation:
Transmitter/UART_tx.v

6. UART Receiver
The UART receiver monitors the serial RX input and detects the incoming UART frame.
The general reception sequence is:
Idle
  |
  v
Detect Start Bit
  |
  v
Sample Data Bits
  |
  v
Receive Complete
  |
  v
Stop Bit
  |
  v
Idle
The receiver reconstructs the serial data into parallel data for further processing.
RTL implementation:
Receiver/UART_Rx.v

7. FSM Design
Finite State Machines are used to control the sequence of UART operations.
The FSM manages operations such as:
.Idle detection
.Start-bit handling
.Data-bit transmission/reception
.Bit counting
.Stop-bit handling
.Completion of UART operation
The FSM-related diagram is available in:
FSM/FSM.png

8. Top-Level Integration
The top-level UART module integrates the major functional blocks into a single design.
The top-level RTL is available in:
Top_Model/UART_top.v
The top-level design provides the interface between the UART transmitter, receiver, baud rate generator, and external signals

9. Testbench
The UART testbench is available in:
Testbench/UART_top_tb.v
The testbench is used to verify:
.Clock operation
.Reset behavior
.UART transmission
.UART reception
.Serial data timing
.Data transfer between TX and RX
.Overall UART functionality

10. Simulation
The UART simulation response is available in:
Response/UART Response.JPG
The simulation waveform can be used to analyze:
.Clock
.Reset
.TX signal
.RX signal
.Baud timing
.Data transmission
.Data reception
.UART control signals

11. Block Diagram
The UART block diagram is available in:

12. Project Structure
UART/
│
├── Block_Diagram/
│   └── UART Block.JPG
│
├── FSM/
│   └── FSM.png
│
├── Generator/
│   └── buard_rate_generator.v
│
├── Receiver/
│   └── UART_Rx.v
│
├── Response/
│   └── UART Response.JPG
│
├── Testbench/
│   └── UART_top_tb.v
│
├── Top_Model/
│   └── UART_top.v
│
├── Transmitter/
│   └── UART_tx.v
│
└── README.md

13. Tools Used
.Verilog HDL
.Icarus Verilog
.GTKWave
.Yosys
.Git
.GitHub

14. RTL Design Flow
The project follows a typical RTL design and verification flow:
Specification
     |
     v
Architecture
     |
     v
RTL Design
     |
     v
Module Integration
     |
     v
Testbench
     |
     v
Simulation
     |
     v
Waveform Analysis
     |
     v
Functional Verification
