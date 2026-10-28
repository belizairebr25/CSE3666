module ALU(
    output reg [31:0] result,
    output            zero,
    input      [31:0] in1,
    input      [31:0] in2,
    input      [3:0]  operation
);

    wire [4:0] shamt;
    assign shamt = in2[4:0];

    always @* begin
        case (operation)
            // 0, 1, 2, 6 are defined in the table
            4'b0000: result = in1 & in2;
            4'b0001: result = in1 | in2;
            4'b0010: result = in1 + in2;
            4'b0110: result = in1 - in2;

	    // 5
            4'b0101: result = in1 ^ in2;

            // 3, 7 SLT  7 is in MIPS textbook
            4'b0011: result = ($signed(in1) < $signed(in2)) ? 1 : 0;
            4'b0111: result = (in1 < in2) ? 1 : 0;

            // 8, 9, 11
            4'b1000: result = in1 << shamt;
            4'b1001: result = in1 >> shamt;
            4'b1011: result = $signed(in1) >>> shamt;

	    // 12 is for NOR in MIPS textbook 
            // 14: forward in2
            4'b1110: result = in2;

	    // Not supported for now
            default: result = 32'd0;
        endcase
    end

    assign zero = (result == 32'd0);
endmodule
