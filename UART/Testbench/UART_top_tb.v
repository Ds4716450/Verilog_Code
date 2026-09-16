module UART_top_tb;

reg        clk;
reg        rst;

reg        wr_enb;
reg [7:0]  data_in;

wire       tx;
wire       busy;

wire       rdy;
wire [7:0] data_out;

reg        rdy_clk;


//========================================
// UART TOP
//========================================
UART_top dut (
    .clk     (clk),
    .rst     (rst),

    .wr_enb  (wr_enb),
    .data_in (data_in),
    .tx      (tx),
    .busy    (busy),

    .rx_in   (tx),       // LOOPBACK: TX connected to RX
    .rdy_clk (rdy_clk),
    .rdy     (rdy),
    .data_out(data_out)
);


//========================================
// CLOCK
//========================================
initial begin
    clk = 1'b0;

    forever #5 clk = ~clk;
end


//========================================
// TEST
//========================================
initial begin

    $dumpfile("UART_top.vcd");
    $dumpvars(0, UART_top_tb);

    // Initial values
    rst     = 1'b1;
    wr_enb  = 1'b0;
    data_in = 8'h00;
    rdy_clk = 1'b0;

    // Reset
    #20;
    rst = 1'b0;

    //====================================
    // Send 8'h41
    //====================================
    @(posedge clk);

    data_in = 8'h41;
    wr_enb  = 1'b1;

    @(posedge clk);
    wr_enb = 1'b0;

    // Wait until transmission is finished
    wait (busy == 1'b0);

    // Wait until receiver says data is ready
    wait (rdy == 1'b1);

    $display("--------------------------------");
    $display("Received data = %h", data_out);
    $display("--------------------------------");

    if (data_out == 8'h41)
        $display("TEST 1 PASSED");
    else
        $display("TEST 1 FAILED");


    //====================================
    // Clear ready
    //====================================
    @(posedge clk);
    rdy_clk = 1'b1;

    @(posedge clk);
    rdy_clk = 1'b0;


    //====================================
    // Send 8'h55
    //====================================
    @(posedge clk);

    data_in = 8'h55;
    wr_enb  = 1'b1;

    @(posedge clk);
    wr_enb = 1'b0;

    wait (busy == 1'b0);
    wait (rdy == 1'b1);

    $display("--------------------------------");
    $display("Received data = %h", data_out);
    $display("--------------------------------");

    if (data_out == 8'h55)
        $display("TEST 2 PASSED");
    else
        $display("TEST 2 FAILED");


    //====================================
    // Finish
    //====================================
    #100;

    $finish;

end


//========================================
// MONITOR
//========================================
initial begin

    $monitor(
        "time=%0t rst=%b wr_enb=%b data_in=%h tx=%b busy=%b rdy=%b data_out=%h",
        $time,
        rst,
        wr_enb,
        data_in,
        tx,
        busy,
        rdy,
        data_out
    );

end

endmodule
