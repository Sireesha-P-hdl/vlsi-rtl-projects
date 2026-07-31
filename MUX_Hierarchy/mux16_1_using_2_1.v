module mux16_1using2_1(
input[15:0]I,
input[3:0]sel,
output y
);
wire [7:0]z;
wire [1:0]t;
mux mo(.I({I[1],I[0]}), .sel(sel[0]), .y(z[0]));
mux m1(.I({I[3],I[2]}), .sel(sel[0]), .y(z[1]));
mux m2(.I({I[5],I[4]}), .sel(sel[0]), .y(z[2]));
mux m3(.I({I[7],I[6]}), .sel(sel[0]), .y(z[3]));
mux m4(.I({I[9],I[8]}), .sel(sel[0]), .y(z[4]));
mux m5(.I({I[11],I[10]}), .sel(sel[0]), .y(z[5]));
mux m6(.I({I[13],I[12]}), .sel(sel[0]), .y(z[6]));
mux m7(.I({I[15],I[14]}), .sel(sel[0]), .y(z[7]));
mux4_1 m8(.I({z[3],z[2],z[1],z[0]}),.sel({sel[2],sel[1]}),.y(t[0]));
mux4_1 m9(.I({z[7],z[6],z[5],z[4]}),.sel({sel[2],sel[1]}),.y(t[1]));
mux m10(.I({t[1],t[0]}), .sel(sel[3]), .y(y));
endmodule
