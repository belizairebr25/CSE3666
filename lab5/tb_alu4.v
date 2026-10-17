`timescale 1ns/1ps

module ALU4bit_tb;

    reg  [3:0] a;
    reg  [3:0] b;
    reg  [2:0] alu_operation;
    wire [3:0] result;
    wire       zero;

    integer i;
    integer aluop;
    integer has_aluop;

    ALU4bit dut (
        .a(a),
        .b(b),
        .alu_operation(alu_operation),
        .result(result),
        .zero(zero)
    );

    // Test one ALU operation with all possible values of b
    task test_operation;
        input [2:0] operation;
        begin
            alu_operation = operation;

            for (i = 0; i < 16; i = i + 1) begin
                b = i;
                #10;
                $display("     %03b       %04b  %04b  |  %04b    %b",
                         alu_operation, a, b, result, zero);
            end
        end
    endtask

    initial begin
        // Get a from command line. Default is 4'b1010.
        if (!$value$plusargs("a=%d", a))
            a = 4'b1010;

        // Check whether an operation was specified.
        has_aluop = $value$plusargs("aluop=%d", aluop);

        $display("ALU_operation    a     b   | result zero");

        if (has_aluop) begin
            // Test only the specified operation.
            test_operation(aluop[2:0]);
        end
        else begin
            // Test all supported ALU operations.
            test_operation(3'b000);     // AND
            test_operation(3'b001);     // OR
            test_operation(3'b010);     // ADD
            test_operation(3'b110);     // SUB
        end

        $finish(0);
    end

endmodule
