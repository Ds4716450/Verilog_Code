module encoder(y,x);
output [2:0]y;
input [7:0]x;
or g1(y[2],x[4],x[5],x[6],x[7]);
or g2(y[1],x[2],x[3],x[6],x[7]);
or g3(y[0],x[1],x[3],x[5],x[7]);
endmodule