`timescale 1ns / 1ps

module tb_rule110;

    localparam NCELLS = 16;

    reg  clock;
    reg  init_en;
    reg  [NCELLS-1:0] init_cells;
    wire [NCELLS-1:0] cells;

    integer ncycles;
    integer cycle;

    Rule110_Machine dut (
        .cells(cells),
        .clock(clock),
        .init_en(init_en),
        .init_cells(init_cells)
    );

    // Clock: period 10
    initial clock = 1'b0;
    always #5 clock = ~clock;

    // Print task: matches MyHDL (cells[15]...cells[0])
    task print_cells(input integer c);
        integer i;
        begin
            $write("Cycle %2d ", c);
            for (i = NCELLS-1; i >= 0; i = i - 1) begin
                $write("%s", cells[i] ? "*" : ".");
            end
            $write("\n");
        end
    endtask

    // Optional waveform dump: enable with +trace
    initial begin
        if ($test$plusargs("trace")) begin
            $dumpfile("rule110.vcd");
            $dumpvars(0, tb_rule110);
        end
    end

    initial begin
        // Defaults (same as MyHDL defaults)
        ncycles = 16;
        init_cells = 16'b1001100110011001;

        // Read plusargs
        if ($value$plusargs("ncycles=%d", ncycles));
        if ($value$plusargs("iv=%b", init_cells));

        init_en = 1'b1;     // assert init_en
        @(posedge clock);   // init DFFs
        @(negedge clock);
        init_en = 1'b0;     // release init
        print_cells(0);

        // Print cycles 1..ncycles-1 on negedge
        for (cycle = 1; cycle < ncycles; cycle = cycle + 1) begin
            @(negedge clock);
            print_cells(cycle);
        end

        $finish(0);
    end

endmodule
