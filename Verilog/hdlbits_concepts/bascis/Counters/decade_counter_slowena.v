// =====================================================
// 4-bit Decade Counter (0-9) with Enable & Sync Reset
// HDLBits: Decade counter with slowena control
// =====================================================
//
// Counts: 0→1→2→...→9→0 (period 10) when slowena=1
// Holds value when slowena=0
// reset=1 → q=0 (synchronous active HIGH)
// =====================================================

module top_module (
    input clk,
    input slowena,
    input reset,
    output [3:0] q);
    
    always @(posedge clk) begin
        if (reset )  
            q <= 4'd0;              
        else if(q==9&&slowena)
            q <= 0;
       else if (slowena)
            q <= q + 1;  
    end
    
endmodule

