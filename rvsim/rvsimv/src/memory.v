module Ram(
    output reg [31:0] dout,
    input      [31:0] din,
    input      [31:0] addr,
    input             memr,
    input             memw,
    input             clk
);
    parameter BASE_ADDR = 32'h10010000;
    parameter WORDS = 1024;
    parameter MMIO_PUTC_ADDR = 32'hFFFFFF10;
    parameter OUTPUT_BUFFER_SIZE = 128;

    reg [31:0] mem [0:WORDS-1];
    reg        valid [0:WORDS-1];
    reg        dirty [0:WORDS-1];
    reg [7:0] output_buffer [0:OUTPUT_BUFFER_SIZE-1];
    integer output_count;

    integer i;
    integer fd;
    integer rc;
    integer load_idx;
    integer wr_idx;
    integer rd_idx;
    reg [31:0] a;
    reg [31:0] v;
    reg [8*256-1:0] memfile;
    reg [8*2048-1:0] line;

    function integer addr_to_index;
        input [31:0] byte_addr;
        begin
            if ((byte_addr >= BASE_ADDR) &&
                (byte_addr < (BASE_ADDR + WORDS*4)) &&
                (byte_addr[1:0] == 2'b00))
                addr_to_index = (byte_addr - BASE_ADDR) >> 2;
            else
                addr_to_index = -1;
        end
    endfunction

    initial begin
        output_count = 0;
        for (i = 0; i < WORDS; i = i + 1) begin
            mem[i] = 32'd0;
            valid[i] = 1'b0;
            dirty[i] = 1'b0;
        end

        memfile = 0;
        if ($value$plusargs("DMEM=%s", memfile)) begin
            fd = $fopen(memfile, "r");
            if (fd != 0) begin
                while (!$feof(fd)) begin
                    rc = $fgets(line, fd);
                    if (rc != 0 && $sscanf(line, "%h %h", a, v) == 2) begin
                        load_idx = addr_to_index(a);
                        if (load_idx >= 0) begin
                            mem[load_idx] = v;
                            valid[load_idx] = 1'b1;
                            dirty[load_idx] = 1'b0;
                        end
                    end
                end
                $fclose(fd);
            end
        end
    end

    always @(posedge clk) begin
        if (memw && !memr) begin
            if (addr == MMIO_PUTC_ADDR) begin
                if (output_count >= OUTPUT_BUFFER_SIZE)
                    $fatal(1, "MMIO output buffer full (%0d bytes)", OUTPUT_BUFFER_SIZE);
                else begin
                    output_buffer[output_count] = din[7:0];
                    output_count = output_count + 1;
                end
            end else begin
                wr_idx = addr_to_index(addr);
                if (wr_idx >= 0) begin
                    mem[wr_idx] <= din;
                    valid[wr_idx] <= 1'b1;
                    dirty[wr_idx] <= 1'b1;
                end
            end
        end
    end

    always @* begin
        dout = 32'd0;
        if (memr && !memw) begin
            rd_idx = addr_to_index(addr);
            if ((rd_idx >= 0) && valid[rd_idx])
                dout = mem[rd_idx];
        end
    end

    task dump_output;
        integer j;
        begin
            if (output_count > 0) begin
                $display("==========Program output");
                for (j = 0; j < output_count; j = j + 1)
                    $write("%c", output_buffer[j]);
                if (output_buffer[output_count-1] != 8'h0a)
                    $write("\n");
            end
        end
    endtask

    task dump_modified_words;
        integer j;
        integer count;
        begin
            count = 0;
            $display("==========Data memory modified words");
            for (j = 0; j < WORDS; j = j + 1) begin
                if (dirty[j]) begin
                    $display("0x%08x: 0x%08x", BASE_ADDR + j*4, mem[j]);
                    count = count + 1;
                end
            end
            if (count == 0)
                $display("(none)");
        end
    endtask
endmodule

module Rom(
    output reg [31:0] dout,
    output reg        valid_addr,
    input      [31:0] addr
);
    parameter BASE_ADDR = 32'h00400000;
    parameter WORDS = 1024;
    parameter NOP = 32'h00000013;

    reg [31:0] mem [0:WORDS-1];
    reg        valid [0:WORDS-1];

    integer i;
    integer fd;
    integer rc;
    integer load_idx;
    integer rd_idx;
    reg [31:0] a;
    reg [31:0] v;
    reg [8*256-1:0] memfile;
    reg [8*2048-1:0] line;

    function integer addr_to_index;
        input [31:0] byte_addr;
        begin
            if ((byte_addr >= BASE_ADDR) &&
                (byte_addr < (BASE_ADDR + WORDS*4)) &&
                (byte_addr[1:0] == 2'b00))
                addr_to_index = (byte_addr - BASE_ADDR) >> 2;
            else
                addr_to_index = -1;
        end
    endfunction

    initial begin
        for (i = 0; i < WORDS; i = i + 1) begin
            mem[i] = NOP;
            valid[i] = 1'b0;
        end

        memfile = 0;
        if ($value$plusargs("IMEM=%s", memfile)) begin
            fd = $fopen(memfile, "r");
            if (fd != 0) begin
                while (!$feof(fd)) begin
                    rc = $fgets(line, fd);
                    if (rc != 0 && $sscanf(line, "%h %h", a, v) == 2) begin
                        load_idx = addr_to_index(a);
                        if (load_idx >= 0) begin
                            mem[load_idx] = v;
                            valid[load_idx] = 1'b1;
                        end
                    end
                end
                $fclose(fd);
            end
        end
    end

    always @* begin
        dout = NOP;
        valid_addr = 1'b0;
        rd_idx = addr_to_index(addr);
        if ((rd_idx >= 0) && valid[rd_idx]) begin
            dout = mem[rd_idx];
            valid_addr = 1'b1;
        end
    end

    task dump_loaded_words;
        integer j;
        integer count;
        begin
            count = 0;
            $display("==========Instruction memory loaded words");
            for (j = 0; j < WORDS; j = j + 1) begin
                if (valid[j]) begin
                    $display("0x%08x: 0x%08x", BASE_ADDR + j*4, mem[j]);
                    count = count + 1;
                end
            end
            if (count == 0)
                $display("(none)");
        end
    endtask
endmodule
