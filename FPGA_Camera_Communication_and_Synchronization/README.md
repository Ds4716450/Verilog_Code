# FPGA-Based Serial Communication and Synchronization Protocol for Line-Scan Camera System

## Project Overview

This project implements an FPGA-based digital communication and synchronization path for a front and rear line-scan camera system.

The design transfers 63-bit parallel data through a serial communication path, reconstructs the data at the receiver, performs clock-domain crossing using a handshake-based CDC mechanism, and processes the received data using a pixel-processing block.

The project was developed and verified using Verilog RTL and simulation.

---

## System Architecture

The complete communication path consists of:

```text
                TX CLOCK DOMAIN
                     |
                     v
              +--------------+
              |  Serializer  |
              +------+-------+
                     |
                     | Serial Data
                     v
              +--------------+
              |  Serial Link |
              +------+-------+
                     |
                     v
              +--------------+
              | Deserializer |
              +------+-------+
                     |
                     | 63-bit Data
                     v
              +--------------+
              | CDC Handshake|
              |  Source +    |
              | Destination  |
              +------+-------+
                     |
                     | CDC_DATA_OUT
                     | DST_VALID
                     v
              +--------------+
              |    Pixel     |
              |  Processor   |
              +------+-------+
                     |
                     +-------> PIXEL_COUNT
                     |
                     +-------> EJECTOR_DATA
                     |
                     +-------> DONE
Design Blocks
1. Serializer
Converts 63-bit parallel input data into serial data
Inputs
data_in[62:0]
tx_start
tx_clk
rst

Outputs
serial_data
serializer_done

2. Serial Link
Models the communication link between the transmitter and receiver.
The current RTL models the serial data and associated link clock connection.

3. Deserializer
Receives the serial data and reconstructs the original 63-bit parallel word.
Inputs
serial_link_data
rx_start
receiver clock
reset

Outputs
data_out[62:0]
deserializer_done

4. CDC Handshake
Transfers data between clock domains using a request/acknowledge handshake.
The CDC contains:
Source-side FSM
Destination-side FSM
Request synchronizer
Acknowledge synchronizer
Data holding mechanism
Destination valid indication
The handshake prevents direct unsynchronized control transfer between clock domain

5. Pixel Processor
The pixel processor models the processing of a line containing 4096 pixels.
For the current implementation, the processor counts up to:
4096 pixels
and generates:
pixel_count = 4096
ejector_data = 1
done = 1

Clock Domains
The design uses different clock domains to demonstrate clock-domain crossing.
Transmit Clock
tx_clk = 10 ns period

Equivalent to:
100 MHz
Receiver Clock
rx_clk = 14 ns period

Equivalent to approximately:
71.43 MHz

The different clock periods ensure that the CDC mechanism is exercised under non-identical clock conditions.

Data Flow
The complete data flow is:
63-bit Parallel Data
        |
        v
    Serializer
        |
        v
   Serial Data
        |
        v
   Serial Link
        |
        v
   Deserializer
        |
        v
63-bit Parallel Data
        |
        v
  CDC Handshake
        |
        v
    Pixel Processor
        |
        +------> Pixel Count
        |
        +------> Ejector Data
        |
        +------> Processing Done

CDC Handshake Flow
The CDC uses a request/acknowledge mechanism.
SOURCE DOMAIN                  DESTINATION DOMAIN

    Source FSM
        |
        | REQ
        v
   Request Sync
        |
        v
   Destination FSM
        |
        | ACK
        v
   ACK Synchronizer
        |
        v
    Source FSM
The source holds the transmitted data while the request/acknowledge transaction is completed.

Verification
The RTL was verified using a Verilog testbench.
Four 63-bit test patterns were applied
| Transaction | Input Data         |
| ----------- | ------------------ |
| 1           | 0123456789ABCDEF  |
| 2           | 0FEDCBA987654321  |
| 3           | 0155555555555555  |
| 4           | 0AAAAAAAAAAAAAAA  |

The testbench checks:
Serial link data integrity
CDC data integrity
Pixel processor result

Verification Results
| Transaction | Serial Link | CDC     | Pixel Processor | Pixel Count |
| ----------- | ----------- | ------- | --------------- | ----------- |
| 1           | PASS        | PASS    | PASS            | 4096        |
| 2           | PASS        | PASS    | PASS            | 4096        |
| 3           | PASS        | PASS    | PASS            | 4096        |
| 4           | PASS        | PASS    | PASS            | 4096        |
| Total       | 4/4         | 4/4     | 4/4             | 4096    |

Final Result
Total Transactions : 4
Total Checks       : 16
PASS               : 16
FAIL               : 0

Verification Status: PASS

Simulation
The project was simulated using:
Icarus Verilog

The simulation waveform screenshots are available in:
docs/waveform/

The final simulation results are available in:
simulation/

Static Timing Analysis
Timing analysis was also studied for the design
The documentation includes:
Setup-time analysis
Hold-time analysis
Timing-related waveform/results

Available under:
docs/sta/

Repository Structure
.
├── docs/
│   ├── block_diagram.JPG
│   ├── project_documentation.pdf
│   ├── sta/
│   │   ├── Setup_Time.png
│   │   └── Hold_Time.png
│   └── waveform/
│       ├── 01_reset_start.png
│       ├── 02_serialization.png
│       ├── 03_deserialization.png
│       ├── 04_cdc_handshake.png
│       ├── 05_pixel_processor.png
│       └── 06_complete_transaction.JPG
│
├── rtl/
│   ├── Camera_system_top.v
│   ├── CDC.v
│   ├── Deserializer.v
│   ├── Pixel_Processor.v
│   ├── Serializer.v
│   └── Serial_link.v
│
├── simulation/
│   ├── simulation_final_result.png
│   └── simulation_results.png
│
└── tb/
    └── Camera_system_tv.v

Tools Used
Verilog HDL
Icarus Verilog
Quartus
GTKWave / waveform analysis
Git
GitHub

Key Technical Concepts
RTL Design
FSM-based control
Parallel-to-serial conversion
Serial-to-parallel conversion
Clock Domain Crossing (CDC)
Request/Acknowledge Handshake
Multi-clock design
Synchronizer flip-flops
Verilog Testbench
Functional Verification
Static Timing Analysis
Waveform Debugging








