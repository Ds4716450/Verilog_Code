module tb;
reg [7:0]Adr;
reg [7:0]data_In;
reg clk,En,RD,WR,rst;
wire [7:0]data_out;
SRAM dut (.Adr(Adr), .data_In(data_In), .clk(clk), .En(En),
.RD(RD), .WR(WR), .data_out(data_out), .rst(rst));
initial begin
    $dumpfile("wave.vcd");
    $dumpvars(0,tb);
data_In=8'h0;
RD=1'h0;
WR=1'h0;
En=1'b0;
rst=1'b1;
#10 rst=1'b0;
En=1'b1;
Adr=8'h0;
data_In=8'hAB;
RD=1'b0;
WR=1'b1;
#10 
Adr=8'h1;
data_In=8'hBC;
RD=1'b0;
WR=1'b1;
#10 
Adr=8'h2;
data_In=8'hCC;
RD=1'b0;
WR=1'b1;
#10 
Adr=8'h3;
data_In=8'h30;
RD=1'b0;
WR=1'b1;
#10
Adr=8'h0;
RD=1'b1;
WR=1'b0; 
#10 
Adr=8'h3;
RD=1'b1;
WR=1'b0;
#10 $finish;
end
initial begin
    clk=1'b0;
    forever #5 clk=~clk;
end
initial begin
    $monitor ("time=%0tb Adr=%b data_In=%b clk=%b En=%b RD=%b WR=%b data_out=%b rst=%b",
    $time, Adr,data_In,clk,En,RD,WR,data_out,rst);
end
endmodule
