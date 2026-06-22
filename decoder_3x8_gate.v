module decoder_3x8_gate(y,x);
output [7:0] y;
input [2:0] x;
wire w;
not g1 (w,x[2]);
//instantiate decoder_com;
decoder_com m1 (.y(y[3:0]),.x(x[1:0]),.E(w));
decoder_com m2 (.y(y[7:4]),.x(x[1:0]),.E(x[2]));
endmodule