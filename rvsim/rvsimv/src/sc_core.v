module RISCVCore(
    input  clock,
    input  reset_n,
    output done
);
    localparam PC_BASE_ADDR = 32'h00400000;
	localparam PC_STEP = 32'h00000004;
    wire [31:0] PC;
    wire [31:0] instruction;
    wire        instruction_valid;
    wire [31:0] MemReadData;
    wire [31:0] ALUResult;
    wire [31:0] ReadData2;
    wire        MemRead;
    wire        MemWrite;

    wire [6:0] opcode;
    wire [4:0] rd;
    wire [2:0] funct3;
    wire [4:0] rs1;
    wire [4:0] rs2;
    wire       instr30;

    wire [31:0] imm;
    wire [1:0]  ALUOp;
    wire        ALUSrc;
    wire        Branch;
    wire        MemtoReg;
    wire        RegWrite;
    wire [3:0]  ALUOperation;
    wire [31:0] BranchTarget;
    wire [31:0] ReadData1;
    wire [31:0] ALUInput2;
    wire        Zero;
    wire [31:0] WriteData;
    wire        PCSrc;
    wire [31:0] NextPC;
    wire [31:0] PC4;
	
	//my wires
	wire [31:0] u_adderpc1_out;
	wire [31:0] u_adderpc2_out;

    assign opcode = instruction[6:0];
    assign rd = instruction[11:7];
    assign funct3 = instruction[14:12];
    assign rs1 = instruction[19:15];
    assign rs2 = instruction[24:20];
    assign instr30 = instruction[30];
    assign done = !instruction_valid;
	assign PC4 = PC_STEP;

    RegisterE u_pc(
        .dout(PC),
        .din(NextPC),
        .en(1'b1),
        .clock(clock),
        .reset_n(reset_n),
        .reset_value(PC_BASE_ADDR)
    );

    Rom u_imem(
        .dout(instruction),
        .valid_addr(instruction_valid),
        .addr(PC)
    );

    // TODO:
    // Continue to instantiate other modules
	//pc stuff
	Adder u_adderpc1(
		//normal step adder
		.in1(PC),
		.in2(PC4);
		.out(u_adderpc1_out)
	);
	Adder u_adderpc2(
		//add pc offset to pc
		.in1(PC),
		.in2(imm),
		.out(u_adderpc2_out)
	);
	Mux2 u_mux2_1(
		//select to add imm to pc or step pc
		.a(u_adderpc1_out),
		.b(u_adderpc2_out),
		.s(PCSrc),
		.z(NextPC)
	);
	Not u_not();
	And2 u_and2();
	Or2 u_or2();
	Xor2 u_xor2();
	Nand2 u_nand2();
	Nor2 u_nor2();
	Mux2 u_mux2();
	Mux3();
	  
endmodule
