//------------------------------------------------------------------------------
// HDLBits Practice: Toggle Flip-Flop   
//        ┌──────────────┐
// clk ───┤              ├────┐
//        │   DFF    q───┴───► out
//        │              │
//        │     ┌──┐     │
// in ────┼───►XOR◄──┘
//        └──────┘
//------------------------------------------------------------------------------

module top_module (
    input clk,   // Clock input
    input in,    // Toggle enable input
    output out   // Toggle FF output
);

    always @(posedge clk) begin
        if (in)
            out <= in^out;    
    end

endmodule

