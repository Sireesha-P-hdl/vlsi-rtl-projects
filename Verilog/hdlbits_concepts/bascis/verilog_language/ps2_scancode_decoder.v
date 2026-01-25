//------------------------------------------------------------------------------
// Module: ps2_scancode_decoder
// Description: Decodes PS/2 keyboard scancodes to detect arrow key presses.
// The module asserts one of the four outputs (left, down, right, up)
// based on the received 16-bit scancode value.
// <size>'<base><value> 16'he06b = <16>=1110 0000 0110 1011 ,<h>=hexadecimal,
//<e06b>=readable value
//------------------------------------------------------------------------------
module ps2_scancode_decoder (
    input  [15:0] scancode,
    output reg left,
    output reg down,
    output reg right,
    output reg up
);

    always @(*) begin
        // Default assignments to avoid latch inference
        left  = 1'b0;
        down  = 1'b0;
        right = 1'b0;
        up    = 1'b0;

        // Decode arrow key scancodes
        case (scancode)
            16'he06b: left  = 1'b1;  // Left arrow
            16'he072: down  = 1'b1;  // Down arrow
            16'he074: right = 1'b1;  // Right arrow
            16'he075: up    = 1'b1;  // Up arrow
            default: ;               // No arrow key pressed
        endcase
    end

endmodule
