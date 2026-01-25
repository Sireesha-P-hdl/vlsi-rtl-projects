//------------------------------------------------------------------------------
// Module: population_count_255bit
// Description: Counts the number of '1' bits in a 255-bit input vector.
// The output represents the population count of the input.
//------------------------------------------------------------------------------

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
