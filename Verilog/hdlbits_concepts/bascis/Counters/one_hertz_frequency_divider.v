// ------------------------------------------------------------
// 1000 Hz to 1 Hz Frequency Divider using BCD Counters
// ------------------------------------------------------------
// - Uses three modulo-10 (BCD) counters
// - All counters share the same 1000 Hz clock
// - Enable signals control counting speed
// - OneHertz is asserted for exactly one clock cycle per second
// ------------------------------------------------------------

module top_module ( 
    input clk,            // 1000 Hz clock input
    input reset,          // Synchronous active-high reset
    output OneHertz,      // 1 Hz pulse output
    output [2:0] c_enable // Enable signals for BCD counters
);
    //Why are they [3:0]?
    //Because BCD counters count from 0 to 9, and:
    //0 to 9 needs 4 bits
    // Internal BCD counter outputs
    wire [3:0] q0;  // Units digit (fastest counter)
    wire [3:0] q1;  // Tens digit
    wire [3:0] q2;  // Hundreds digit (slowest counter)

    // --------------------------------------------------------
    // Enable logic for each counter
    // --------------------------------------------------------
    // Counter 0 always enabled
    // Counter 1 enabled when counter 0 reaches 9
    // Counter 2 enabled when counters 0 and 1 both reach 9
    // --------------------------------------------------------

    assign c_enable[0] = 1'b1;
    assign c_enable[1] = (q0 == 4'd9);
    assign c_enable[2] = (q1 == 4'd9) && (q0 == 4'd9);

    // --------------------------------------------------------
    // OneHertz pulse generation
    // Asserted once every 1000 clock cycles
    // --------------------------------------------------------

    assign OneHertz = (q2 == 4'd9) && (q1 == 4'd9) && (q0 == 4'd9);

    // --------------------------------------------------------
    // BCD Counter Instantiations
    // --------------------------------------------------------
    bcdcount counter0 (clk, reset, c_enable[0],q0);
    bcdcount counter1 (clk, reset, c_enable[1],q1);
    bcdcount counter2 (clk, reset, c_enable[2],q2);
endmodule
