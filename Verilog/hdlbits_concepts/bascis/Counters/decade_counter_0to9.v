// =====================================================
// 4-bit Decade Counter (0-9, period 10)
// HDLBits: Decade counter - Synchronous active-high reset
// =====================================================
//
// Counts: 0000 → 0001 → ... → 1001 → 0000 (10 states)
// reset=1 → q=0000 (synchronous, active HIGH)
// q==9 → Reset to 0 (decade rollover)
//
// Verified waveform: 0,1,2,3,4,5,6,7,8,9,0,1...
// =====================================================

module top_module (
    input clk,
    input reset,        // Synchronous active-high reset
    output [3:0] q
);
    
    always @(posedge clk) begin
        if (reset || q==9)    // Reset OR reached 9
            q <= 0;             // Go to 0
        else
            q <= q + 1;            // Normal increment
    end

endmodule
