// =================================================================
// 32-bit Maximal-Length Galois LFSR (2^32-1 states)
// HDLBits Exam: 32-bit LFSR with taps at specific positions
// =================================================================
//
// Polynomial taps (from assignments):
// - Bit 21: q[0] ^ q[22] 
// - Bit 1:  q[0] ^ q[2]
// - Bit 0:  q[0] ^ q[1]
// - All others: pure shift {q[0], q[31:1]}
//
// Reset: 32'h00000001 (all zeros except LSB=1)
// Shift direction: RIGHT (LSB feedback → MSB)
// =================================================================

module top_module (
    input clk,
    input reset,        // Sync active-high reset → 32'h1
    output [31:0] q
);

    reg [31:0] q_next;
    
    // Combinational next-state logic
    always @(*) begin
        q_next = {q[0], q[31:1]};           // Base right shift (LSB → MSB)
        
        // XOR taps (Galois LFSR feedback injection)
        q_next[21] = q[0] ^ q[22];          // Tap at bit 21
        q_next[1]  = q[0] ^ q[2];           // Tap at bit 1  
        q_next[0]  = q[0] ^ q[1];           // Tap at bit 0 (LSB)
    end

    // Sequential state register
    always @(posedge clk) begin
        if (reset)
            q <= 32'd1;                     // Reset to 000...0001
        else 
            q <= q_next;                    // Update from combinational logic
    end

endmodule
