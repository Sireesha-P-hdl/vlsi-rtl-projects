// 4-variable Karnaugh Map
/*
              ab
          00   01   11   10
        +--------------------+  
cd  00  |  0    1    0    1  |
cd  01  |  1    0    1    0  |
cd  11  |  0    1    0    1  |
cd  10  |  1    0    1    0  |
        +--------------------+
*/
//(~a & ~b & ~c &  d) |(~a & ~b &  c & ~d) |(~a &  b & ~c & ~d) |(~a &  b &  c &  d) |( a & ~b & ~c & ~d) |( a & ~b &  c &  d) |( a &  b & ~c &  d) |( a &  b &  c & ~d);
// Simplified to XOR (odd parity) logic

module top_module(
    input a,
    input b,
    input c,
    input d,
    output out
);
    assign out = a ^ b ^ c ^ d;
endmodule
