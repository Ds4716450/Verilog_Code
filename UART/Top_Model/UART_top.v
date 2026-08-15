module UART_top(
    input        clk,
    input        rst,

    // Transmitter interface
    input        wr_enb,
    input  [7:0] data_in,
    output       tx,
    output       busy,

    // Receiver interface
    input        rx_in,
    input        rdy_clk,
    output       rdy,
    output [7:0] data_out
);

    // Baud-rate enable signals
    wire tx_enb;
    wire rx_enb;


    //========================================
    // Baud Rate Generator
    //========================================
    buard_rate_generator baud_gen (
        .clk    (clk),
        .tx_enb (tx_enb),
        .rst    (rst),
        .rx_enb (rx_enb)
    );


    //========================================
    // UART Transmitter
    //========================================
    UART_tx transmitter (
        .tx      (tx),
        .busy    (busy),
        .clk     (clk),
        .rst     (rst),
        .enb     (tx_enb),
        .data_in (data_in),
        .wr_enb  (wr_enb)
    );


    //========================================
    // UART Receiver
    //========================================
    UART_Rx receiver (
        .clk     (clk),
        .rst     (rst),
        .enb     (rx_enb),
        .rx_in   (rx_in),
        .rdy_clk (rdy_clk),
        .rdy     (rdy),
        .data_out(data_out)
    );

endmodule
