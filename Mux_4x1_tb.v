module tb;
reg [3:0] I;
reg [1:0] s;
wire y;
Mux_4x1 dut (.y(y),.I(I),.s(s));
initial begin
    $dumpfile("wave.vcd");
    $dumpvars(0,tb);
I=4'b1010;
s=2'b00;
#10 s=2'b01;
#10 s=2'b10;
#10 s=2'b11;
#10 $finish;
end
initial begin
    $monitor("Time=%0t y=%b I=%b s=%b", $time, y, I,s);
end

endmodule
