# RISC-V simulator in Verilog

This simulator models a 32-bit, single-cycle RISC-V processor for CSE 3666.
Complete the datapath in `src/sc_core.v` using the supplied modules and the
course diagram. The PC and instruction ROM instances are provided as examples.
See [README.md](README.md) for the assignment and [testprog.md](testprog.md)
for the supplied tests. This is individual work; see [LICENSE](LICENSE) for
permitted use and sharing.

## Files

Extract the entire ZIP before working, preserving its directory structure.
Run the commands below from the extracted `rvsimv/` directory.

| File or directory | Purpose |
| --- | --- |
| `src/sc_core.v` | Processor core to complete |
| `src/basic_modules.v` | Adders, gates, multiplexers, and PC register module |
| `src/registerfile.v` | Register file and initial register values |
| `src/control.v` | Main control, module `Control` |
| `src/alucontrol.v` | ALU operation decoding |
| `src/alu.v` | Arithmetic, logic, comparison, and shift operations |
| `src/immgen.v` | Immediate generation |
| `src/memory.v` | Instruction ROM, data RAM, and character output |
| `src/tb_rvsim.v` | Clock, reset, tracing, and final reporting |
| `input/` | Supplied instruction-memory dumps |
| `expected/` | Reference outputs |
| `scripts/run-tests.sh` | Build and run all supplied tests |
| `scripts/compare-output.sh` | Compare generated and reference outputs |

The simulator creates `simv` when compiled. The test script creates `output/`;
you do not need to create it in advance. Assembly sources and instructor tools
are not part of the student package. The input dumps include instruction
encodings and matching assembly text for inspection.

## Completing the core

Keep the supplied module interface, wire names, instruction-field assignments,
and PC/ROM examples. Instantiate and connect the remaining modules according
to the complete datapath diagram. Read each module declaration to identify its
ports and widths; use named port connections as in the examples.

Use `u_rf` for the register-file instance and `u_dmem` for data RAM. The supplied
testbench accesses these names directly for final reporting and also uses the
declared core signal names for traces. The starter core can be elaborated by
itself, but the complete testbench requires the missing instances to be added.

## Build and run

Using Icarus Verilog, compile all files in `src/`:

```bash
iverilog -o simv src/*.v
vvp simv +IMEM=input/t-add.txt
```

Recompile after changing Verilog source. `+IMEM` specifies the program dump.
To save one test's output:

```bash
mkdir -p output
vvp simv +IMEM=input/t-add.txt > output/t-add-out.txt
```

The following scripts require Bash and the standard `diff` utility:

```bash
bash scripts/run-tests.sh
bash scripts/compare-output.sh
```

The first script rebuilds the simulator and saves all nine reports in `output/`.
For each `input/<name>.txt`, it generates `output/<name>-out.txt` for comparison
with `expected/<name>-out.txt`. Neither script overwrites the reference files.
The second reports `PASS`, `FAIL`, or `MISSING` for each expected file and exits
with a nonzero status for differences or missing reports. It prints unexpected
output filenames as `EXTRA`. Compare an individual output with:

```bash
diff -u expected/t-add-out.txt output/t-add-out.txt
```

The reference runs use default register values and trace settings except for
`reversebytes`, which requires `+a0=-1598962989` (`0xa0b1c2d3`). The test
script supplies this argument automatically. To reproduce that report manually:

```bash
vvp simv +IMEM=input/reversebytes.txt +a0=-1598962989 > output/reversebytes-out.txt
diff -u expected/reversebytes-out.txt output/reversebytes-out.txt
```

The equivalent hexadecimal override is `+a0h=a0b1c2d3`. Without Bash, run the
compile and `vvp` commands individually in your shell and use a text comparison
tool to inspect each generated report. See [testprog.md](testprog.md) for the
purpose and selected results of each test.

## Simulation arguments

Arguments are case sensitive: use lowercase `a0`, not `A0`.

| Argument | Meaning | Default |
| --- | --- | --- |
| `+IMEM=<path>` | Instruction-memory input file | No instructions loaded |
| `+DMEM=<path>` | Optional data-memory input file | No data loaded |
| `+a0=<decimal>` | Initial `a0` (`x10`), including negative values | 10 |
| `+a1=<decimal>` | Initial `a1` (`x11`) | 11 |
| `+a0h=<hex>` | Hexadecimal initial `a0` | Overrides `+a0` if both appear |
| `+a1h=<hex>` | Hexadecimal initial `a1` | Overrides `+a1` if both appear |
| `+CYCLES=<decimal>` | Maximum simulated instruction cycles | 50000 |
| `+PSTART=<decimal>` | First cycle to trace, inclusive | 0 |
| `+PEND=<decimal>` | Last trace boundary, exclusive | 100000 |

For example, run Fibonacci with a different input and suppress cycle traces:

```bash
vvp simv +IMEM=input/fib.txt +a0=5 +PEND=0
```

Tracing does not change execution. A different argument or trace interval does
change the report, so it will not match the supplied default reference file.

The testbench stops when instruction fetch reaches an unloaded, misaligned, or
out-of-range address, or when the cycle limit is reached. A hole in the loaded
instructions therefore ends execution even if later addresses are loaded.
No exit system call is needed. Check for the `INFO: done is set in cycle ...`
message: a cycle-limit stop still prints a report and is not reported as a
simulation failure. A missing or unreadable instruction file currently loads
nothing and can cause immediate completion.

## Register initialization

Reset initializes PC to `0x00400000` and registers as follows. These values are
lab conventions, not requirements of the RISC-V architecture.

| Registers | Initial values |
| --- | --- |
| `x0` | Zero; writes are ignored |
| `x1` | 1 |
| `x2` (`sp`) | `0x10010ff0` |
| `x3` (`gp`) | `0x10010000` |
| `x4` (`tp`) | `0xffffff10`, the character output address |
| `x5` through `x9` | Their register numbers |
| `x10` (`a0`), `x11` (`a1`) | 10 and 11, unless overridden |
| `x12` through `x31` | Zero |

## Memory and output

ROM and RAM each contain 1024 words. Instruction addresses begin at
`0x00400000`, and data addresses begin at `0x10010000`. The last accessible
word addresses are `0x00400ffc` and `0x10010ffc`, respectively. Addresses are
byte addresses and word accesses must be aligned to four bytes. Unloaded or
invalid RAM reads return zero; invalid RAM writes are ignored.

Instruction and optional data files use the same address/value format:

```text
0x10010000  0x12345678
0x10010004  0xffffffff
0x10010008  0x00000041
```

Each accepted line begins with a hexadecimal byte address and a hexadecimal
32-bit word. This accepts RARS SegmentWindow dumps, including their trailing
assembly and source text. Headers and other lines without two parsable
hexadecimal fields are ignored, as are misaligned or out-of-range addresses.
For repeated addresses, the last accepted entry wins. This is not Verilog
`$readmemh` syntax.

To preload data from your own file:

```bash
vvp simv +IMEM=input/t-add.txt +DMEM=data.txt
```

Loaded data words are marked valid but not modified. Memories are initialized
once at simulation startup; resetting the core does not reload them.

A store to exactly `0xffffff10` prints the low eight data bits as a character
into an output buffer. Repeated stores to that same address build a string;
stores to adjacent addresses do not print. At the end of simulation, the
testbench prints the collected characters under `==========Program output`,
after the register and memory reports. This section is omitted when the program
produces no output. A trailing newline is added for display
if the program did not supply one. The buffer holds 128 bytes (configurable
through the RAM's `OUTPUT_BUFFER_SIZE` parameter); overflow stops simulation with an
error instead of dropping characters.

Each cycle trace includes the PC, instruction, decoded fields, immediate,
control signals, ALU inputs/result, and PC targets. The final report lists all
32 registers and the final values of RAM words written during execution, in
address order. Preloaded words appear there only if subsequently written.
Printed characters appear together in the final program output section.

## Supported instructions

```text
ADD  SUB  AND  OR  XOR  SLT  SLTU  SLL  SRL  SRA
ADDI ANDI ORI XORI SLTI SLTIU SLLI SRLI SRAI
LW   SW   BEQ
```

Arithmetic wraps to 32 bits. Immediate ALU operands are sign extended;
shift amounts use the low five bits. `SLT`/`SLTI` compare signed values and
`SLTU`/`SLTIU` compare unsigned values. Only the listed instructions are
supported: there are no jumps, system calls, other branch conditions,
byte/halfword transfers, or multiply/divide instructions. Unsupported encodings
are not reliably rejected and may execute as another operation.

## Debugging

Implement the entire diagram, then test first with `t-add`, followed by logic,
immediate, shift, memory, branch, and application tests. Find the first cycle
where a meaningful signal differs, rather than starting with the final report.
Check module ports, mux input order, control signals, and the selected PC path.

`ReadData2` is printed even for instructions that use an immediate; its value
does not necessarily affect execution. ALU operation codes are internal codes,
printed in binary, rather than instruction encodings.

The comparison script compares complete text. The testbench uses `$finish(0)`
to suppress the source-path diagnostic in Icarus. If another simulator adds
termination diagnostics, or changes text-file line endings, distinguish those
differences from changes in cycle traces, registers, memory, and program output.

## Creating test programs

Write a RISC-V assembly program using the [supported instructions](#supported-instructions)
and save it as, for example, `my-test.s` in the extracted `rvsimv/` directory.
Use the simulator's register initialization and memory addresses described below.
Do not use exit system calls; execution ends when the PC reaches an unloaded
instruction address. Pseudoinstructions are usable only if they expand entirely
into supported instructions.

Open a terminal in that directory and run the following command to assemble
the program and save its instruction dump:

```bash
java -jar rars1_6.jar a dump .text SegmentWindow input/my-test.txt my-test.s
```

Replace `rars1_6.jar` with the filename or path of the RARS JAR on your computer;
its filename may differ. Quote the path if it contains spaces. This command
requires Java and RARS. Use the `SegmentWindow` format shown here, rather than
a raw hexadecimal dump, because the simulator expects an address and word on
each line.

After compiling the Verilog simulator, run your new test from the terminal:

```bash
mkdir -p output
vvp simv +IMEM=input/my-test.txt > output/my-test-out.txt
```

Work out the expected register and memory values independently and inspect the
report against them. Saving simulator output alone does not establish that it
is correct. The supplied test scripts run the nine bundled cases; run additional
tests manually with `+IMEM` as shown above.
