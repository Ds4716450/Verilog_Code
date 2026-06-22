module Mux_4x1(y,I,s);
output y ;
input [3:0] I;
input [1:0] s;
wire [1:0]w;
wire [3:0]p;
not g1(w[1],s[1]);
not g2(w[0],s[0]);
and g3(p[0],w[1],w[0],I[0]);
and g4(p[1],w[1],s[0],I[1]);
and g5(p[2],s[1],w[0],I[2]);
and g6(p[3],s[1],s[0],I[3]);
or g7(y,p[0],p[1],p[2],p[3]);
endmodule