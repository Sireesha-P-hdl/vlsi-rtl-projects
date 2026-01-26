//-----------------------------------------------------------------------------------------------------------------
// 100-bit Binary Adder with Carry-in and Carry-out
// Concept: Vector addition with concatenation
//a + b + cin produces a 101-bit result
//{cout, sum} is 101 bits wide
//MSB → cout
//Lower 100 bits → sum

module top_module( 
    input  [99:0] a, b,
    input         cin,
    output        cout,
    output [99:0] sum
);

  assign {cout, sum} = a + b + cin;// cout ->1bit sum->100bits then MSB->1bit for cout remaining 100->bits for sum of(a+b)

endmodule
