module tb;
reg [1:0]x;
reg E;
wire [3:0]y;
decoder_com dut(.y(y), .x(x), .E(E));
initial begin
    $dumpfile("wave.vcd");
    $dumpvars(0,tb);
E=1'b1;
x=2'b00;
#10 x=2'b01 ;
#10 x=2'b10;
#10 x=2'b11;
#10 $finish;
end
initial begin
    $monitor("Time=%0t E=%b x=%b y=%b",
              $time, E, x, y);
end
endmodule