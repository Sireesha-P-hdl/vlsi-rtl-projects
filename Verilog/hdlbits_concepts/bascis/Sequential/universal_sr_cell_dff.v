//------------------------------------------------------------------------------
// HDLBits:- N-bit Shift Register Stage
//------------------------------------------------------------------------------

/*
Consider the n-bit shift register circuit shown below:
[Diagram: w ─┬──┐ R ─┐
            │MUX├─┐E┬──┐ Q ─►
            │MUX├─┘ │MUX│
clk ─────┐ │ │     └─Q─┘
         │ └─┘
         └─D

Controls:
- L=1: Load R → Q <= R
- L=0,E=1: Shift w → Q <= w  
- L=0,E=0: Hold Q <= Q
*/

module top_module (
    input clk,
    input w, R, E, L,
    output Q
);

    wire mux_E, mux_L;
    
    // MUX1: E selects between w and Q (feedback)
    assign mux_E = E ? w : Q;
    
    // MUX2: L selects between R and mux_E  
    assign mux_L = L ? R : mux_E;
    
    // D Flip-Flop
    always @(posedge clk)
        Q <= mux_L;

endmodule
