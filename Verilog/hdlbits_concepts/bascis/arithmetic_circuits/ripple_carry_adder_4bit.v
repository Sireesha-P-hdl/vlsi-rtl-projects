//-------------------------------------------------------------------------------------------------------------
// Full Adder
// Adds three 1-bit inputs and generates sum and carry-out
//OR
// Verilog quirk: Even though the value of (x+y) includes the carry-out, (x+y) is still considered to be a 4-bit number (The max width of the two operands).
// This is correct:
// assign sum = (x+y);
//-------------------------------------------------------------------------------------------------------------
module full_adder(
    input  x,
    input  y,
    input  cin,
    output sum,
    output cout
);
    assign sum  = x ^ y ^ cin;
    assign cout = (x & y) | (y & cin) | (x & cin);
endmodule


// 4-bit Ripple Carry Adder using Full Adders
module top_module (
    input  [3:0] x,
    input  [3:0] y, 
    output [4:0] sum
);
    wire c0, c1, c2;

    // cin is fixed to 0
    full_adder fa0 (x[0], y[0], 1'b0, sum[0], c0);
    full_adder fa1 (x[1], y[1], c0,   sum[1], c1);
    full_adder fa2 (x[2], y[2], c1,   sum[2], c2);
    full_adder fa3 (x[3], y[3], c2,   sum[3], sum[4]);

endmodule
