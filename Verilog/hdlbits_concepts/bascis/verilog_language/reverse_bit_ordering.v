//------------------------------------------------------------------------------
// Module: top_module
// Description: Reverses the bit ordering of a 100-bit input vector [99:0].
// out[99] = in[0], out[98] = in[1], ..., out[0] = in[99].
// Uses combinational always block with for loop as hinted.
//------------------------------------------------------------------------------
module top_module( 
    input [99:0] in,
    output [99:0] out
);
   integer i;
    always @(*)begin
        for(i=0;i<=99;i++)
            out[i]=in[99-i]; 
    end   
endmodule
