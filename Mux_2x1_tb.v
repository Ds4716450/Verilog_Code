module tb;
reg [1:0]I;
reg s;
wire y;
Mux_2x1 dut (.y(y), .I(I), .s(s));
initial begin
    $dumpfile("wave.vcd");
    $dumpvars(0,tb);
s=1'b0;
#10 s=1'b1;
#10 $finish;
end
initial begin
    $monitor("Time=%0t y=%b I=%b s=%b",
              $time, y,I,s);
end
endmodule
