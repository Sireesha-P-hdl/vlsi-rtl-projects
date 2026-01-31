// ============================================================
// HDLBits – Sequential Logic
// Problem: 8-bit D Flip-Flop with Asynchronous Reset
// Question:
// Implement an 8-bit D flip-flop with the following behavior:
// - The flip-flop updates its output `q` on the **rising edge**
//   of the clock (`posedge clk`).
// - The reset signal `areset` is **active-high and asynchronous**.
// - When `areset` is asserted, the output `q` must be reset to **0**,
//   regardless of the clock.
// - Otherwise, on each rising clock edge, `q` loads the input `d`.

// ============================================================

module top_module (
    input clk,
    input areset,   // active high asynchronous reset
    input [7:0] d,
    output reg [7:0] q
);

    always @(posedge clk or posedge areset) begin
        if (areset)
            q <= 8'd0;     // Asynchronous reset
        else
            q <= d;        // Load data on rising clock edge
    end

endmodule
