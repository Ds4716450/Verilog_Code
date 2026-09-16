module SRAM(Adr,data_In,clk,En,RD,WR,data_out,rst);
/* input [7:0]Add,data_In;
input clk,En,RD,WR;
output reg [7:0]data_out;
reg [7:0] SRAM[7:0]; */

// parameter for the width
parameter addr=8;
parameter data=8;

input [addr-1:0]Adr;
input [data-1:0]data_In;
input clk,En,RD,WR,rst;
output reg [data-1:0]data_out;
reg [data-1:0] mem[255:0];
integer i;
always@(posedge clk or posedge rst)
begin
    if(rst) begin
        for(i=0; i<256; i=i+1)
            mem[i]<=8'h0;
        data_out<=8'h0;
    end
    else if (En) begin
      if (RD==1'b0 && WR==1'b1 ) begin //write operation
        mem[Adr]<=data_In;
      end
      else if(RD==1'b1 && WR==1'b0) begin //Read opearation
        data_out<=mem[Adr];
      end
      else begin
        data_out<=data_out;
      end
    end
end
endmodule

