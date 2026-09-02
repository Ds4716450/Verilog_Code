`timescale 1ns/1ps
module Serial_link(serial_data,serial_link_data,tx_clk,serial_link_clk);
input serial_data;
input tx_clk;
output serial_link_data;
output serial_link_clk;
assign serial_link_data=serial_data;
assign serial_link_clk=tx_clk;
endmodule 
