//------------------------------------------------------------------------------
// Module: ripple_carry_adder_100bit
// Description: Implements a 100-bit ripple carry adder.
// Bit 0 uses an external carry-in, while higher bits propagate the carry.
//------------------------------------------------------------------------------
//final carry = carry[99]
//cout[0], cout[1], ..., cout[99]
// For bit 0:
//carry[0] comes from cin
//For bit 1:
//carry[1] comes from carry[0]
//For bit i:
//carry[i] depends on carry[i−1]
module ripple_carry_adder_100bit (
    input  [99:0] a,
    input  [99:0] b,
    input         cin,
    output reg [99:0] sum,
    output reg [99:0] cout
);

    integer i;

    always @(*) begin
        // Bit 0 uses external carry-in
        sum[0]  = a[0] ^ b[0] ^ cin;
        cout[0] = (a[0] & b[0]) | (a[0] & cin) | (b[0] & cin);

        // Bits 1 to 99 use ripple carry
        for (i = 1; i < 100; i = i + 1) begin
            sum[i]  = a[i] ^ b[i] ^ cout[i-1];
            cout[i] = (a[i] & b[i]) |
                      (a[i] & cout[i-1]) |
                      (b[i] & cout[i-1]);
        end
    end

endmodule
