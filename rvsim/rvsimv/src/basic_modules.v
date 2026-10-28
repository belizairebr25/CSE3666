module Adder(
    output [31:0] result,
    input  [31:0] in1,
    input  [31:0] in2
);

    assign result = in1 + in2;
endmodule

module Not(
    output z,
    input  a
);

    assign z = ~a;
endmodule

module And2(
    output z,
    input  a,
    input  b
);

    assign z = a & b;
endmodule

module Or2(
    output z,
    input  a,
    input  b
);

    assign z = a | b;
endmodule

module Xor2(
    output z,
    input  a,
    input  b
);

    assign z = a ^ b;
endmodule

module Nand2(
    output z,
    input  a,
    input  b
);

    assign z = ~(a & b);
endmodule

module Nor2(
    output z,
    input  a,
    input  b
);

    assign z = ~(a | b);
endmodule

module Mux2(
    output reg [31:0] z,
    input      [31:0] a,
    input      [31:0] b,
    input             sel
);

    always @* begin
        if (sel)
            z = b;
        else
            z = a;
    end
endmodule

module Mux4(
    output reg [31:0] z,
    input      [31:0] a,
    input      [31:0] b,
    input      [31:0] c,
    input      [31:0] d,
    input      [1:0]  sel
);

    always @* begin
        case (sel)
            2'b00: z = a;
            2'b01: z = b;
            2'b10: z = c;
            default: z = d;
        endcase
    end
endmodule

module RegisterE(
    output reg [31:0] dout,
    input      [31:0] din,
    input             en,
    input             clock,
    input             reset_n,
    input      [31:0] reset_value
);

    always @(posedge clock or negedge reset_n) begin
        if (!reset_n)
            dout <= reset_value;
        else if (en)
            dout <= din;
        else
            dout <= dout;
    end
endmodule
