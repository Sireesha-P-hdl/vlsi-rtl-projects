// =================================================================
// 3-bit Universal Shift Register (USR)
// FPGA Implementation: SW[2:0] inputs, KEY[1:0] controls
// =================================================================
//
// Inputs:
// - SW[2:0]: Parallel data input / Serial right input
// - KEY[0]: Clock (posedge triggered) 
// - KEY[1]: Load enable (1=parallel load, 0=shift)
//
// Outputs: 
// - LEDR[2:0]: Shift register state (Q)
//
// Shift Operations (KEY[1]=0):
// R = Right shift:  SW[0]→Q[2]→Q[1]→Q[0] 
// L = Left shift? Wait - code analysis shows ROTATE!
//
// =================================================================

module top_module (
    input [2:0] SW,     // SW[0]=serial right, SW[1:2]=parallel data
    input [1:0] KEY,    // KEY[0]=clk, KEY[1]=load/shift control
    output [2:0] LEDR   // Register state
);

    wire temp;
    assign temp = LEDR[1] ^ LEDR[2];  // Feedback logic for bit2
    
    always @(posedge KEY[0]) begin     // Posedge clock (KEY[0])
        LEDR[0] <= (KEY[1]) ? SW[0] : LEDR[2];  // Load SW[0] OR shift from Q[2]
        LEDR[1] <= (KEY[1]) ? SW[1] : LEDR[0];  // Load SW[1] OR shift from Q[0]  
        LEDR[2] <= (KEY[1]) ? SW[2] : temp;     // Load SW[2] OR computed feedback
    end

endmodule
