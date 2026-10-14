`timescale 1ns / 1ps

module testalu1;

    // DUT signals
    reg  a;
    reg  b;
    reg  carryin;
    reg  binvert;
    reg  [1:0] operation;

    wire result;
    wire carryout;

    integer i;
    integer op;
    integer op_start;
    integer op_end;
    integer op_arg;
    integer has_op_arg;

    // Instantiate the ALU
    ALU1bit dut (
        .a(a),
        .b(b),
        .carryin(carryin),
        .binvert(binvert),
        .operation(operation),
        .result(result),
        .carryout(carryout)
    );

    initial begin
        $display("op a b cin binv | cout res");

        // ---------------------------------------
        // Command-line argument handling
        //   +op=<0..3>
        // ---------------------------------------
        has_op_arg = $value$plusargs("op=%d", op_arg);

        if (has_op_arg) begin
            if (op_arg < 0 || op_arg > 3) begin
                $display("ERROR: op must be in range 0..3");
                $finish;
            end
            op_start = op_arg;
            op_end   = op_arg;
        end
        else begin
            // Default: test all operations
            op_start = 0;
            op_end   = 3;
        end

        // ---------------------------------------
        // Main stimulus loops
        // ---------------------------------------
        for (op = op_start; op <= op_end; op = op + 1) begin
            operation = op[1:0];

            for (i = 0; i < 16; i = i + 1) begin
                {binvert, carryin, b, a} = i[3:0];
                #10;
                $display("%b %0d %0d %0d   %0d    | %0d    %0d",
                         operation,
                         a, b, carryin, binvert,
                         carryout, result);
            end
        end

        $finish(0);
    end

endmodule
