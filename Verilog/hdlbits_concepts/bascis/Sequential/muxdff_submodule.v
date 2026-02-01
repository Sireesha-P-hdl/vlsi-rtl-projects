//------------------------------------------------------------------------------
// HDLBits: Mt2015_muxdff (ECE253 2015 Midterm Q5)
//------------------------------------------------------------------------------

/*
Taken from ECE253 2015 midterm question 5
Consider the sequential circuit below:

[Diagram: 3-stage chain of MUX+DFF]
   L ─┬──┐ r0 ─┐     ┌──┐ r1 ─┐     ┌──┐ r2 ─┐
      │MUX├────┐    │MUX├────┐    │MUX├────┐
Q0────┘     │    │Q1────┘    │    │Q2────┘
            │    │            │    │
clk ────────┼───D├────────────┼───D├────────┼───D
            │   │             │   │         │
            └─Q─┘             └─Q─┘         └─Q─┘
             │                 │               │
            Q0                Q1              Q2

Assume hierarchical Verilog: 3 instantiations of MUX+DFF submodule
*/

module top_module (
    input clk,
    input L,      // MUX select (Load/hold)
    input r_in,   // MUX input 1 (load value)  
    input q_in,   // MUX input 0 (feedback/hold)
    output reg Q  // DFF output
);

    wire mux_out;
    
    // 2:1 MUX - L selects r_in or q_in
    assign mux_out = L ? r_in : q_in;
    
    // D Flip-Flop
    always @(posedge clk)
        Q <= mux_out;

endmodule
