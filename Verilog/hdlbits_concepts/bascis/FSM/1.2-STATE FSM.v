// =================================================
// HDLBits Fsm1: 2-STATE FSM TOGGLES ON in=0
// Reset → B (out=1). Stay on in=1, Toggle on in=0
// =================================================

module top_module (
    input clk,      // Clock
    input areset,   // ASYNC reset → B
    input in,       // Toggle control: 0=toggle, 1=stay  
    output out      // out=1 in B, out=0 in A (MOORE)
);

parameter A=0, B=1;     // 1-BIT STATES: A=0, B=1
reg state, next_state;  // CURRENT + NEXT

// COMBO: NEXT STATE LOGIC
always @(*) begin
    case(state)
        A: next_state = in ? A : B;  // A --in=0--> B (toggle)
        B: next_state = in ? B : A;  // B --in=0--> A (toggle)
    endcase
end

// SEQ: STATE REGISTER (ASYNC RESET)
always @(posedge clk, posedge areset) begin
    if(areset) state <= B;      // IMMEDIATE → B on reset
    else       state <= next_state;
end

// OUTPUT: HIGH only in state B
assign out = (state == B);

endmodule
