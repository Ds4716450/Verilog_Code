//D Flip flop 
module D_flip(clk,rst,q,en,din);
input clk,rst,en;
input [3:0]din;
output reg [3:0]q;
always @ (posedge clk)
if (rst)
    q<=0;
else if (en)
    q<=din;
else
    q<=q;
endmodule
// Mux Design 
module Mux( load, din,inc,data);
input [3:0] data,inc;
input load;
output [3:0]din;
assign din=load ? data : inc;
endmodule
// Increament
module Increament(inc,q);
input [3:0]q;
output  [3:0]inc;
assign inc=q + 1'b1;
endmodule

/// top module 
module Program_Counter(
    input clk,
    input rst,
    input en,
    input load,
    input [3:0] data,
    output [3:0] q
);

wire [3:0] inc;
wire [3:0] din;

Increament u1(
    .q(q),
    .inc(inc)
);

Mux u2(
    .load(load),
    .inc(inc),
    .data(data),
    .din(din)
);

D_flip u3(
    .clk(clk),
    .rst(rst),
    .en(en),
    .din(din),
    .q(q)
);

endmodule
