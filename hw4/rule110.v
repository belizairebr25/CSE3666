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
    assign live = ~((l & m & r) | (~m & ~r));

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
	NextCellGen gen1  (.live(next1),  .l(cells[2]),  .m(cells[1]),  .r(cells[0]));
    NextCellGen gen2  (.live(next2),  .l(cells[3]),  .m(cells[2]),  .r(cells[1]));
    NextCellGen gen3  (.live(next3),  .l(cells[4]),  .m(cells[3]),  .r(cells[2]));
    NextCellGen gen4  (.live(next4),  .l(cells[5]),  .m(cells[4]),  .r(cells[3]));
    NextCellGen gen5  (.live(next5),  .l(cells[6]),  .m(cells[5]),  .r(cells[4]));
    NextCellGen gen6  (.live(next6),  .l(cells[7]),  .m(cells[6]),  .r(cells[5]));
    NextCellGen gen7  (.live(next7),  .l(cells[8]),  .m(cells[7]),  .r(cells[6]));
    NextCellGen gen8  (.live(next8),  .l(cells[9]),  .m(cells[8]),  .r(cells[7]));
    NextCellGen gen9  (.live(next9),  .l(cells[10]), .m(cells[9]),  .r(cells[8]));
    NextCellGen gen10 (.live(next10), .l(cells[11]), .m(cells[10]), .r(cells[9]));
    NextCellGen gen11 (.live(next11), .l(cells[12]), .m(cells[11]), .r(cells[10]));
    NextCellGen gen12 (.live(next12), .l(cells[13]), .m(cells[12]), .r(cells[11]));
    NextCellGen gen13 (.live(next13), .l(cells[14]), .m(cells[13]), .r(cells[12]));
    NextCellGen gen14 (.live(next14), .l(cells[15]), .m(cells[14]), .r(cells[13]));
    // 16 identical DFFs
	// Boundary cells hold value: d = q
    // dff00 is provided as an example

	DFF dff00(cells[ 0], cells[ 0], init_en, init_cells[ 0], clock);
    DFF dff01(cells[ 1], next1,    init_en, init_cells[ 1], clock);
    DFF dff02(cells[ 2], next2,    init_en, init_cells[ 2], clock);
    DFF dff03(cells[ 3], next3,    init_en, init_cells[ 3], clock);
    DFF dff04(cells[ 4], next4,    init_en, init_cells[ 4], clock);
    DFF dff05(cells[ 5], next5,    init_en, init_cells[ 5], clock);
    DFF dff06(cells[ 6], next6,    init_en, init_cells[ 6], clock);
    DFF dff07(cells[ 7], next7,    init_en, init_cells[ 7], clock);
    DFF dff08(cells[ 8], next8,    init_en, init_cells[ 8], clock);
    DFF dff09(cells[ 9], next9,    init_en, init_cells[ 9], clock);
    DFF dff10(cells[10], next10,   init_en, init_cells[10], clock);
    DFF dff11(cells[11], next11,   init_en, init_cells[11], clock);
    DFF dff12(cells[12], next12,   init_en, init_cells[12], clock);
    DFF dff13(cells[13], next13,   init_en, init_cells[13], clock);
    DFF dff14(cells[14], next14,   init_en, init_cells[14], clock);
    DFF dff15(cells[15], cells[15], init_en, init_cells[15], clock);

    // Boundary cells hold value: d = q
    // dff00 is provided as an example


endmodule
