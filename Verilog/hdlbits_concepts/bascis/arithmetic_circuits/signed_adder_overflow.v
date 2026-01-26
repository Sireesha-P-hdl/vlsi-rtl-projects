//---------------------------------------------------------------------------------------------------------------
// Signed 8-bit Adder with Overflow Detection
// Concept: Two's complement signed overflow
//Description...
// overflow is about the sign becoming wrong.// Safe cases (NO overflow):1.Positive + Negative 2.Negative + Positive
// a =  50  (0xxxxxxx)
//b =  80  (0xxxxxxx)
//s = -126 (1xxxxxxx)  ← WRONG sign
//-------------------------------------------------------------------------------------------------------------------
module top_module (
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] s,
    output       overflow
);

    // Sum of two 8-bit signed numbers
    assign s = a + b;

    // Overflow occurs when:
    //  a and b have the same sign
    // sum has a different sign
  assign overflow = (a[7] == b[7]) && (s[7] != a[7]); //sign bit occurs at MSB so its bit [7]...

endmodule
