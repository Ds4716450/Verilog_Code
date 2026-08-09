module tb;
reg [7:0]operand1,operand2;
reg [2:0]opcode;
wire [15:0]Result;
wire flagC,flagZ;
ALU_8bit dut (.operand1(operand1), .operand2(operand2), .opcode(opcode), .Result(Result), .flagC(flagC), .flagZ(flagZ));
initial begin
    $dumpfile("wave.vcd");
    $dumpvars(0,tb);
opcode=3'b000;
operand1=8'b10010110;
operand2=8'b01110011;
#10 opcode=3'b001;
operand1=8'b10010110;
operand2=8'b01110011;
#10 opcode=3'b010;
operand1=8'b10010110;
operand2=8'b01110011;
#10 opcode=3'b011;
operand1=8'b10010110;
operand2=8'b01110011;
#10 opcode=3'b100;
operand1=8'b10010110;
operand2=8'b01110011;
#10 opcode=3'b101;
operand1=8'b10010110;
operand2=8'b01110011;
#10 opcode=3'b110;
operand1=8'b10010110;
operand2=8'b01110011;
#10 opcode=3'b111;
operand1=8'b10010110;
operand2=8'b01110011;
end
initial begin
    $monitor("time=%0t operand1=%b operand2=%b opcode=%b Result=%b flagC=%b flagZ=%b",
    $time, operand1, operand2, opcode, Result, flagC, flagZ );
end
endmodule
