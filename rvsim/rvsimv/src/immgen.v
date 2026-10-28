module ImmGen(
    output reg [31:0] imm,
    input      [31:0] instruction
);

    wire [6:0] opcode;
    wire [19:0] sign20;

    assign opcode = instruction[6:0];
    assign sign20 = {20{instruction[31]}};

    always @* begin
        if (opcode == 7'h23)
            imm = {sign20, instruction[31:25], instruction[11:7]};
        else if (opcode == 7'h63)
            imm = {sign20, instruction[7], instruction[30:25], instruction[11:8], 1'b0};
        else if (opcode == 7'h6F)
            imm = {sign20[19:8], instruction[19:12], instruction[20], instruction[30:25], instruction[24:21], 1'b0};
        else if ((opcode & 7'h5F) == 7'h17)
            imm = {instruction[31:12], 12'b0};
        else
            imm = {sign20, instruction[31:20]};
    end
endmodule
