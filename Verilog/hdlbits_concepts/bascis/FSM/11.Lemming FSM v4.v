// =================================================================
// HDLBits: Lemming FSM v4 (Full Death Sequence: Fall→Splat→Aaah→End)
// Problem: Complete Lemming lifecycle - Walk/Dig/Bounce/Fall/Splat/Aaah
// States: 8 (3-bit) | Counter: Tracks fall time → SPLAT at count==20
// =================================================================
// 🎯 COMPLETE STATE PROGRESSION (8 STATES):
// Walk/Dig ──► FALL_L/R ──20clk──► SPLAT ──► AAAH_END (stuck)
//    │          │ aaah=1        │ aaah=1
//    └──────────┬───────────────┘
//               │ ground=1 lands safely
// =================================================================

module top_module (
    input clk, areset,          // Async reset → LEFT
    input bump_left, bump_right,// Wall collision (walking only)
    input ground,               // 1=safe landing, 0=falling
    input dig,                  // Dig command (walking only)
    output walk_left, walk_right, aaah, digging
);

    // 3-bit state encoding (8 states)
    parameter LEFT=3'd0, RIGHT=3'd1, DIG_L=3'd2, DIG_R=3'd3,
              FALL_L=3'd4, FALL_R=3'd5, SPLAT=3'd6, AAAH_END=3'd7;
    
    reg [2:0] state, next_state;
    reg [4:0] count;  // Fall counter (0-31)

    // ════════════════ FALL COUNTER ════════════════
    always @(posedge clk or posedge areset) begin
        if (areset)
            count <= 5'd0;
        else if (next_state == FALL_L || next_state == FALL_R)
            count <= count + 1'b1;  // Count fall time
        else
            count <= 5'd0;          // Reset on non-falling
    end

    // ════════════════ STATE REGISTER ════════════════
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= LEFT;
        else
            state <= next_state;
    end

    // ════════════════ NEXT-STATE LOGIC ════════════════
    always @(*) begin
        case (state)
            LEFT:  next_state = ground ? (dig ? DIG_L  : (bump_left  ? RIGHT : LEFT ))  : FALL_L;
            RIGHT: next_state = ground ? (dig ? DIG_R  : (bump_right ? LEFT  : RIGHT))  : FALL_R;
            DIG_L: next_state = ground ? DIG_L                                 : FALL_L;
            DIG_R: next_state = ground ? DIG_R                                 : FALL_R;
            
            FALL_L: next_state = ground ? LEFT : (count == 5'd20 ? SPLAT : FALL_L);
            FALL_R: next_state = ground ? RIGHT : (count == 5'd20 ? SPLAT : FALL_R);
            
            SPLAT: next_state = ground ? AAAH_END : SPLAT;  // Splat → final scream
            AAAH_END: next_state = AAAH_END;                // Game over (stuck)
            
            default: next_state = LEFT;
        endcase
    end

    // ════════════════ OUTPUT LOGIC (MOORE) ════════════════
    assign walk_left  = (state == LEFT);
    assign walk_right = (state == RIGHT);
    assign digging    = (state == DIG_L || state == DIG_R);
    assign aaah       = (state == FALL_L || state == FALL_R || state == SPLAT);

endmodule
