`timescale 1ns / 1ps
module mux(
input [1:0]I,
input sel,
output reg y
    );
    always @(*)begin
   if(sel)
   y=I[1];
   else
   y=I[0];
    end
    // assign y=(sel!=0)?I[1]:I[0];
endmodule
