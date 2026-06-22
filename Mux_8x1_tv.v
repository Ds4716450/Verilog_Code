module tb;
reg [7:0]I;
reg [2:0]s;
wire y;
Mux_8x1 dut (.y(y), .I(I), .s(s));
initial begin
    $dumpfile("wave.vcd");
    $dumpvars(0,tb);
I = 8'b10101010;
s=3'b000;
#10 s=3'b001;
#10 s=3'b010;
#10 s=3'b011;
#10 s=3'b100;
#10 s=3'b101;
#10 s=3'b110;
#10 s=3'b111;
end
initial begin
    $monitor("Time=%0t y=%b I=%b s=%b", $time, y, I,s);
end
endmodule