// =====================================================
// 32-bit Negative Edge Detector with SR Flip-Flop
// HDLBits Problem: Negative edge capture with sync reset
// =====================================================
//
// Detects 1→0 transitions on each bit of 32-bit vector
// Output STAYS HIGH until synchronous RESET
// Reset has PRECEDENCE over set event
//
// SR Flip-Flop behavior per bit:
// set_condition = ~in & in_prev  (1→0 transition)
// out = set_condition | (out & ~reset)
//
// =====================================================

module top_module (
    input clk,
    input reset,
    input [31:0] in,
    output [31:0] out
);

    reg [31:0] in_prev;
    
    always @(posedge clk) begin
        if (reset) begin
            out <= 32'b0;           // Synchronous reset CLEAR
            in_prev <= in;          // Update history even during reset
        end else begin
            in_prev <= in;          // Store previous input
            out <= (~in & in_prev) | out;  // SET on 1→0 OR hold previous
        end
    end

endmodule
