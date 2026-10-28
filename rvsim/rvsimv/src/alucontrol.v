module ALUControl(
    input      [1:0] ALUOp,
    input            instr30,
    input      [2:0] funct3,
    output reg [3:0] operation
);

    always @* begin
        operation = 4'b0000;
        if (ALUOp == 2'b00) begin
            operation = 4'b0010;	// add
        end else if (ALUOp == 2'b01) begin
            operation = 4'b0110;	// sub
        end else begin
            case (funct3)
                3'b111: operation = 4'b0000;	// and / andi
                3'b110: operation = 4'b0001;	// or
                3'b001: operation = 4'b1000;	// sll / slli
                3'b010: operation = 4'b0011;	// slt / slti (signed)
                3'b011: operation = 4'b0111;	// sltu / sltiu (unsigned)
                3'b100: operation = 4'b0101;	// xor / xori
                3'b101: operation = instr30 ? 4'b1011 : 4'b1001; // sra(i) / srl(i)
                3'b000: operation = ((ALUOp == 2'b10) && instr30) ? 4'b0110 : 4'b0010;
                default: operation = 4'b0000;
            endcase
        end
    end
endmodule
