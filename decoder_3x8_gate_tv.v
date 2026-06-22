module tb;
reg [2:0] x;//input
wire [7:0] y;//output
decoder_3x8_gate dut(.y(y), .x(x));//function connection
initial begin
    $dumpfile("wave.vcd");
    $dumpvars(0,tb);
x[2]=1'b1; //truth table
x=3'b00;
#10 x=3'b001 ;
#10 x=3'b010;
#10 x=3'b011;
#10 x=3'b100 ;
#10 x=3'b101;
#10 x=3'b110;
#10 x=3'b111; 
#10 $finish;
end
initial begin
    $monitor("Time=%0t E=%b x=%b y=%b",
              $time,  x, y);
end
endmodule