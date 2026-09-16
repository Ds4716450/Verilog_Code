module ALU_8bit(operand1,operand2,opcode,Result,flagC,flagZ);
input [7:0]operand1,operand2;
input [2:0]opcode;
output reg [15:0]Result;
output reg flagC,flagZ;
parameter[2:0]
add_op=3'b000,
sub_op=3'b001,
mult_op=3'b010,
AND_op=3'b011,
OR_op=3'b100,
NAND_op=3'b101,
NOR_op=3'b110,
X0R_op=3'b111;
always @(*)
begin 
    case(opcode)
    add_op: begin
        Result={8'b0, operand1} + {8'b0, operand2} ;
        flagC=Result[8];
        flagZ=(Result==16'b0);
    end
    sub_op: begin
        Result={8'b0, operand1} - {8'b0, operand2} ;
        flagC=Result[8];
        flagZ=(Result==16'b0);
    end
    mult_op:begin
        Result={8'b0, operand1} * {8'b0, operand2};
        flagC=Result[8];
        flagZ=(Result==16'b0);
    end
    AND_op:begin
        Result={8'b0, operand1} & {8'b0, operand2};
        flagC=Result[8];
        flagZ=(Result==16'b0);
    end
    OR_op:begin 
        Result= {8'b0, operand1} | {8'b0, operand2} ;
        flagC=Result[8];
        flagZ=(Result==16'b0);
    end
    NAND_op:begin
        Result= ~({8'b0, operand1} & {8'b0, operand2});
        flagC=Result[8];
        flagZ=(Result==16'b0);
    end
    NOR_op: begin
        Result= ~({8'b0, operand1} | {8'b0, operand2});
        flagC=Result[8];
        flagZ=(Result==16'b0);
    end
    X0R_op: begin
        Result= {8'b0, operand1} ^ {8'b0, operand2};
        flagC=Result[8];
        flagZ=(Result==16'b0);
    end
    default: begin
        Result=16'b0;
        flagC=1'b0;
        flagZ=1'b0;
    end
endcase
end
endmodule

