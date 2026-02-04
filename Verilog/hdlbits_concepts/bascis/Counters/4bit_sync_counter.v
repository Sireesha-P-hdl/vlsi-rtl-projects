// =====================================================
// 4-bit Synchronous Binary Counter (0-15)
// HDLBits: Counter - Synchronous active-high reset
// =====================================================
//
// Counts: 0000 → 0001 → ... → 1111 → 0000 (16 states)
// reset=1 → q=0000 (synchronous, active HIGH)
// Natural 4-bit overflow back to 0
//
// Verified waveform: reset effect ON clock edge
// =====================================================

module top_module (
    input clk,
    input reset,        // Synchronous active-high reset
    output [3:0] q
);
    
    always @(posedge clk) begin
        if (reset)
            q <= 4'b0;      // Reset to 0 on posedge clk when reset=1
        else
            q <= q + 1;     // Increment (auto-wraps 1111→0000)
    end

endmodule
