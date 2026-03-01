/*
HDLBits Problem: Fsm_ps2 (PS/2 Mouse Protocol FSM)
Link: https://hdlbits.01xz.net/wiki/Fsm_ps2

The PS/2 mouse protocol sends messages that are three bytes long. However, 
within a continuous byte stream, it's not obvious where messages start and end. 
The only indication is that the first byte of each three byte message always 
has bit[3]=1 (but bit[3] of the other two bytes may be 1 or 0 depending on data).

We want a finite state machine that will search for message boundaries when 
given an input byte stream. The algorithm we'll use is to discard bytes until 
we see one with bit[3]=1. We then assume that this is byte 1 of a message, 
and signal the receipt of a message once all 3 bytes have been received (done).

The FSM should signal done in the cycle immediately after the third byte of 
each message was successfully received.

Some timing diagrams to explain the desired behaviour
Under error-free conditions, every three bytes form a message:
byte1 byte2 byte3 byte1 byte2 byte3 byte1 byte2 byte3
clk   reset     in[3]    done

When an error occurs, search for byte 1:
byte1 byte2 byte3 ?? byte1 byte2 byte3 byte1 byte2 byte3
clk   reset     in[3]    done

Note that this is not the same as a 1xx sequence recognizer. 
Overlapping sequences are not allowed here:
byte1 byte2 byte3 ? byte1 byte2 byte3 byte1 byte2 byte3
clk   reset     in[3]    done

Module Declaration
module top_module(
    input clk,
    input [7:0] in,
    input reset,    // Synchronous reset
    output done); 

Hint: Although in[7:0] is a byte, the FSM only has one input: in[3].
You need ~4 states. Three states likely wouldn't work because one of them 
needs to assert done, and done is asserted for only one cycle for each 
received message.
*/

module top_module(
    input clk,
    input [7:0] in,
    input reset,    // Synchronous reset
    output done); //

    // State transition logic (combinational)
    reg [1:0] state, next_state;
    always @(*) begin
        case(state)
            2'd0: next_state = in[3] ? 2'd1 : 2'd0;
            2'd1: next_state = 2'd2;
            2'd2: next_state = 2'd3;
            2'd3: next_state = in[3] ? 2'd1 : 2'd0;
        endcase
    end
    
    // State register
    always @(posedge clk) begin
        if (reset)
            state <= 2'd0;
        else
            state <= next_state;
    end
    
    // Output
    assign done = (state == 2'd3);

endmodule
