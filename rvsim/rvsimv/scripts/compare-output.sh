#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
EXPECTED_DIR="${1:-expected}"
OUTPUT_DIR="${2:-output}"

EXPECTED_PATH="$ROOT_DIR/$EXPECTED_DIR"
OUTPUT_PATH="$ROOT_DIR/$OUTPUT_DIR"

if [[ ! -d "$EXPECTED_PATH" ]]; then
    echo "Error: expected directory not found: $EXPECTED_PATH"
    exit 1
fi

if [[ ! -d "$OUTPUT_PATH" ]]; then
    echo "Error: output directory not found: $OUTPUT_PATH"
    exit 1
fi

status=0
checked=0

for expected_file in "$EXPECTED_PATH"/*-out.txt; do
    if [[ ! -e "$expected_file" ]]; then
        echo "No '*-out.txt' files found in $EXPECTED_PATH"
        exit 1
    fi

    name="$(basename "$expected_file")"
    output_file="$OUTPUT_PATH/$name"
    checked=$((checked + 1))

    if [[ ! -f "$output_file" ]]; then
        echo "MISSING: $name"
        status=1
        continue
    fi

    if diff -u "$expected_file" "$output_file" > /dev/null; then
        echo "PASS: $name"
    else
        echo "FAIL: $name"
        diff -u "$expected_file" "$output_file" || true
        status=1
    fi
done

for output_file in "$OUTPUT_PATH"/*-out.txt; do
    if [[ ! -e "$output_file" ]]; then
        break
    fi

    name="$(basename "$output_file")"
    if [[ ! -f "$EXPECTED_PATH/$name" ]]; then
        echo "EXTRA: $name"
    fi
done

echo "Checked $checked file(s)."
exit $status
