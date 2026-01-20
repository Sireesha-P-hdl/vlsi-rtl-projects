//---------------------------------------------------------------------------------------------------------
// Module: minimum_of_four
// Description: Finds the minimum value among four 8-bit unsigned inputs
// using Verilog conditional (ternary) operators. there are no inbulit function or keyword as min to use
//-----------------------------------------------------------------------------------------------------------
module minimum_of_four (
    input  [7:0] a,
    input  [7:0] b,
    input  [7:0] c,
    input  [7:0] d,
    output [7:0] min
);

    // Intermediate minimum values
    wire [7:0] min_1;
    wire [7:0] min_2;

    // Two-way minimum comparisons
    assign min_1 = (a < b) ? a : b;
    assign min_2 = (c < d) ? c : d;

    // Final minimum value
    assign min = (min_1 < min_2) ? min_1 : min_2;

endmodule
