// =================================================================
// 8x1 LUT Memory (Shift Register + 3:8 Decoder MUX)
// HDLBits: LUT - 8-bit shift register RAM with random access read
// =================================================================
//
// Architecture:
// 8 DFFs ← S (serial write, MSB first)
// ABC[2:0] → 3-bit address → MUX selects Q[i] → Z
// enable=1 → Shift left (S→Q[7]→Q[6]...Q[0])
// enable=0 → Hold values
// =================================================================

module top_module (
    input clk,
    input enable,
    input S,            // Serial input (MSB first)
    input A, B, C,      // 3-bit address [2:0]
    output Z            // Random access output
); 

    reg [7:0] d_ff;     // 8-bit shift register (Q[7:0])
    
    always @(posedge clk) begin
        if (enable)
            d_ff <= {d_ff[6:0], S};    // Shift LEFT: S enters LSB
        // else: hold (implicit)
    end 
    
    assign Z = d_ff[{A, B, C}];        // 3:8 MUX decode: ABC→Q[i]

endmodule
