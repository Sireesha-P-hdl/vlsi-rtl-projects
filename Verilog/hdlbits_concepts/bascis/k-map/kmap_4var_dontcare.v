
//  Karnaugh Map with don't-cares
// Implemented using simplified Sum-of-Products (SOP)
//  x1x2
//        00  01  11  10
//     +----------------+
//x3x4 |
//00   |  d   0   d   d |
//01   |  0   d   1   0 |
//11   |  1   1   d   d |
//10   |  1   1   0   d |
//     +----------------+


module top_module (
    input [4:1] x,
    output f
); 
    assign f = (~x[1] & x[3]) |
               (~x[2] & ~x[3] & ~x[4]) |
               (x[1] & ~x[2] & x[3] & ~x[4]) |
               (x[2] & x[3] & x[4]);
endmodule
