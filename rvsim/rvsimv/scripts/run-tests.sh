#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
OUT_DIR="${1:-output}"
SIM_BIN="$ROOT_DIR/simv"

mkdir -p "$ROOT_DIR/$OUT_DIR"

echo "Building Verilog simulator..."
iverilog -o "$SIM_BIN" "$ROOT_DIR"/src/*.v

echo "Saving outputs in '$ROOT_DIR/$OUT_DIR'"

run_case() {
    local input_file="$1"
    local out_file="$2"
    shift 2
    vvp "$SIM_BIN" \
        +IMEM="$ROOT_DIR/input/$input_file" \
        "$@" \
        > "$ROOT_DIR/$OUT_DIR/$out_file"
}

run_case "t-add.txt" "t-add-out.txt"
run_case "t-and.txt" "t-and-out.txt"
run_case "t-sll.txt" "t-sll-out.txt"
run_case "t-i.txt" "t-i-out.txt"
run_case "t-beq.txt" "t-beq-out.txt"
run_case "t-lw-sw.txt" "t-lw-sw-out.txt"
run_case "reversebytes.txt" "reversebytes-out.txt" +a0=-1598962989
run_case "fib.txt" "fib-out.txt"
run_case "fact.txt" "fact-out.txt"

echo "Done."
