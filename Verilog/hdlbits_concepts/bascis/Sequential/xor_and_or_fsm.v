//------------------------------------------------------------------------------
// HDLBits: 3-bit FSM (XOR/AND/OR Logic)
//------------------------------------------------------------------------------

/*
Given the finite state machine circuit as shown:
[DFFs initially reset to zero]

Q0(next) = x XOR Q0  
Q1(next) = x AND NOT Q1
Q2(next) = x OR NOT Q2  
Z = NOT (Q0 OR Q1 OR Q2)
*/

module top_module (
    input clk,
    input x,
    output z
); 

    reg [2:0] Q;
    
    always @(posedge clk) begin
        Q[0] <= x ^  Q[0];     // XOR feedback
        Q[1] <= x & ~Q[1];     // AND with inverted feedback
        Q[2] <= x | ~Q[2];     // OR with inverted feedback
    end 
    
    assign z = ~(|Q);          // Active-low output (NOR of all bits)

endmodule
