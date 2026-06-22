module tb;
reg [7:0]x;
wire [2:0]y;
encoder dut(.y(y),.x(x));//connect external world
initial begin
    $dumpfile("wave.vcd");
    $dumpvars(0,tb);
x=8'b00000001;//truth table
#10 x=8'b00000010;
#10 x=8'b00000010;
#10 x=8'b00000100;
#10 x=8'b00001000;
#10 x=8'b00010000;
#10 x=8'b00100000;
#10 x=8'b01000000;
#10 x=8'b10000000;
#10 $finish;
end
initial begin
    $monitor("Time=%0t x=%b y=%b", $time, x, y);
end

endmodule