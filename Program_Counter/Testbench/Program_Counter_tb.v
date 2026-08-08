module tb;
reg load,clk,rst,en;
reg [3:0]data;
wire [3:0]q;
Program_Counter dut (.clk(clk), .rst(rst), .en(en), .data(data), .q(q), .load(load));
initial begin
    clk  = 0;
    rst  = 1;
    en   = 0;
    load = 0;
    data = 4'd0;
end
initial begin
    $dumpfile("wave.vcd");
    $dumpvars(0,tb);
rst=1'b1;
en=1'b0;
#10 rst=1'b0;
#5 en=1'b1;
#10 load =1'b1;
data=4'b1001;
#10 load =1'b1;
data=4'b0110;
#10 load =1'b0;
#10 load =1'b0;
#10 load =1'b0;
#10 load =1'b0;
#20 $finish;
end
initial begin
    clk=1'b0;
    forever #5 clk=~clk;
end
initial begin
    $monitor("time=%0t clk=%b rst=%b en=%b data=%b q=%b",$time, clk,rst,en,data,q);
end
endmodule
