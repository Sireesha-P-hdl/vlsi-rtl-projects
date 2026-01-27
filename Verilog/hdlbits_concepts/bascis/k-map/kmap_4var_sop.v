//  4-variable Karnaugh Map
//         ab
//        00  01  11  10
//       +----------------+
//cd 00 |  1   1   0   1 |
//cd 01 |  1   0   0   1 |
//cd 11 |  0   1   1   1 |
//cd 10 |  1   1   0   0 |
//       +----------------+
// Simplified using Sum-of-Products (SOP) form

module top_module (
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

    assign out = (~b & ~c) |   // Group 1
                 (~a & ~d) |   // Group 2
                 (a & ~b & d)|  // Group 3
                 (b & c & d);  // Group 4

endmodule

