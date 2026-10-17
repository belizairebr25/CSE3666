// CSE 3666 ALU
// tag: d5f92246732061263c4268

// dataflow modeling
module Not (
    output wire y,
    input  wire a
);
    assign y = ~a;
endmodule

// dataflow modeling
module And2 (
    output wire y,
    input  wire a,
    input  wire b
);
    assign y = a & b;
endmodule

// dataflow modeling
module Or2 (
    output wire y,
    input  wire a,
    input  wire b
);
    assign y = a | b;
endmodule

// structural modeling
module Mux2 (
    output wire y,
    input  wire a,
    input  wire b,
    input  wire s
);
    wire nots;
    wire and1;
    wire and2;

    // Use named association for port mapping
    // The following line instantiates the Not gate, too, 
    // but positional association is more error prone.
    // 		Not  u_not  (nots, s);
    Not  u_not  (.y(nots), .a(s));
    And2 u_and1 (.y(and1), .a(nots), .b(a));
    And2 u_and2 (.y(and2), .a(s),    .b(b));
    Or2  u_or   (.y(y),    .a(and1), .b(and2));
endmodule

// dataflow modeling
module Mux4 (
    output wire y,
    input  wire a,
    input  wire b,
    input  wire c,
    input  wire d,
    input  wire [1:0] s
);
    // it is easir to use s1 and s0, instead of s[1] and s[0]
    wire s1 = s[1];
    wire s0 = s[0];

    // Continuous assignment
    assign y =
        (~s1 & ~s0 & a) |
        (~s1 &  s0 & b) |
        ( s1 & ~s0 & c) |
        ( s1 &  s0 & d);
endmodule

// dataflow modeling
module Adder1bit (
    input  wire a,
    input  wire b,
    input  wire carryin,
    output wire carryout,
    output wire s
);
    // TODO:
    // Generate s and carryout using continuous assignments
    // See how the output signal is generated in Mux4
    assign s = carryin ^ a ^ b;
    assign carryout = (a & b) | (carryin & (a ^ b)); 
    
endmodule

// structural modeling
module ALU1bit (
    input  wire a,
    input  wire b,
    input  wire carryin,
    input  wire binvert,
    input  wire [1:0] operation,
    output wire result,
    output wire carryout
);

    // Internal signals
    wire notb;
    wire mux2_out;
    wire and_out;
    wire or_out;
    wire adder_sum;

    // Constant zero (used for SLT placeholder / unused op)
    wire signal0 = 1'b0;

    // Instantiating modules in the ALU
    // Please use named association for port mapping
    // For example, here is how we instantiate a Not gate.
    // Invert B
    Not u_not (
        .a(b),
        .y(notb)
    );

    // TODO:
    // Continue to instantiate other modules
	And2 u_and(
		.a(a),
		.b(mux2_out),
		.y(and_out)
	);
	Mux2 u_mux(
		.a(b),
		.b(notb),
		.s(binvert),
		.y(mux2_out)
	);	
	
	Or2 u_or(
		.a(a),
		.b(mux2_out),
		.y(or_out)
	);
	Adder1bit u_adder1bit(
		.a(a),
		.b(mux2_out),
		.carryin(carryin),
		.carryout(carryout),
		.s(adder_sum)
	);
		
	Mux4 u_mux4(
		.a(and_out),
		.b(or_out),
		.c(adder_sum),
		.d(signal0),
		.s(operation),
		.y(result)
	);
	
endmodule

module ALU4bit (
    input  wire [3:0] a,
    input  wire [3:0] b,
    input  wire [2:0] alu_operation,
    output wire [3:0] result,
    output wire       zero
);

    wire binvert;
    wire [1:0] operation;

    // set binvert and operation signals
    assign binvert  = alu_operation[2];
    assign operation = alu_operation[1:0];

    // carryout driven by ALU0, ALU1, ALU2, and ALU3 
    wire carry0, carry1, carry2, carry3;

    // Implement the 4-bit ALU.
    // It consists of 4 1-bit ALUs, alu3, alu2, alu1, and alu0, 
    // and a logic to generate zero.
    // carryout is the carryout from alu3
    // zero is 1 if and only if the 4-bit result is 0(0b0000).

    // We first instantiate four 1-bit ALUs. 
    // Here is how we instantiate alu0.

    ALU1bit alu0 (
        .a(a[0]),
        .b(b[0]),
        .carryin(binvert),
        .binvert(binvert),
        .operation(operation),
        .result(result[0]),
        .carryout(carry0)
    );

    // TODO:
    // Continue to instantiate three more 1-bit ALUs.
    ALU1bit alu1(
		.a(a[1]),
		.b(b[1]),
		.carryin(carry0),
		.binvert(binvert),
		.operation(operation),
		.result(result[1]),
		.carryout(carry1)
	);

	ALU1bit alu2(
		.a(a[2]),
		.b(b[2]),
		.carryin(carry1),
		.binvert(binvert),
		.operation(operation),
		.result(result[2]),
		.carryout(carry2)
	);

	ALU1bit alu3(
		.a(a[3]),
		.b(b[3]),
		.carryin(carry2),
		.binvert(binvert),
		.operation(operation),
		.result(result[3]),
		.carryout(carry3)
	);
	// Then use continuous assigment to drive/generate zero.
    assign zero = ~(result[0] & result[1] & result[2] & result[3]);
	


endmodule
