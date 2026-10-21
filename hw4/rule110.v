// ------------------------------------------------------------
// D Flip-Flop with synchronous init-load (NO reset)
// When init_en=1 at posedge clock, q loads init_d.
// Otherwise q loads normal d.
// All DFF instances are identical.
// ------------------------------------------------------------
module DFF (
    output reg  q,
    input  wire d,
    input  wire init_en,
    input  wire init_d,
    input  wire clock
);
    always @(posedge clock) begin
        if (init_en)
            q <= init_d;
        else
            q <= d;
    end
endmodule


// ------------------------------------------------------------
// Rule 110 next-cell logic
// live = not ((l & m & r) | (~m & ~r))
// ------------------------------------------------------------
module NextCellGen (
    output wire live,
    input  wire l,
    input  wire m,
    input  wire r
);
    // TODO 
    // assign live = an expression you write from the truth table 

endmodule


// ------------------------------------------------------------
// Rule110 Machine (fixed 16 cells, no generate statements)
// cells[15] is left-most, cells[0] is right-most
// Boundary cells (0 and 15) do not change (they feed back q->d)
// Initialization happens by asserting init_en for 1 clock edge.
// ------------------------------------------------------------
module Rule110_Machine (
    output wire [15:0] cells,
    input  wire        clock,
    input  wire        init_en,
    input  wire [15:0] init_cells
);

    // Next-state wires for cells 1..14
    wire next1, next2, next3, next4, next5, next6, next7;
    wire next8, next9, next10, next11, next12, next13, next14;

    // TODO

    // Generate next1 through next14
    // We need 14 NextCellGen blocks (cells 1..14)

    // 16 identical DFFs
    // Boundary cells hold value: d = q
    // dff00 is provided as an example
    DFF dff00(cells[ 0], cells[ 0], init_en, init_cells[ 0], clock);

endmodule
