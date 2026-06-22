module Mux_4x1_using_2x1(y,I,s);
input [3:0]I;
input [1:0]s;
output y;
wire [1:0]w;
//instiate Mux_2x1 
Mux_2x1 m1 (.y(w[0]), .I(I[1:0]), .s(s[0]));
Mux_2x1 m2 (.y(w[1]), .I(I[3:2]), .s(s[0]));
Mux_2x1 m3 (.y(y), .I(w), .s(s[1]));
endmodule