module Control(
    input      [6:0] opcode,
    output reg [1:0] ALUOp,
    output reg       ALUSrc,
    output reg       Branch,
    output reg       MemRead,
    output reg       MemWrite,
    output reg       MemtoReg,
    output reg       RegWrite
);

    always @* begin
        ALUOp    = 2'b00;
        ALUSrc   = 1'b0;
        Branch   = 1'b0;
        MemRead  = 1'b0;
        MemWrite = 1'b0;
        MemtoReg = 1'b0;
        RegWrite = 1'b0;

        case (opcode)
            7'b0110011: begin
                ALUOp    = 2'b10;
                RegWrite = 1'b1;
            end
            7'b0000011: begin
                ALUOp    = 2'b00;
                ALUSrc   = 1'b1;
                MemRead  = 1'b1;
                MemtoReg = 1'b1;
                RegWrite = 1'b1;
            end
            7'b0100011: begin
                ALUOp    = 2'b00;
                ALUSrc   = 1'b1;
                MemWrite = 1'b1;
            end
            7'b1100011: begin
                ALUOp    = 2'b01;
                Branch   = 1'b1;
            end
            7'b0010011: begin
                ALUOp    = 2'b11;
                ALUSrc   = 1'b1;
                RegWrite = 1'b1;
            end
            default: begin
            end
        endcase
    end
endmodule
