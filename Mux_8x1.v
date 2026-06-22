module Mux_8x1(y,I,s);
output y;
input [7:0]I;
input [2:0]s;
wire [1:0]w;
//instaint mux_4x1 and mux_2x1
Mux_4x1 m1(.y(w[0]), .I(I[3:0]), .s(s[1:0]));
Mux_4x1 m2(.y(w[1]), .I(I[7:4]), .s(s[1:0]));
Mux_2x1 m3(.y(y), .I(w[1:0]), .s(s[2]));
endmodule