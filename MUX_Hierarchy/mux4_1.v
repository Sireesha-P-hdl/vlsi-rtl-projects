module mux4_1(
input [3:0]I,
input [1:0]sel,
output reg y
);
always@(*)begin
case(sel)
2'b00:y=I[0];
2'b01:y=I[1];
2'b10:y=I[2];
2'b11:y=I[3];
endcase
end 
endmodule
