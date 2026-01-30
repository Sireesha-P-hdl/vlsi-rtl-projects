// ------------------------------------------------------------
// Question:
// A D flip-flop is a sequential circuit that stores one bit of
// data and updates its output on the (usually) positive edge
// of a clock signal.
// D flip-flops are inferred by the logic synthesizer when a
// clocked always block is used. The simplest D flip-flop copies
// the input 'd' directly to the output 'q' on every rising edge
// of the clock.
// Task:
// Create a single D flip-flop.
// Requirements:
// - Use a clocked always block
// - Trigger on the positive edge of the clock
// - Use a non-blocking assignment
// ------------------------------------------------------------

module top_module (
    input  clk,    // Clock signal
    input  d,      // Data input
    output reg q   // Flip-flop output
);
    // On every rising edge of the clock,
    // store the value of d into q
    always @(posedge clk) begin
        q <= d;
    end
endmodule
