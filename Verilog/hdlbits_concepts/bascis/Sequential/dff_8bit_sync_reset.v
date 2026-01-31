// ============================================================
// Sequential Logic
// Problem: 8-bit D Flip-Flop with Synchronous Reset
// Question:
// Implement an 8-bit D flip-flop.
// - The flip-flop updates its output `q` on the rising edge of `clk`.
// - If `reset` is asserted (1), the output must be cleared to 0.
// - Reset is synchronous (checked only on clock edge).
// ============================================================

module top_module (
    input clk,
    input reset,            // Synchronous reset
    input [7:0] d,
    output reg [7:0] q
);

    always @(posedge clk) begin
        if (reset)
            q <= 8'b0;      // Reset clears all flip-flops
        else
            q <= d;         // Load input data
    end

endmodule
