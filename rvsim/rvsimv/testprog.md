# Test programs

The supplied programs are RARS instruction dumps in `input/`, including machine
code and matching assembly text. Assembly sources are not included in the
student handout. Reference reports are in `expected/`.

See [rvsim.md](rvsim.md#build-and-run) for running the simulator, saving output,
and comparing it with the reference reports, and [README.md](README.md) for
the lab requirements.

## Supplied cases

The reference runs use default register values for all tests except
`reversebytes`, which uses `a0 = 0xa0b1c2d3`.

| Input | Coverage |
| --- | --- |
| `t-add.txt` | Register `ADD`/`SUB`, chains of dependent operations, subtraction from zero |
| `t-and.txt` | Register `AND` and `OR` |
| `t-i.txt` | `ADDI`, `ANDI`, `ORI`, including negative immediates |
| `t-sll.txt` | Register and immediate left, logical-right, and arithmetic-right shifts, including negative operands |
| `t-lw-sw.txt` | LW/SW, positive/negative offsets, and memory-mapped character output |
| `t-beq.txt` | Taken/untaken `BEQ`, forward/backward branches |
| `reversebytes.txt` | Byte reversal using masks, shifts, OR, and a loop |
| `fib.txt` | Fibonacci sequence using arithmetic, branches, and word memory |
| `fact.txt` | Factorials using branches, addition, masks, and shifts |

`reversebytes` preserves its input in `a0` and returns the reversed bytes in
`a1`.

Fibonacci takes a small nonnegative integer `n` in `a0` and stores F(0) through
F(n) in memory, starting from F(0) = 0 and F(1) = 1.  Factorial also takes a
small nonnegative integer `n` in `a0`. It stores 0! through n! in memory and
returns n! in `a0`.
Both sequences begin at `gp`, one word per entry. Factorial uses additions and
shifts to perform multiplication.

## Coverage limits

These nine programs do not exercise every supported instruction or edge case.
In particular, `SLT`, `SLTU`, `SLTI`, `SLTIU`, and `XORI` are not covered.
Passing the supplied suite is a useful checkpoint, not an exhaustive
correctness proof.
