//------------------------------------------------------------------------------
// HDLBits Practice: Byte-Enabled 16 D Flip-Flops
//------------------------------------------------------------------------------

module top_module (
    input clk,
    input resetn,           // Active-LOW synchronous reset
    input [1:0] byteena,    // [1]=upper byte, [0]=lower byte enable
    input [15:0] d,         // Data input
    output reg [15:0] q     // 16 DFF register output
);

    always @(posedge clk) begin
        if (!resetn) begin
            q <= 16'b0;             // Reset all to 0
        end else begin
            // Byte-selective write
            if (byteena[0])         // Lower byte enable
                q[7:0] <= d[7:0];
            if (byteena[1])         // Upper byte enable
                q[15:8] <= d[15:8];
            // Disabled bytes retain previous value
        end
    end

endmodule
