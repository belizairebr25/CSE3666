// CSE 3666 Lab: Multiplier
// tag: D5M9227102H306263268

`timescale 1ns / 1ns

// ============================================================
// Sequential shift-add multiplier (course version)
// - 8-bit multiplicand (x_init) and multiplier (y_init)
// - 16-bit product (p)
// - No reset: 'load' initializes datapath + control
// - Delays are added to modules for learning the timing of the signals
// ============================================================

module RegisterLoad16 (
    output reg  [15:0] dout,
    input  wire [15:0] din,
    input  wire        write,
    input  wire [15:0] load_data,
    input  wire        load,
    input  wire        clock
);
    always @(posedge clock) begin
        if (load)
            dout <= #1 load_data;
        else if (write)
            dout <= #1 din;
    end
endmodule


module RegisterShiftLeft16 (
    output reg  [15:0] dout,
    input  wire [15:0] load_data,
    input  wire        sl,
    input  wire        load,
    input  wire        clock
);
    always @(posedge clock) begin
        if (load)
            dout <= #1 load_data;
        else if (sl)
            dout <= #1 dout << 1;
    end
endmodule


module RegisterShiftRight8 (
    output reg  [7:0] dout,
    input  wire [7:0] load_data,
    input  wire       sr,
    input  wire       load,
    input  wire       clock
);
    always @(posedge clock) begin
        if (load)
            dout <= #1 load_data;
        else if (sr)
            dout <= #1 dout >> 1;
    end
endmodule


module Adder16 (
    output wire [15:0] s,
    input  wire [15:0] a,
    input  wire [15:0] b
);
    assign #3 s = a + b;
endmodule


module Control (
    output wire done,
    output wire pwrite,
    output wire shift_en,
    input  wire test,
    input  wire load,
    input  wire clock
);
    // Count 0..8
    reg [3:0] counter;
    wire [3:0] counter_next;

    always @(posedge clock) begin
        if (load) 
            counter <= #1 0;
        else 
            counter <= #1 counter_next;
    end
    assign #2 done = (counter == 8);
    assign #1 counter_next = done ? counter : counter + 1; 
    assign #1 shift_en = !done;
    assign #1 pwrite = test;
endmodule


module Mul_ww (
    output wire [15:0] p,
    input  wire [7:0]  x_init,
    input  wire [7:0]  y_init,
    input  wire        load,
    output wire        done,
    input  wire        clock
);

    // Internal signals
    wire [15:0] xx_init;    // 0 extended x_init

    wire [15:0] x;          // multiplicand
    wire [7:0]  y;          // multiplier
    wire [15:0] adder_out;

    wire write;
    wire shift_en;

    wire [15:0] zero16 = 16'b0;     // 16 0's to initialize the product

    assign xx_init = {8'b0, x_init};    // 0 extend x_init

    // p register: loads 0 on load, otherwise loads adder_out on write
    RegisterLoad16 u_reg_p (
        .dout(p),
        .din(adder_out),
        .write(write),
        .load_data(zero16),
        .load(load),
        .clock(clock)
    );

    // TODO: 
    // Continue to instantiate other modules 
	RegisterShiftLeft16 u_reg_sl (
		//inputs
		.load_data(xx_init[15:0]),
		.sl(shift_en),
		.load(load),
		.clock(clock),
		//output
		.dout(x[15:0])
		);

	RegisterShiftRight8 u_reg_sr (
		//inputs
		.load_data(y_init[7:0]),
		.sr(shift_en),
		.load(load),
		.clock(clock),
		//output
		.dout(y)
		);
	Adder16 u_adder (
		//inputs
		.a(p[15:0]),
		.b(x[15:0]),
		//outputs
		.s(adder_out[15:0])
		);
	Control u_control (
		//inputs
		.test(y[0]),
		.load(load),
		.clock(clock),
		//outputs
		.done(done),
		.pwrite(write),
		.shift_en(shift_en)
		);
	
    // x register: loads zero-extended x_init, then shifts left
endmodule



