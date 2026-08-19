`timescale 1ns / 1ps
module seq_dect(
input clk,rst,w,
output y
    );
    parameter s0=2'b00;
     parameter s1=2'b01;
      parameter s2=2'b10;
       parameter s3=2'b11;
       reg [1:0] state,nxt_state;
       always @(posedge clk )begin
       if(rst)
       state<=2'b00;
       else 
       state<=nxt_state;
       end
       always @(*)begin
       nxt_state=state;
       case(state)
       s0:nxt_state=w?s1:s0;
       s1:nxt_state=w?s1:s2;
       s2:nxt_state=w?s3:s0;
       s3:nxt_state=w?s1:s2;
       endcase
       end
       assign y=(state==s3)&&(w==1'b1);
endmodule
