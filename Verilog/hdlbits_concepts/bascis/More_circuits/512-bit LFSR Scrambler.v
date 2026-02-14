// =================================================================
// 512-bit LFSR Scrambler/Descrambler (Self-Synchronizing)
// HDLBits: Advanced LFSR with parallel load
// =================================================================
//
// Architecture:
// - 512-bit register q[511:0]
// - load=1 → Parallel load data[511:0]
// - load=0 → LFSR shift + XOR scrambler operation
//
// Scrambling: Additive stream cipher style
// Each bit XORed with shifted version → scrambles/descramblers
// =================================================================

module top_module (
    input clk,
    input load,
    input [511:0] data,     // Parallel load input
    output [511:0] q        // LFSR state/output
);

    always @(posedge clk) begin
        if (load)
            q <= data;                      // Load external data
        else begin                                 // TWO simultaneous operations:
          q <= {1'b0, q[511:1]}  ^ {q[510:0], 1'b0};          // ️ RIGHT SHIFT (fill MSB=0)  // XOR shifted version
                       
        end
    end

endmodule
