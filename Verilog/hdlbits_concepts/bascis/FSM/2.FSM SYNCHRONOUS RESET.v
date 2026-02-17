// =================================================================
// HDLBits: Fsm1s - Simple FSM 1 (SYNCHRONOUS RESET VERSION)
// =================================================================
// SAME LOGIC as Fsm1 but SYNCHRONOUS RESET (reset only on clk edge)
// ONE-GLANCE LOGIC: in=0 TOGGLES, in=1 HOLDS, reset→B, out=1 in B
// ┌─────────────────────┐
// │ State │ in=0 │ in=1 │ out │
// ├───────┼──────┼──────┼─────┤
// │  A    │  B   │  A   │  0  │
// │  B    │  A   │  B   │  1  │
// └─────────────────────┘
// =================================================================

module top_module (
    input clk,
    input reset,        // SYNCHRONOUS reset → B (clk edge only!)
    input in,
    output out
);

    // State encoding (1-bit)
    parameter A = 0, B = 1;
    
    reg present_state, next_state;

    // ═══════════════════════════════════════════════
    // 1️⃣ NEXT-STATE LOGIC (COMBINATIONAL)
    // ═══════════════════════════════════════════════
    always @(*) begin
        case (present_state)
            A: next_state <= in ? A : B;  // Stay A / Toggle→B
            B: next_state <= in ? B : A;  // Stay B / Toggle→A
            default: next_state <= B;
        endcase
    end

    // ═══════════════════════════════════════════════
    // 2️⃣ STATE REGISTER (SEQUENTIAL + SYNC RESET)
    // ═══════════════════════════════════════════════
    always @(posedge clk) begin
        if (reset)
            present_state <= B;         // Reset→B ON CLOCK EDGE ONLY
        else
            present_state <= next_state;
    end

    // ═══════════════════════════════════════════════
    // 3️⃣ OUTPUT LOGIC (MOORE: state→out)
    // ═══════════════════════════════════════════════
    assign out = (present_state == B) ? 1 : 0;

endmodule
