//------------------------------------------------------------------------------
// HDLBits Practice: D Flip-Flop with Synchronous Reset
//------------------------------------------------------------------------------

module top_module (
    input clk,   // Clock input
    input d,     // Data input
    input r,     // Synchronous reset (active HIGH)
    output q     // Flip-flop output
);

    always @(posedge clk) begin
        if (r)
            q <= 1'b0;   // Reset to 0 when r=1
        else
            q <= d;      // Normal DFF operation
    end

endmodule
