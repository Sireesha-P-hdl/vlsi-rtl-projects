//------------------------------------------------------------------------------
// 3-bit Ripple Carry Adder using Full Adder modules
// Demonstrates hierarchical design with module instantiation
// first u need define the fulladder then in ripple carry adder add the full adder
//------------------------------------------------------------------------------

// 1-bit Full Adder submodule
module full_adder (
    input  a,    // First input bit
    input  b,    // Second input bit  
    input  cin,  // Carry-in
    output sum,  // Sum output
    output cout  // Carry-out
);
    assign sum  = a ^ b ^ cin;           // Sum = XOR of all 3 inputs
    assign cout = (a & b) | (a & cin) | (b & cin);  // Majority function for carry
endmodule

// 3-bit Ripple Carry Adder (top module)
module top_module( 
    input  [2:0] a, b,    // 3-bit inputs
    input        cin,     // Overall carry-in
    output [2:0] cout,    // Individual carry-outs (cout[0] feeds next stage)
    output [2:0] sum      // 3-bit sum output
);
    // Ripple carry chain: cout[0] → cin[1], cout[1] → cin[2]
    full_adder fa0 (a[0], b[0], cin,   sum[0], cout[0]);
    full_adder fa1 (a[1], b[1], cout[0], sum[1], cout[1]);
    full_adder fa2 (a[2], b[2], cout[1], sum[2], cout[2]);

endmodule
