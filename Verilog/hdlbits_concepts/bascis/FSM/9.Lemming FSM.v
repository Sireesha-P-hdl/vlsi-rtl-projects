// =================================================================
// HDLBits: Lemming FSM (Wall-Bounce Direction Control)
// Problem: Lemmings walk LEFT→RIGHT on left wall, RIGHT→LEFT on right wall
// Reset: Async → LEFT | Output: walk_left/right based on direction
// =================================================================
// STATE DIAGRAM + LOGIC (ONE-GLANCE):
// ┌─────────────┐        ┌─────────────┐
// │   LEFT      │◄──bump_right── RIGHT │
// │ walk_left=1 │        │ walk_right=1│
// │ walk_right=0│──bump_left──►│walk_left=0│
// └─────────────┘        └─────────────┘
// Reset → LEFT
// =================================================================

module top_module (
    input clk,
    input areset,       // Async reset → LEFT direction
    input bump_left,    // Hit left wall → switch RIGHT
    input bump_right,   // Hit right wall → switch LEFT
    output walk_left,   // Walk left (when state=LEFT)
    output walk_right   // Walk right (when state=RIGHT)
);

    parameter LEFT  = 1'b0, RIGHT = 1'b1;
    reg state, next_state;

    // ════════════════ 1️ NEXT-STATE LOGIC (COMBINATIONAL) ════════════════
    always @(*) begin
        case (state)
            LEFT:  next_state = bump_left  ? RIGHT : LEFT;    // Hit left → RIGHT
            RIGHT: next_state = bump_right ? LEFT  : RIGHT;   // Hit right → LEFT
            default: next_state = LEFT;
        endcase
    end

    // ════════════════ 2️ STATE REGISTER (ASYNC RESET) ════════════════
    always @(posedge clk, posedge areset) begin
        if (areset)
            state <= LEFT;                         // Fresh lemmings → LEFT
        else
            state <= next_state;
    end

    // ════════════════ 3️ OUTPUT LOGIC (MOORE) ════════════════
    assign walk_left  = (state == LEFT);    // Walk left when facing LEFT
    assign walk_right = (state == RIGHT);   // Walk right when facing RIGHT

endmodule
