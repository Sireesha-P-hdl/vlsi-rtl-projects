// =================================================================
// Rule 110 Cellular Automaton (512-bit, Turing Complete!)
// HDLBits: Rule110 - 512-cell 1D CA with zero boundaries
// =================================================================
//
// Rule 110 Truth Table: 01101110 (Next = Left XOR Center XOR Right)
// load=1 → Parallel load data[511:0]
// load=0 → ALL 512 cells evolve simultaneously per Rule 110
// Boundaries: q[-1]=0, q[512]=0 (fixed OFF)
// =================================================================

module top_module (
    input clk,
    input load,
    input [511:0] data,
    output [511:0] q
); 
    always @(posedge clk) begin 
        if (load) begin
            q <= data;                              // Load initial pattern
        end
        else begin
            // GENIUS 1-LINER Rule 110 Implementation!
            q <= (((q[511:0] ^ {q[510:0], 1'b0}) & q[511:1]) | 
                  ((q[511:0] | {q[510:0], 1'b0}) & (~q[511:1])));
        end
    end
endmodule
