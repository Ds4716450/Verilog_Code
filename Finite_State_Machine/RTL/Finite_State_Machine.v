module Finite_State_Machine(y,x,rst,clk);
input x,rst,clk;
output y;
reg [1:0]state;
parameter 
a=2'b00,
b=2'b01,
c=2'b10,
d=2'b11;
always@(posedge clk)begin
    if(rst)
        state<=a;
    else
       case(state)
       a:begin
        if (x)
           state<=b;
        else
           state<=a;
       end
       b:begin
        if (x)
            state<=b;
        else
            state<=c;
       end
       c:begin
        if (x)
            state<=d;
        else
            state<=a;
       end
       d:begin
        if (x)
            state<=b;
        else
            state<=c;
       end
       default:
       state<=0;
       endcase
end
assign y = (x == 0) && (state == d);
endmodule
