# SRAM Design using Verilog HDL

## 1. Project Overview

Static Random-Access Memory (SRAM) is a type of volatile memory that stores data using bistable storage elements. SRAM provides fast data access and is commonly used for cache memory, register files, buffers, and other high-speed memory applications.

In this project, an SRAM module is designed and implemented using Verilog HDL.

The project demonstrates the basic principles of SRAM operation, including:

- Memory data storage
- Read operation
- Write operation
- Address-based memory access
- Control signal operation
- RTL design and simulation
- Logic synthesis

---

## 2. Functional Description

The SRAM consists of a memory array in which each location is selected using an address.

During a **write operation**, input data is stored at the memory location specified by the address.

During a **read operation**, the data stored at the selected memory location is provided at the output.

The basic operation can be represented as:

```text
             Address
                |
                v
        +----------------+
        |                |
Data --->     SRAM       |----> Data Out
  In    |    Memory      |
        |     Array      |
        |                |
        +----------------+
              ^    ^
              |    |
           Write  Read
           Enable Enable
