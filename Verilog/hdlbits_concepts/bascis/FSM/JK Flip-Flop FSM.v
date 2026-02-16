// =================================================================
// HDLBits: JK Flip-Flop FSM (FIXED: Async Reset to OFF)
// Problem: Classic JK Flip-Flop as 2-state FSM  COMMENT FIXED
// DIAGRAM: OFF(0) ←j=0/k=1→ ON(1), Reset→OFF ✓
// =================================================================
//  ONE-GLANCE TRUTH TABLE (STANDARD JK):
// ┌─────────────────┐
// │ State │ j │ k │ Next │ out │
// ├───────┼───┼───┼──────┼─────┤  
// │ OFF   │ 0 │ X │ OFF  │  0  │ Hold/Reset
// │ OFF   │ 1 │ X │ ON   │  1  │ Set
// │ ON    │ X │ 0 │ ON   │  1  │ Hold
// │ ON    │ X │ 1 │ OFF  │  0  │ Reset
// └─────────────────┘
// =================================================================

module top_module (
    input clk,
    input areset,    // ASYNC reset → OFF (Q=0) ✓ FIXED
    input j,         // J input (Set)
    input k,         // K input (Reset)  
    output out       // Q output
);

    parameter OFF = 0, ON = 1;
    reg state, next_state;

    // ════════════════ 1. NEXT STATE LOGIC ════════════════
    always @(*) begin
        case (state)
            OFF: next_state = j ? ON : OFF;   // j=1→SET, j=0→HOLD
            ON:  next_state = k ? OFF : ON;   // k=1→RESET, k=0→HOLD
            default: next_state = OFF;
        endcase
    end

    // ════════════════ 2️. STATE REGISTER (ASYNC RESET→OFF) ════════════════
    always @(posedge clk, posedge areset) begin
        if (areset)
            state <= OFF;                  //  FIXED: Reset→OFF (Q=0)
        else
            state <= next_state;
    end

    // ════════════════ 3️. OUTPUT (MOORE) ════════════════
    assign out = (state == ON);                // out=1 when ON

endmodule
