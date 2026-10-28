# Lab 7: A RISC-V Simulator

**This lab is worth 200 points**. It has two components. 

*   Code. 100 points. Graded by the autograder
*   Demo. 100 points. Graded by TAs. Demos can be done in labs or during office
    hours. Please check office hours schedule and plan ahead.

**Deadline:** Friday, 11/6/2026. 

**Late Deadline for code:** Sunday, 11/8/2026.

**Late Deadline for demo:** Friday, 11/13/2026.

## Documentation and Demo Expectations

Document significant errors you encounter while completing the lab, including their causes, how you identified them, and how you corrected them.

During the demo, TAs will assess your ability to edit code on your computer, run simulations, examine and interpret simulator output, and explain how instructions are executed. Be prepared to discuss the errors you documented.

You may demo only after your code has passed all autograder tests. Only one demo attempt is allowed, so make sure you are fully prepared.

## Learning Objectives

* Implement a single-cycle RISC-V processor in Verilog

* Build a processor from existing modules

## Description

In this lab, we complete the design of a single-cycle RISC-V processor,
following the diagram we have constructed. The diagram is Figure 4.21 in
textbook. A copy has been posted in HuskyCT.

### Instructions supported by the processor

The processor supports the subset of instructions we have studied.

```
ADD, SUB, AND, OR, XOR, SLT, SLTU, LW, SW, BEQ
```

In addition, the ALU supports shift operations. ImmGen, ALU control, and the
main control have been improved to support ALU operations with an immediate. 
Therefore, the following instructions are also supported, without changing the
diagram. 

```
ADDI, ANDI, ORI, XORI, SLTI, SLTIU
SLLI, SRLI, SRAI
SLL, SRL, SRA
```

### Code

Implementing a processor requires a lot of work. However, we have done the
heavy lifting. The remaining work is limited to one file, or a few files if you
would like to improve the processor.

The files provided to you are in a ZIP archive. Extract the entire archive,
preserving its directory structure. Descriptions of the files in the package
are in [rvsim.md](rvsim.md). Read it carefully. The supplied test programs are
described in [testprog.md](testprog.md).

Note that the software is copyrighted to limit its distribution.  A lot of
efforts have been put in the design of the assignment so students can learn
from the code provided and also have opportunities to explore themselves.
Please limit the use of the code in this course. See `LICENSE` in the
downloaded files for detail. 

### Tasks 

The main task is to complete the design of a single-cycle RISC-V core.  Since
all supporting modules are already provided, the main task is to follow Figure
4.21 in the textbook and put everything together. 

We will work on `src/sc_core.v`. Read the provided code carefully. Study the
module declarations in the other files in `src/` to identify each module's
ports and signal widths.

Study the signals declared in `src/sc_core.v` and locate them in the diagram.

Starting from PC (already in the file), create the modules in the diagram one 
by one.  

* Find a module that is connected to the modules that are already created. For
  example, the PC register and instruction memory are already created; the
  next one would be the register file.

* Find the interface of the module by studying the documentations and source
  code.

* Instantiate the module with proper signals connected to it. This is the step
  where students make many mistakes. 

After the diagram is implemented in Verilog, test the simulator. See
[rvsim.md](rvsim.md) for more instructions. Although some expected outputs are provided,
some programs generate different output when argument registers like `a0` and
`a1` are changed.  Run those programs with different initial values in
registers and explain the results from the simulator.

### Debugging

Start from small programs, for example, programs having only R-type
instructions. After the R-type instructions are working, move on to check other
types of instructions: shift instructions, I-type instructions, load, store, and
so on. 

Here are some steps we can follow for testing the simulator.

1.  Save the output of the simulator in a file.

2.  Compare it with expected output.

3.  Identify mismatched signals and check related modules. For example, if
    PC is correct but instruction is not correct, check instruction memory. 

## Deliverables

Submit `sc_core.v` and demo your work to TAs by the deadlines. 

## Previous mistakes

Here are some mistakes students made in previous semesters. 

*   Did not check the simulator locally. Sometimes the submitted code does not
    terminate, or it does not print anything. It is easier to identify problems
    when running the simulator locally and comparing its output with the
    expected.

*   Missed some modules. Double check that the simulator has all the
    components. Probably print a hard copy of the diagram and mark a module 
    when it is placed in the simulator.

*   Did not connect correct signals to a module. Double check every signal connected
    to a module.
