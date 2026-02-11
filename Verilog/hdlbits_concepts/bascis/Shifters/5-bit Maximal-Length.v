// =================================================================
// 5-bit Maximal-Length Galois LFSR (31 states)
// HDLBits: LFSR5 - Taps at positions 5 and 3
// =================================================================
//
// Polynomial: x^5 + x^3 + 1 (taps at bit 5,3)
// Reset: 00001 (5'h1)
// Sequence starts: 00001 → 10100 → 01010 → 00101 → ... (31 states)
// Galois structure: feedback XORed into tapped positions
// =================================================================

module top_module (
    input clk,
    input reset,        // Sync active-high reset → 00001
    output [4:0] q
); 

    always @(posedge clk) begin
        if (reset)
            q <= 5'h1;              // Reset to 00001
        else begin
            q[4] <= q[0];           // Bit4 = shifted from bit0 (feedback path)
            q[3] <= q[4] ^ q[0];    // Bit3 = shift + XOR tap (pos3 tap)
            q[2] <= q[3];           // Bit2 = plain shift
            q[1] <= q[2];           // Bit1 = plain shift  
            q[0] <= q[1];           // Bit0 = plain shift
        end 
    end

endmodule
