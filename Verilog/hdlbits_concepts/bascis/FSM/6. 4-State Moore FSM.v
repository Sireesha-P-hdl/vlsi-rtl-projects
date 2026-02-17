// =================================================================
// HDLBits: Complete 4-State Moore FSM (Binary Encoding + Full Implementation)
// Problem: Full FSM with state register, async reset to A, output=D=1
// Encoding: Binary A=00, B=01, C=10, D=11 | Compare: onehot_moore.v
// =================================================================
// COMPLETE FSM STRUCTURE (3 BLOCKS):
// 1️ Next-state combo logic     → always @(*)
// 2️ State register (async rst) → always @(posedge clk, posedge areset)  
// 3️ Output logic (Moore)       → assign out
// =================================================================
//  STATE TRANSITION TABLE:
// State │ in=0 │ in=1 │ out
// ──────┼──────┼──────┼────
//   A   │  A   │  B   │  0
//   B   │  C   │  B   │  0  
//   C   │  A   │  D   │  0
//   D   │  C   │  B   │  1◄─ Output!
// =================================================================

module top_module (
    input clk,
    input in,
    input areset,           // Async reset → State A
    output out
);

    // Binary state encoding (2 bits for 4 states)
    parameter A = 2'd0, B = 2'd1, C = 2'd2, D = 2'd3;
    reg [1:0] state, next;  // Current state + next state

    // ════════════════ 1️ NEXT-STATE LOGIC (COMBINATIONAL) ════════════════
    always @(*) begin
        case (state)
            A: next = in ? B : A;         // A: 0→A, 1→B
            B: next = in ? B : C;         // B: 0→C, 1→B
            C: next = in ? D : A;         // C: 0→A, 1→D
            D: next = in ? B : C;         // D: 0→C, 1→B
            default: next = A;
        endcase
    end

    // ════════════════ 2️ STATE REGISTER (SEQUENTIAL + ASYNC RESET) ════════════════
    always @(posedge clk, posedge areset) begin
        if (areset)
            state <= A;                 // Reset → State A
        else
            state <= next;
    end

    // ════════════════ 3️ OUTPUT LOGIC (MOORE: state→out) ════════════════
    assign out = (state == D);            // out=1 ONLY in state D

endmodule
