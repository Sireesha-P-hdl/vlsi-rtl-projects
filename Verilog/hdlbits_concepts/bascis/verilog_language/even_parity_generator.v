//------------------------------------------------------------------------------
// Module: even_parity_generator
// Description: Generates an even parity bit for an 8-bit input data word.
// The parity bit is computed as the XOR of all input bits.
//------------------------------------------------------------------------------
module even_parity_generator (
    input  [7:0] in,
    output       parity
);

    // Reduction XOR operator computes even parity
    assign parity = ^in;

endmodule
