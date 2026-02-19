// =================================================================
// HDLBits: JK Flip-Flop FSM (SYNCHRONOUS RESET → OFF)
// Problem: Standard JK FF behavior with sync reset to OFF (Q=0)
// Compare: jkff_reset_off.v (async version)
// =================================================================
//  JK FLIP-FLOP TRUTH TABLE (ONE-GLANCE):
// ┌─────────────────────┐
// │ Current │ j │ k │ Q+ │ out │
// ├─────────┼───┼───┼────┼─────┤
// │   0     │ 0 │ X │  0 │  0  │ Reset/Hold
// │   0     │ 1 │ X │  1 │  1  │ Set (j=1→ON)
// │   1     │ X │ 0 │  1 │  1  │ Hold  
// │   1     │ X │ 1 │  0 │  0  │ Reset (k=1→OFF)
// └─────────────────────┘
// Reset: sync→OFF | out=state (1-bit direct)
// =================================================================

module top_module (
    input clk,
    input reset,        // SYNCHRONOUS reset → OFF (only on clock edge)
    input j,            // J input (Set)
    input k,            // K input (Reset)
    output out          // Q output (direct from state)
);

    parameter OFF = 1'b0, ON = 1'b1;
    reg state, next_state;

    // ════════════════ 1️ NEXT-STATE LOGIC (COMBINATIONAL) ════════════════
    always @(*) begin
        case (state)
            OFF: next_state = j ? ON : OFF;   // j=1→SET(ON), else HOLD
            ON:  next_state = k ? OFF : ON;   // k=1→RESET(OFF), else HOLD
            default: next_state = OFF;
        endcase
    end

    // ════════════════ 2️ STATE REGISTER (SYNC RESET) ════════════════
    always @(posedge clk) begin
        if (reset)
            state <= OFF;                  // Reset→OFF on clock edge ONLY
        else
            state <= next_state;
    end

    // ════════════════ 3️ OUTPUT (DIRECT WIRED) ════════════════
    assign out = state;                    // out = Q = state (1 when ON)

endmodule
