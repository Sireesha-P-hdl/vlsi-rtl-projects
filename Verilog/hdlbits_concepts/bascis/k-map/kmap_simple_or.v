//--------------------------------------------------------------------------------------------------     
// K-map Simplification
//     a   0     1
//      +-----+-----+
//bc 00 |  0  |  1  |
//      +-----+-----+
//bc 01 |  1  |  1  |
//      +-----+-----+
//bc 11 |  1  |  1  |
//      +-----+-----+
//bc 10 |  1  |  1  |
//      +-----+-----+
// Simplified result: out = a + b + c

module top_module(
    input  a,
    input  b,
    input  c,
    output out
);

    assign out = a | b | c;

endmodule
