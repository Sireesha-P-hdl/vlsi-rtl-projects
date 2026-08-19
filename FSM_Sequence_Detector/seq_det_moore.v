`timescale 1ns / 1ps
module seq_dect(
input clk,reset,w,
output y
    );
    parameter s0 = 3'b000;
    parameter s1 = 3'b001;
    parameter s2 = 3'b010;
    parameter s3 = 3'b011;
    parameter s4 = 3'b100;
  
    reg [2:0]state,ns; //ns =next state 
    always @(posedge clk)begin
    if(reset)
    state<=s0;
    else
    state<=ns;
    end
    always @(*)begin
    ns=state;
    case(state)
    s0 :ns=w?s1:s0;
    s1 :ns=w?s1:s2;
    s2 :ns=w?s3:s0;
    s3 :ns=w?s4:s2;
    s4 :ns=w?s1:s2;
    endcase
    end
    assign y=(state==s4)?1'b1:1'b0;
endmodule
