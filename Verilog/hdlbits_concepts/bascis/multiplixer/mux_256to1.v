//“How did you implement a 256:1 mux efficiently?”
//“Using vector indexing: assign out = in[sel]; instead of large case statements.”
// HDLBits: 256-to-1 Multiplexer
// Concept: Vector indexing using a variable select

module top_module( 
    input  [255:0] in,
    input  [7:0]   sel,
    output         out
);

    // Select one bit from the input vector based on sel
    assign out = in[sel];

endmodule
