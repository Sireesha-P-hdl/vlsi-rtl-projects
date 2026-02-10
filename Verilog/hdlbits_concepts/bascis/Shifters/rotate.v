/*
Build a 100-bit left/right rotator with synchronous load.

- load = 1 : load data[99:0] into q
- ena[1:0]:
    2'b01 : rotate right by 1 bit
    2'b10 : rotate left by 1 bit
    2'b00, 2'b11 : no rotation
- Rotation means the shifted-out bit re-enters from the other end.
load  >  ena  >  hold
Before:
q = [ b99  b98  b97 ... b1  b0 ]

After rotate-left:
q = [ b98  b97 ... b1  b0  b99 ]
{ q[98:0], q[99] }
↓
b98 b97 ... b1 b0 b99

*/
module top_module(
    input clk,
    input load,
    input [1:0] ena,
    input [99:0] data,
    output reg [99:0] q
);

    always @(posedge clk) begin
        if (load)
            q <= data;
        else begin
            case (ena)
                2'b01: q <= {q[0],   q[99:1]};   // rotate right
                2'b10: q <= {q[98:0], q[99]};    // rotate left
                default: q <= q;                // no rotation
            endcase
        end
    end

endmodule
