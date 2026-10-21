`timescale 1ns / 1ns

module tb_mul;

    parameter NUM_BITS = 8;

    // -------------------------------------------------
    // DUT signals
    // -------------------------------------------------
    reg  [NUM_BITS-1:0] multiplicand;
    reg  [NUM_BITS-1:0] multiplier;
    wire [2*NUM_BITS-1:0]       product;
    reg                 load;
    wire                done;

    reg clock;

    integer x, y;

    // -------------------------------------------------
    // Instantiate DUT
    // -------------------------------------------------
    Mul_ww dut (
        .p(product),
        .x_init(multiplicand),
        .y_init(multiplier),
        .load(load),
        .done(done),
        .clock(clock)
    );

    // -------------------------------------------------
    // Clock generation
    // -------------------------------------------------
    initial clock = 0;
    always #5 clock = ~clock;

    // -------------------------------------------------
    // Optional waveform dumping
    //   enable with: +trace
    // -------------------------------------------------
    initial begin
        if ($test$plusargs("trace")) begin
            $dumpfile("tb_mul.vcd");
            $dumpvars(0, tb_mul);
        end
    end

    integer cycle = 0;

    initial begin
        $display("%5s %16s %8s %16s %16s %5s %8s %4s",
                 "cycle", "x", "y", "p", "adder_out", "write", "shift_en", "done");
    end

    always @(posedge clock) begin
        if (load)
            cycle <= 0;
        else
            cycle <= cycle + 1;
    end

    always @(negedge clock) begin
        // Print on the negative edge. Assume all signals are settled in this cycle
        $display("%5d %16b %8b %16b %16b %5d %8d %4d",
                cycle,
                dut.x,
                dut.y,
                dut.p,
                dut.adder_out,
                dut.write,
                dut.shift_en,
                dut.done);
    end

    // -------------------------------------------------
    // Stimulus
    // -------------------------------------------------
    initial begin
        // Initial state (values will be loaded explicitly)

        // ---------------------------------------------
        // Read plusargs:
        //   +x=<val>  +y=<val>
        // Defaults: x=255, y=255
        // ---------------------------------------------
        if (!$value$plusargs("x=%d", x))
            x = 255;
        if (!$value$plusargs("y=%d", y))
            y = 255;

        // Apply inputs
        multiplicand = x[NUM_BITS-1:0];
        multiplier   = y[NUM_BITS-1:0];

        // $monitor("load is set to %0d", load);

        // ---------------------------------------------
        // Load phase (initializes datapath + control)
        // ---------------------------------------------
        load = 1;
        @(posedge clock);
        # 1;
        load = 0;

        // ---------------------------------------------
        // Wait until multiplication finishes
        // ---------------------------------------------
        wait (done);

        // ---------------------------------------------
        // One full cycle AFTER done
        // ---------------------------------------------
        @(posedge clock);
        @(posedge clock);

        // ---------------------------------------------
        // Final checks (post-done stability & correctness)
        // ---------------------------------------------
        if (product !== x*y) begin
            $display("ERROR: p != %0d", x*y);
        end

        $display("%0d * %0d = %0d", x, y, product);

        $finish(0);
    end

endmodule
