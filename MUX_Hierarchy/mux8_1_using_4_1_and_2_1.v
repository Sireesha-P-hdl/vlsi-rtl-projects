module mux8_1using4_1and2_1(
input [7:0]d,
input[2:0]sel,
output y
);
wire [1:0]z;
mux4_1 m0(.I({d[3],d[2],d[1],d[0]}) ,.sel({sel[1],sel[0]}),.y(z[0]));
mux4_1 m1(.I({d[7],d[6],d[5],d[4]}) ,.sel({sel[1],sel[0]}),.y(z[1]));
mux m2(.I({z[1],z[0]}), .sel(sel[2]), .y(y));
endmodule
