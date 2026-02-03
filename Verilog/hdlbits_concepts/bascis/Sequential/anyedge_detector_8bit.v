// =====================================================
// 8-bit ANY Edge Detector (Rising + Falling)
// HDLBits Problem: anyedge detection
// =====================================================
//
// Detects ANY change (0→1 OR 1→0) for each bit in 8-bit vector
// Output pulsed ONE CYCLE AFTER edge occurs
//
// Truth table for XOR detection:
// in | prev | anyedge = in ^ prev
// ----|------|-------------------
//  0 |  0   |       0          (No change)  
//  0 |  1   |       1          (1→0 FALLING)
//  1 |  0   |       1          (0→1 RISING) 
//  1 |  1   |       0          (No change)
//
// =====================================================

module top_module (
    input clk,
    input [7:0] in,
    output [7:0] anyedge
);

    reg [7:0] in_prev;  // Previous input value (DFF feedback)
    
    always @(posedge clk) begin
        in_prev <= in;              // 1️ Shift register: store previous input
        anyedge <= in ^ in_prev;    // 2️ XOR: detect ANY bit flip (both edges)
    end

endmodule
