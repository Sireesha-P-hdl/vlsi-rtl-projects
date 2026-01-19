//------------------------------------------------------------------------------
// Module: mod_a
// Description: A simple module with 2 outputs and 4 inputs.
// This module can contain logic if needed, but for this problem, it serves
// as a placeholder to demonstrate port connections by position.
//------------------------------------------------------------------------------
module mod_a (
    output y1,   // First output
    output y2,   // Second output
    input  a,    // First input
    input  b,    // Second input
    input  c,    // Third input
    input  d     // Fourth input
);
    // Logic can be added here if needed
endmodule


//------------------------------------------------------------------------------
// Module: top_module
// Description: Top-level module that instantiates mod_a
// Connections are made by position as required by the problem.
//------------------------------------------------------------------------------
module top_module ( 
    input  a, 
    input  b, 
    input  c,
    input  d,
    output out1,
    output out2
);

    // Instantiate mod_a with **position-based connections**
    // Order: out1 -> y1, out2 -> y2, a -> a, b -> b, c -> c, d -> d
    mod_a instance1 (out1, out2, a, b, c, d);

endmodule

