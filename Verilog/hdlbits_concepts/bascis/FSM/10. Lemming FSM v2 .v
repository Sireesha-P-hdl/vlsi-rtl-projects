// =================================================================
// HDLBits: Lemming FSM v2 (Falling + Ground Detection)
// Problem: Lemmings FALL off edges → "aaah!" → resume walking on ground
// States: 4 (2-bit) | Reset: Async → left | Output: walk + scream (aaah)
// =================================================================
// STATE DIAGRAM + ENCODING (ONE-GLANCE):
// ┌──────────────┐       ┌──────────────┐
// │  left (00)   │◄──bump_right── right(01)──┐
// │ walk_left=1  │       │ walk_right=1 │   │
// └──────┬───────┘       └──────┬───────┘   │
//        │ ~ground ─► g_left(10)             │ ~ground
//        │ aaah=1                           │ ► g_right(11)
//        │ ground ─► left(00) ◄── ground ────┘ aaah=1
// =================================================================

module top_module (
    input clk,
    input areset,       // Async reset → left (fresh lemmings)
    input bump_left,    // Hit left wall
    input bump_right,   // Hit right wall
    input ground,       // On solid ground (0=falling)
    output walk_left,   // Walk left (state==left)
    output walk_right,  // Walk right (state==right)
    output aaah         // Screaming! (falling states)
);

    // 2-bit state encoding
    parameter left    = 2'b00,   // Walking left
              right   = 2'b01,   // Walking right
              g_left  = 2'b10,   // Falling (was left)
              g_right = 2'b11;   // Falling (was right)
    
    reg [1:0] state, next_state;

    // ════════════════ 1️ NEXT-STATE LOGIC (COMBINATIONAL) ════════════════
    always @(*) begin
        case (state)
            left:    next_state = ground ? (bump_left  ? right  : left)    : g_left;   // Walk/bounce or fall
            right:   next_state = ground ? (bump_right ? left   : right)   : g_right;  // Walk/bounce or fall
            g_left:  next_state = ground ? left : g_left;  // Falling → land left
            g_right: next_state = ground ? right : g_right; // Falling → land right
            default: next_state = left;
        endcase
    end

    // ════════════════ 2️ STATE REGISTER (ASYNC RESET) ════════════════
    always @(posedge clk, posedge areset) begin
        if (areset)
            state <= left;                             // Fresh → walk left
        else
            state <= next_state;
    end

    // ════════════════ 3️ OUTPUT LOGIC (MOORE) ════════════════
    assign walk_left  = (state == left);      // Walking left
    assign walk_right = (state == right);     // Walking right
    assign aaah       = (state == g_left) || (state == g_right);  // Falling scream!

endmodule
