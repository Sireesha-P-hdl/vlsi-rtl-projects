module mux_16_1using8_1(
input[15:0]I,
input[3:0]sel,
output y
);
wire [1:0]z;
mux_8_1 mo(.I({I[7],I[6],I[5],I[4],I[3],I[2],I[1],I[0]}),.sel({sel[2],sel[1],sel[0]}),.y(z[0]));
mux_8_1 m1(.I({I[15],I[14],I[13],I[12],I[11],I[10],I[9],I[8]}),.sel({sel[2],sel[1],sel[0]}),.y(z[1]));
mux m2(.I({z[1],z[0]}), .sel(sel[3]), .y(y));

endmodule
