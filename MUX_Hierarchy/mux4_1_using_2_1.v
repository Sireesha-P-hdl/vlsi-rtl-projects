module mux4_1using2_1(
input [3:0]I,
input [1:0]sel,
output y
);
wire [1:0]z;
mux mo(.I({I[1],I[0]}), .sel(sel[0]), .y(z[0]));
mux m1(.I({I[3],I[2]}), .sel(sel[0]), .y(z[1]));
mux m2(.I({z[1],z[0]}), .sel(sel[1]), .y(y));
endmodule
 
