// =================================================================
// HDLBits: Lemming FSM v3 (Digging + Falling + Ground + Walls)
// Problem: Full Lemming behavior - Walk/Dig/Bounce/Fall/Scream/Land
// States: 6 (3-bit encoded) | Reset: Async → left
// =================================================================
// STATE MACHINE OVERVIEW (6 STATES):
// ┌──────────────┐       ┌──────────────┐
// │  left (000)  │◄───bump_right── right(001)──┐
// │ walk_left=1  │       │ walk_right=1 │   │
// └──────┬───────┘       └──────┬───────┘   │
//        │                      │            │
//        ├─dig──► dig_l (100)    ├─dig──► dig_r (101)
//        │ digging=1             │ digging=1 │
//        │                      │            │
//        │ ~ground ─► fall_l(010)│ ~ground ─► fall_r(011)
//        │ aaah=1                │ aaah=1    │
//        └─ground ───────────────┘           │
//                                            └─ground ────────────────┘
// =================================================================

module top_module (
    input clk,
    input areset,       // Async reset → left (fresh lemmings)
    input bump_left,    // Hit left wall (while walking)
    input bump_right,   // Hit right wall (while walking)
    input ground,       // On ground (0=falling off edge)
    input dig,          // Dig command (while walking on ground)
    output walk_left,   // Walking left
    output walk_right,  // Walking right
    output aaah,        // Screaming (falling!)
    output digging      // Digging
);

    // 6-state encoding (3 bits needed, using 4-bit reg for safety)
    parameter left   = 4'd0,   right  = 4'd1,   // Walking
              fall_l = 4'd2,   fall_r = 4'd3,   // Falling (aaah!)
              dig_l  = 4'd4,   dig_r  = 4'd5;   // Digging

    reg [3:0] state, next_state;

    // ════════════════ 1️ NEXT-STATE LOGIC w/ DEFAULT ════════════════
    always @(*) begin
        next_state = state;  // Default: stay (safe!)
        
        case (state)
            // WALKING STATES (priority: dig > bump > continue > fall)
            left:  next_state = ground ? (dig ? dig_l  : (bump_left  ? right : left ))  : fall_l;
            right: next_state = ground ? (dig ? dig_r  : (bump_right ? left  : right))  : fall_r;
            
            // FALLING STATES (land → previous direction)
            fall_l: next_state = ground ? left  : fall_l;
            fall_r: next_state = ground ? right : fall_r;
            
            // DIGGING STATES (continue until ~ground → fall)
            dig_l:  next_state = ground ? dig_l  : fall_l;
            dig_r:  next_state = ground ? dig_r  : fall_r;
            
            default: next_state = left;
        endcase
    end

    // ════════════════ 2️ STATE REGISTER (ASYNC RESET) ════════════════
    always @(posedge clk, posedge areset) begin
        if (areset)
            state <= left;                      // Fresh → walk left
        else
            state <= next_state;
    end

    // ════════════════ 3️ OUTPUT LOGIC (MOORE) ════════════════
    assign walk_left  = (state == left);      // Only walking left
    assign walk_right = (state == right);     // Only walking right
    assign aaah       = (state == fall_l || state == fall_r);    // Falling scream!
    assign digging    = (state == dig_l  || state == dig_r);     // Digging!

endmodule
