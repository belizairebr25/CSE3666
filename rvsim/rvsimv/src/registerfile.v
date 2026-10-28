module RegisterFile(
    output reg [31:0] dout1,
    output reg [31:0] dout2,
    input      [4:0]  rs1,
    input      [4:0]  rs2,
    input      [4:0]  rd,
    input      [31:0] wrtdata,
    input             regw,
    input             clock,
    input             reset_n
);

    reg [31:0] regs [0:31];
    integer i;
    integer plusarg_rc;
    reg [31:0] init_a0;
    reg [31:0] init_a1;

    initial begin
        init_a0 = 32'd10;
        init_a1 = 32'd11;

        plusarg_rc = $value$plusargs("a0=%d", init_a0);
        plusarg_rc = $value$plusargs("a1=%d", init_a1);
        plusarg_rc = $value$plusargs("a0h=%h", init_a0);
        plusarg_rc = $value$plusargs("a1h=%h", init_a1);
    end

    always @(posedge clock or negedge reset_n) begin
        if (!reset_n) begin
            regs[0] <= 32'h00000000;
            regs[1] <= 32'h00000001; // 1 
            regs[2] <= 32'h10010ff0; // sp 
            regs[3] <= 32'h10010000; // gp
            regs[4] <= 32'hffffff10; // Special addr for output
            regs[10] <= init_a0;
            regs[11] <= init_a1;
            for (i = 5; i < 10; i = i + 1)
                regs[i] <= i;
            for (i = 12; i < 32; i = i + 1)
                regs[i] <= 0;
        end else begin
            if (regw && (rd != 5'd0))
                regs[rd] <= wrtdata;
        end
    end

    always @* begin
        dout1 = regs[rs1];
        dout2 = regs[rs2];
    end
endmodule
