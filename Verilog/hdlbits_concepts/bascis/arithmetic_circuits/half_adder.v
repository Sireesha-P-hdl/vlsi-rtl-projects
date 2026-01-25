// Half Adder
// Adds two 1-bit inputs and produces Sum and Carry outputs

module half_adder (
    input  a,
    input  b,
    output sum,
    output carry
);

    assign sum   = a ^ b;   // XOR for sum
    assign carry = a & b;   // AND for carry

endmodule
