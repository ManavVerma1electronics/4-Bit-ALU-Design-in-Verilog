module alu_4bit (
    input  wire [3:0] a,
    input  wire [3:0] b,
    input  wire [2:0] op,
    output reg  [3:0] y,
    output reg        carry,
    output reg        overflow,
    output wire       zero,
    output wire       negative
);

    reg [4:0] tmp;   // 5 bits so the carry-out has somewhere to go

    always @(*) begin
        tmp      = 5'd0;
        carry    = 1'b0;
        overflow = 1'b0;
        case (op)
            3'b000: begin  // ADD
                tmp      = {1'b0, a} + {1'b0, b};
                y        = tmp[3:0];
                carry    = tmp[4];
                overflow = (a[3] == b[3]) && (y[3] != a[3]);
            end
            3'b001: begin  // SUB
                tmp      = {1'b0, a} - {1'b0, b};
                y        = tmp[3:0];
                carry    = tmp[4];   // 1 means borrow
                overflow = (a[3] != b[3]) && (y[3] != a[3]);
            end
            3'b010: y = a & b;
            3'b011: y = a | b;
            3'b100: y = a ^ b;
            3'b101: y = ~a;
            3'b110: begin y = {a[2:0], 1'b0}; carry = a[3]; end
            3'b111: begin y = {1'b0, a[3:1]}; carry = a[0]; end
            default: y = 4'b0000;
        endcase
    end

        assign zero     = (y == 4'b0000);
    assign negative = y[3];
endmodule