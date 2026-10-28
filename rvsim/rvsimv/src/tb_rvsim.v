`timescale 1ns/1ps

module tb_rvsim;
    reg clock;
    reg reset_n;
    wire done;

    integer max_cycles;
    integer pstart;
    integer pend;
    integer cycle;
    integer i;
    integer plusarg_rc;
    reg finished;

    RISCVCore dut(
        .clock(clock),
        .reset_n(reset_n),
        .done(done)
    );

    initial begin
        clock = 1'b1;
        forever #5 clock = ~clock;
    end

    initial begin
        max_cycles = 50000;
        plusarg_rc = $value$plusargs("CYCLES=%d", max_cycles);
        pstart = 0;
        plusarg_rc = $value$plusargs("PSTART=%d", pstart);
        pend = 100000;
        plusarg_rc = $value$plusargs("PEND=%d", pend);

        reset_n = 1'b0;
        @(posedge clock);
        @(posedge clock);
        reset_n = 1'b1;

        cycle = 0;
        finished = 1'b0;
        while ((cycle < max_cycles) && !finished) begin
            @(negedge clock);

            if (done) begin
                $display("INFO: done is set in cycle %0d", cycle);
                finished = 1'b1;
            end else begin
                if ((cycle >= pstart) && (cycle < pend)) begin
                    $display("==========Cycle %0d", cycle);
                    $display("PC=0x%08x instruction=0x%08x", dut.PC, dut.instruction);
                    $display("rs1=%0d rs2=%0d rd=%0d imm=0x%08x", dut.rs1, dut.rs2, dut.rd, dut.imm);
                    $display("Branch=%0d MemRead=%0d MemWrite=%0d ALUSrc=%0d RegWrite=%0d MemtoReg=%0d ALUOp=%0b", dut.Branch, dut.MemRead, dut.MemWrite, dut.ALUSrc, dut.RegWrite, dut.MemtoReg, dut.ALUOp);
                    $display("ALUOperation=%0b ReadData1=0x%08x ReadData2=0x%08x ALUInput2=0x%08x", dut.ALUOperation, dut.ReadData1, dut.ReadData2, dut.ALUInput2);
                    $display("ALUResult=0x%08x Zero=%0d BranchTarget=0x%08x PC4=0x%08x NextPC=0x%08x", dut.ALUResult, dut.Zero, dut.BranchTarget, dut.PC4, dut.NextPC);
                end
                cycle = cycle + 1;
            end
        end

        $display("==========Report");
        for (i = 0; i < 32; i = i + 1)
            $display("x%0d=0x%08x", i, dut.u_rf.regs[i]);

        dut.u_dmem.dump_modified_words();
        dut.u_dmem.dump_output();

        $finish(0);
    end
endmodule
