// =================================================================
// HDLBits: Moore FSM (4-State Combinational Logic Only)
// Problem: Implement ONLY next_state + output logic (NO state register)
// Encoding: A=00, B=01, C=10, D=11 | Output: D=1 (others=0)
// =================================================================
//  STATE TRANSITION TABLE (ONE-GLANCE):
// ┌──────┬──────┬──────┬─────┐
// │State │in=0 │in=1 │ out │
// ├──────┼──────┼──────┼─────┤
// │  A   │  A   │  B   │  0  │
// │  B   │  C   │  B   │  0  │  
// │  C   │  A   │  D   │  0  │
// │  D   │  C   │  B   │  1  │◄─ Output high!
// └──────┴──────┴──────┴─────┘
// =================================================================

module top_module (
    input in,
    input [1:0] state,      // Current state (2-bit)
    output [1:0] next_state, // Next state (combinational)
    output out              // Output (Moore: state-based)
);

    // State encoding
    parameter A = 2'd0, B = 2'd1, C = 2'd2, D = 2'd3;

    // ════════════════ 1️. NEXT-STATE LOGIC (COMBINATIONAL) ════════════════
    always @(*) begin
        case (state)
            A: next_state = in ? B : A;           // A: 0→A, 1→B
            B: next_state = in ? B : C;           // B: 0→C, 1→B
            C: next_state = in ? D : A;           // C: 0→A, 1→D  
            D: next_state = in ? B : C;           // D: 0→C, 1→B
            default: next_state = A;
        endcase
    end

    // ════════════════ 2️. OUTPUT LOGIC (MOORE: state→out) ════════════════
    assign out = (state == D);                    // out=1 ONLY in state D

endmodule
