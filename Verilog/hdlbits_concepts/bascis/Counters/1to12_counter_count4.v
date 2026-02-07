// =================================================================
// 1-12 Counter using count4 module + Control Logic
// HDLBits: 1-12 counter with enable & sync reset to 1
// =================================================================
//
// Requirements:
// - Counts: 1→2→3→...→12→1 (12 states)
// - reset=1 → Q=1 (synchronous active HIGH)
// - enable=0 → Hold current value
// - Uses provided count4 module (enable/load with load priority)
//
// Control Logic:
// c_enable  = enable (pass through)   If external enable is high → counter can count ,If low → counter holds ,✔ Direct connection
// c_load    = reset | (Q==12 & enable)  (load when reset OR rollover)Load happens whenreset = 1OR Q == 12 AND enable = 1 ,This ensures:Reset forces counter to 1 ,After reaching 12 → next cycle loads 1
// c_d       = 4'd1 (always load 1) Whenever load happens, counter loads 1
// =================================================================

module top_module (
    input clk,
    input reset,     // Sync active-high reset → Q=1
    input enable,    // Run counter when high
    output [3:0] Q,
    output c_enable, // Counter enable signal (for verification)
    output c_load,   // Counter load signal (for verification)  
    output [3:0] c_d // Counter data input (for verification)
); 

    // Pass-through enable signal
    assign c_enable = enable;
    
    // Load 1'b1 when: reset=1 OR (Q=12 AND enable=1)
    assign c_load = reset | (Q == 4'd12 & enable);
    
    // Always load value = 1 (0001 binary)
    assign c_d =  (c_load)? 1:0;
    
    // Instantiate provided 4-bit counter
     count4 the_counter (clk, c_enable, c_load, c_d, Q);
endmodule
