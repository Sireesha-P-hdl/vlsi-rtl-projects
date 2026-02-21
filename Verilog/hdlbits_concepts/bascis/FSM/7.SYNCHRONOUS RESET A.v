// =================================================================
// HDLBits: Fsm3s - 4-State Moore FSM (SYNCHRONOUS RESET → A)
// Problem: https://hdlbits.01xz.net/wiki/Fsm3s (same logic as Fsm3 + sync reset)
// Compare: moore4_full.v (async), fsm3comb (combo only)
// =================================================================
//  STATE TRANSITION TABLE + ENCODING:
// State │ Binary │ in=0 │ in=1 │ out
// ──────┼────────┼──────┼──────┼────
//   A    │  00    │  A   │  B   │ 0
//   B    │  01    │  C   │  B   │ 0  
//   C    │  10    │  A   │  D   │ 0
//   D    │  11    │  C   │  B   │ 1◄─ Output!
// Reset: sync→A(00)
// =================================================================
// SPECIAL: State A uses "next_state=in" (direct mapping trick!)

module top_module (
    input clk,
    input in,
    input reset,            // SYNCHRONOUS reset → State A
    output out
);

    // Binary encoding (2 bits)
    parameter A = 2'b00, B = 2'b01, C = 2'b10, D = 2'b11;
    reg [1:0] state, next_state;

    // ════════════════ 1️ NEXT-STATE LOGIC (COMBINATIONAL) ════════════════
    always @(*) begin
        case (state)
            A: next_state = in;              // A: in=0→00(A), in=1→01(B) ✨
            B: next_state = in ? B : C;      // B: 0→C, 1→B
            C: next_state = in ? D : A;      // C: 0→A, 1→D
            D: next_state = in ? B : C;      // D: 0→C, 1→B
            default: next_state = A;
        endcase
    end

    // ════════════════ 2️ STATE REGISTER (SYNCHRONOUS RESET) ════════════════
    always @(posedge clk) begin
        if (reset)
            state <= A;                  // Sync reset → A on clock edge
        else
            state <= next_state;
    end

    // ════════════════ 3️ OUTPUT LOGIC (MOORE) ════════════════
    assign out = (state == D);           // out=1 ONLY in state D

endmodule
