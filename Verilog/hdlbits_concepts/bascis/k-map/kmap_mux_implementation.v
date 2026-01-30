// ------------------------------------------------------------
// Module: kmap_mux_implementation
// Description:
// ------------------------------------------------------------
// Question:
// Given the following 4-variable Karnaugh map for the Boolean
// function f(a, b, c, d), implement the circuit using:
//
// 1) Exactly one 4-to-1 multiplexer
// 2) No logic gates other than multiplexers
// 3) a and b must be used as the select lines of the MUX
//
// You are required to implement ONLY the portion labeled
// `top_module`, which generates the four data inputs to the
// 4-to-1 multiplexer.
//
// The Karnaugh map is arranged as follows:
//
//   Columns (select lines ab): 00, 01, 11, 10
//   Rows    (inputs cd)      : 00, 01, 11, 10
//
// Karnaugh Map Values:
//
//        ab
//        00  01  11  10
// cd  +----------------
// 00  |  0   0   0   1
// 01  |  1   0   0   0
// 11  |  1   0   1   0
// 10  |  1   0   0   1
//
// The output of the 4-to-1 multiplexer is f(a,b,c,d).
// Each mux input must be expressed using only c and d.

// ------------------------------------------------------------

module kmap_mux_implementation (
    input  c,
    input  d,
    output [3:0] mux_in
);

    // Column ab = 00
    assign mux_in[0] = c | d;

    // Column ab = 01
    assign mux_in[1] = 1'b0;

    // Column ab = 10
    assign mux_in[2] = ~d;

    // Column ab = 11
    assign mux_in[3] = c & d;

endmodule
