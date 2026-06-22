module Mux_2x1(y,I,s);
input [1:0]I;
input s;
output y;
wire [2:0]w;
not g1 (w[0],s);
and g2 (w[1],w[0],I[0]);
and g3 (w[2],s,I[1]);
or g4 (y,w[1],w[2]);
endmodule