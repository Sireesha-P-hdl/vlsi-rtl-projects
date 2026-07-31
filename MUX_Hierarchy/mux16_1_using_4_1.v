module mux_16_1using4_1(
input[15:0]I,
input[3:0]sel,
output y
);
wire [3:0]z;
mux4_1 m0(.I({I[3],I[2],I[1],I[0]}) ,.sel({sel[1],sel[0]}),.y(z[0]));
mux4_1 m1(.I({I[7],I[6],I[5],I[4]}) ,.sel({sel[1],sel[0]}),.y(z[1]));
mux4_1 m2(.I({I[11],I[10],I[9],I[8]}) ,.sel({sel[1],sel[0]}),.y(z[2]));
mux4_1 m3(.I({I[15],I[14],I[13],I[12]}) ,.sel({sel[1],sel[0]}),.y(z[3]));
mux4_1 m4(.I({z[3],z[2],z[1],z[0]}) ,.sel({sel[3],sel[2]}),.y(y));
endmodule
