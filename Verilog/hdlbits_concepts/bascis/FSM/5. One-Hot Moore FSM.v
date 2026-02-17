// =================================================================
// HDLBits: One-Hot Moore FSM (4-State "By Inspection" Equations)
// Problem: https://hdlbits.01xz.net/wiki/One-hot_moore
// Key: Derive LOGIC EQUATIONS manually (NO case statements!)
// =================================================================
//  ONE-HOT ENCODING (4 bits, exactly one '1'):
// State │ Binary    │ Active Bit
// ──────┼───────────┼──────────
//   A   │ 0001      │ state[0]
//   B   │ 0010      │ state[1]  
//   C   │ 0100      │ state[2]
//   D   │ 1000      │ state[3]
// =================================================================
// TRANSITION TABLE:
// State │ in=0 │ in=1 │ out
// ──────┼──────┼──────┼────
//   A   │  A   │  B   │ 0
//   B   │  C   │  B   │ 0  
//   C   │  A   │  D   │ 0
//   D   │  C   │  B   │ 1◄─ Output!
// =================================================================
// EQUATIONS BY INSPECTION (trace incoming arrows):
// next_state[0](A) ← A(in=0)+C(in=0)  → (s0·~in)+(s2·~in)
// next_state[1](B) ← A(in=1)+B(in=1)+D(in=1) → (s0·in)+s1+(s3·in)  
// next_state[2](C) ← B(in=0)+D(in=0)  → (s1·~in)+(s3·~in)
// next_state[3](D) ← C(in=1)          → s2·in
// =================================================================

module top_module (
    input in,
    input [3:0] state,       // Current one-hot state (4-bit)
    output [3:0] next_state, // Next one-hot state
    output out               // Moore output
);

    // State bit indices (one-hot positions)
    localparam A = 0, B = 1, C = 2, D = 3;

    // ════════════════ NEXT-STATE EQUATIONS (BY INSPECTION) ════════════════
    assign next_state[A] = (state[A] & ~in) | (state[C] & ~in);  // A←A(0)+C(0)
    assign next_state[B] = (state[A] &  in) |  state[B]        | (state[D] &  in);  // B←A(1)+B(1)+D(1)
    assign next_state[C] = (state[B] & ~in) | (state[D] & ~in);  // C←B(0)+D(0)
    assign next_state[D] = (state[C] &  in);                     // D←C(1)

    // ════════════════ OUTPUT LOGIC (MOORE) ════════════════
    assign out = state[D];  // out=1 only when in state D

endmodule
