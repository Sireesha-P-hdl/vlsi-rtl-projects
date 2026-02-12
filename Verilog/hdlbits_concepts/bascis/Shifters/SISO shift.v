// =================================================================
// Serial-to-Parallel Converter (4-bit Shift Register)
// HDLBits  Detect specific 4-bit sequence
// =================================================================
//
// Functionality:
// - 4-bit shift register: in → LSB → shift left → MSB → out
// - resetn=0 → Clear to 0000 (active LOW synchronous reset)
// - out = MSB (out_temp[3]) - pulses when pattern matches
//
// Diagram (Exams_m2014q4k.png): Serial input → 4-bit SISO shift → out
// Typical use: Pattern detection (ex: detect "1101" sequence)
//
// Sequence example: ...1011 1101 → out pulses high for 1 cycle
// Before shift: [3][2][1][0]
 //After shift:  [2][1][0] │ in
// Bit 3 (MSB) shifts OUT → becomes out
// =================================================================

module top_module (
    input clk,
    input resetn,       // Active-LOW synchronous reset
    input in,           // Serial input (LSB first)
    output out          // Parallel output (MSB after 4 shifts)
);

    reg [3:0] out_temp;
    
    always @(posedge clk) begin
        if (resetn == 1'b0)             // Active LOW reset
            out_temp <= 4'd0;           // Clear shift register
        else
            out_temp <= {out_temp[2:0], in};  // Shift LEFT: in → [0], MSB → out
    end 
    
    assign out = out_temp[3];           // Output = MSB (4th bit delayed)

endmodule
