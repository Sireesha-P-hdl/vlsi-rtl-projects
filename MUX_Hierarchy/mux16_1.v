module mux_16_1(
input[15:0]I,
input[3:0]sel,
output reg y
);
always @(*)begin
case(sel)
4'b0000:y=I[0];
4'b0001:y=I[1];
4'b0010:y=I[2];
4'b0011:y=I[3];
4'b0100:y=I[4];
4'b0101:y=I[5];
4'b0110:y=I[6];
4'b0111:y=I[7];
4'b1000:y=I[8];
4'b1001:y=I[9];
4'b1010:y=I[10];
4'b1011:y=I[11];
4'b1100:y=I[12];
4'b1101:y=I[13];
4'b1110:y=I[14];
4'b1111:y=I[15];

endcase
end
endmodule
