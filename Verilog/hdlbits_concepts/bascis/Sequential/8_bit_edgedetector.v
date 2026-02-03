// =====================================================
// 8-bit Positive Edge Detector
// HDLBits Problem: Edgedetect
// =====================================================
//
// Detects 0→1 transition for each bit
// Output pulsed ONE CYCLE AFTER edge occurs
//
// Example: in[1] = 0→1 → pedge[1] = 1 (next cycle)
//
// =====================================================

module top_module (
    input clk,
    input [7:0] in,
    output [7:0] pedge
);

    reg [7:0] in_prev;  // Previous input value

    always @(posedge clk) begin
        in_prev <= in;              // Store previous input
        pedge   <= in & ~in_prev;   // pedge = 1 when in=1 AND prev=0
    end

endmodule
