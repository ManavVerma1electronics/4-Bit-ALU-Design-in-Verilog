`timescale 1ns/1ps
module tb_alu_4bit;
    reg  [3:0] a, b;
    reg  [2:0] op;
    wire [3:0] y;
    wire carry, overflow, zero, negative;

    alu_4bit dut (.a(a), .b(b), .op(op), .y(y), .carry(carry),
                  .overflow(overflow), .zero(zero), .negative(negative));

    reg [4:0] t;
    reg [3:0] exp_y;
    reg       exp_c;
    integer i, j, k, errors;

    initial begin
        $dumpfile("alu.vcd");
        $dumpvars(0, tb_alu_4bit);
        errors = 0;

        for (k = 0; k < 8; k = k + 1)
            for (i = 0; i < 16; i = i + 1)
                for (j = 0; j < 16; j = j + 1) begin
                    op = k; a = i; b = j; #5;

                    // expected values
                    exp_c = 0;
                    case (op)
                        3'b000: begin t = a + b; exp_y = t[3:0]; exp_c = t[4]; end
                        3'b001: begin t = a - b; exp_y = t[3:0]; exp_c = t[4]; end
                        3'b010: exp_y = a & b;
                        3'b011: exp_y = a | b;
                        3'b100: exp_y = a ^ b;
                        3'b101: exp_y = ~a;
                        3'b110: begin exp_y = a << 1; exp_c = a[3]; end
                        3'b111: begin exp_y = a >> 1; exp_c = a[0]; end
                    endcase

                    if (y !== exp_y || carry !== exp_c) begin
                        errors = errors + 1;
                        $display("FAIL op=%b a=%0d b=%0d y=%0d exp=%0d", op, a, b, y, exp_y);
                    end
                end

        $display("Done: %0d errors", errors);
        if (errors == 0) $display("RESULT: PASS");
        $finish;
    end
endmodule