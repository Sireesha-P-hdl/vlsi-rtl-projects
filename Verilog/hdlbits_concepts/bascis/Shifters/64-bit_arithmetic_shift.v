/*
Build a 64-bit arithmetic shift register with synchronous load.

Inputs:
- clk     : Clock
- load    : Load data into register
- ena     : Enable shifting
- amount  :
    2'b00 : Shift left by 1
    2'b01 : Shift left by 8
    2'b10 : Arithmetic shift right by 1
    2'b11 : Arithmetic shift right by 8
- data    : 64-bit input data

Output:
- q       : 64-bit shift register output

Notes:
- Arithmetic right shift replicates the sign bit (q[63]).
- Left shifts are identical for logical and arithmetic.
*/

module top_module(
    input clk,
    input load,
    input ena,
    input [1:0] amount,
    input [63:0] data,
    output reg [63:0] q
);

    always @(posedge clk) begin
        if (load)
            q <= data;                      // Synchronous load
        else if (ena) begin
            case (amount)
                2'b00: q <= q << 1;                             // Left shift by 1
                2'b01: q <= q << 8;                             // Left shift by 8
              2'b10: q <= {q[63], q[63:1]};                   // Arithmetic right by 1 ( 0 is removed coz 1-bit right shift).
              2'b11: q <= {{8{q[63]}}, q[63:8]};              // Arithmetic right by 8  ( 8 times q[63] is multiplied then from 0 to 7 is removed).
            endcase
        end
    end

endmodule
