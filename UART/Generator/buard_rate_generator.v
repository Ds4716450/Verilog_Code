module buard_rate_generator(
    clk,
    rst,
    tx_enb,
    rx_enb
);

input clk;
input rst;

output tx_enb;
output rx_enb;

reg [3:0] tx_counter;


always @(posedge clk) begin

    if (rst)
        tx_counter <= 4'd0;

    else if (tx_counter == 4'd15)
        tx_counter <= 4'd0;

    else
        tx_counter <= tx_counter + 1'b1;

end


// TX enable: one pulse every 16 clocks
assign tx_enb = (tx_counter == 4'd0);


// RX samples every clock for this simplified simulation
assign rx_enb = 1'b1;

endmodule