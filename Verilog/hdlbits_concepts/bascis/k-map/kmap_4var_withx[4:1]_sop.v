//  Karnaugh Map Simplification
// 4-variable logic function with don't-care conditions
// Simplified using Sum-of-Products (SOP) form
// f = Σ m(0,2,4,8,9,10,12,13)
// x1 = x[1] ,x2 = x[2] ,x3 = x[3] ,x4 = x[4]
// Columns → x[1], x[2] , Rows → x[3], x[4]

module top_module (
    input [4:1] x,
    output f
);
    assign f = (~x[2] & ~x[4]) |
               (x[3] & ~x[1]) |
               (x[3] & x[2] & x[4]);
endmodule
