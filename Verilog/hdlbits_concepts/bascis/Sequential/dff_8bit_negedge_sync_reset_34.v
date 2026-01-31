// ============================================================
//  Sequential Logic
// Problem: 8-bit D Flip-Flop (Negative-Edge Triggered) 
//          with Synchronous Reset to a Fixed Value
// Question:
// Implement an 8-bit D flip-flop with the following behavior:
// - The flip-flop updates its output `q` on the **falling edge**
//   of the clock (`negedge clk`).
// - The reset is **synchronous**.
// - When `reset` is asserted, the output must be set to **8'h34**.
// - Otherwise, the flip-flop loads the input `d`.
//| Prefix | Meaning     | Base |
//| ------ | ----------- | ---- |
//| `0b`   | Binary      | 2    |
//| `0o`   | Octal       | 8    |
//| `0d`   | Decimal     | 10   |
//| `0x`   | Hexadecimal | 16   |
// ============================================================

module top_module (
    input clk,
    input reset,            // Synchronous reset
    input [7:0] d,
    output reg [7:0] q
);

    always @(negedge clk) begin
        if (reset)
            q <= 8'h34;     // Reset to fixed value 0x34
        else
            q <= d;         // Normal operation
    end

endmodule
