// =====================================================
// 4-bit Decade Counter (1-10, period 10) 
// HDLBits: Decade counter 1-10 - Synchronous reset to 1
// =====================================================
//
// Counts: 0001 → 0002 → ... → 1010 → 0001 (10 states)
// reset=1 → q=0001 (synchronous, active HIGH)
// q==4'd10 → Reset to 0001 (decade rollover)
//
// Verified waveform: 1,2,3,4,5,6,7,8,9,10,1,2...
// =====================================================

module top_module (
    input clk,
    input reset,
    output [3:0] q
);
    
    always @(posedge clk) begin
        if (reset || q == 10)   // Reset OR reached 10
            q <= 4'b0001;             // Go to 1 (not 0!)
        else
            q <= q + 1;            // Normal increment
    end

endmodule
