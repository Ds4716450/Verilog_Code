module decoder_com(y,x,E);
output [3:0] y;
input [1:0] x;
input E ;
wire [1:0] w;
not g1(w[1],x[1]);
not g2(w[0],x[0]);
and g3(y[0], E, w[1],w[0]);
and g4(y[1], E, w[1],x[0]);
and g5(y[2], E, x[1],w[0]);
and g6(y[3], E, x[1],x[0]);
endmodule
