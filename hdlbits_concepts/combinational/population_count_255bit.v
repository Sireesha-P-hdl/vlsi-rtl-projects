//------------------------------------------------------------------------------
// Module: population_count_255bit
// Description: Counts the number of '1' bits in a 255-bit input vector.
// The output represents the population count of the input.
//------------------------------------------------------------------------------
//final carry = carry[99]
//cout[0], cout[1], ..., cout[99]
// For bit 0:
//carry[0] comes from cin
//For bit 1:
//carry[1] comes from carry[0]
//For bit i:
//carry[i] depends on carry[i−1]
module population_count_255bit (
    input  [254:0] in,
    output reg [7:0] out
);

    integer i;

    always @(*) 
      begin
            count=0;
            for(i=0;i<=254;i++)
                count=count+in[i];
        end
    assign out=count;
endmodule
