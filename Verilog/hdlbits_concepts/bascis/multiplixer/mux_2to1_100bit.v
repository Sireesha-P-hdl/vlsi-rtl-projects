// HDLBits: 100-bit wide 2-to-1 Multiplexer
// Concept: Ternary (conditional) operator

module top_module( 
    input  [99:0] a, b,
    input         sel,
    output [99:0] out
);

    assign out = sel ? b : a;

endmodule
