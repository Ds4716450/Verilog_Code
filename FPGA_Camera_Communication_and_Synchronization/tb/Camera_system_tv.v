`timescale 1ns/1ps

module tb;

//==================================================
// TESTBENCH SIGNALS
//==================================================

reg rst;

reg tx_clk;
reg rx_clk;

reg tx_start;
reg rx_start;

reg [62:0] data_in;
reg pixel_clk;

wire serial_data;
wire [62:0] data_out;

wire serializer_done;
wire deserializer_done;

wire [62:0] cdc_data_out;
wire dst_valid;
wire cdc_valid;

wire pixel_done;
wire [62:0] ejector_data;
wire [12:0] pixel_count;

wire debug_req;
wire debug_ack;
wire debug_req_sync1;
wire debug_req_sync2;

assign cdc_valid = deserializer_done;


//==================================================
// TEST COUNTERS
//==================================================

integer pass_count;
integer fail_count;
integer transaction_count;


//==================================================
// DUT
// CONNECTION NOT CHANGED
//==================================================

Camera_system_top dut (
    .rst               (rst),
    .tx_clk            (tx_clk),
    .rx_clk            (rx_clk),
    .tx_start          (tx_start),
    .rx_start          (rx_start),
    .data_in           (data_in),

    .serial_data       (serial_data),
    .data_out          (data_out),

    .serializer_done   (serializer_done),
    .deserializer_done (deserializer_done),

    .cdc_data_out      (cdc_data_out),
    .dst_valid         (dst_valid),

    .debug_req         (debug_req),
    .debug_ack         (debug_ack),
    .debug_req_sync1   (debug_req_sync1),
    .debug_req_sync2   (debug_req_sync2),
    .ejector_data(ejector_data),
    .pixel_count(pixel_count),
    .pixel_done(pixel_done)
);


//==================================================
// TX CLOCK
// HALF PERIOD = 5 ns
// PERIOD      = 10 ns
//==================================================

initial begin

    tx_clk = 1'b0;

    forever #12.5 tx_clk = ~tx_clk;

end


//==================================================
// RX CLOCK
// HALF PERIOD = 7 ns
// PERIOD      = 14 ns
//==================================================

initial begin

    rx_clk = 1'b0;

    forever #7 rx_clk = ~rx_clk;

end


//==================================================
// TRANSACTION TASK
//==================================================

task automatic send_transaction;

    input [62:0] test_data;

begin

    transaction_count = transaction_count + 1;

    $display("");
    $display("================================================");
    $display("        TRANSACTION %0d STARTED",
             transaction_count);
    $display("================================================");

    $display("TIME=%0t : TEST DATA = %h",
             $time,
             test_data);


    //================================================
    // STEP 1 : SEND DATA TO SERIALIZER
    //================================================

    @(negedge tx_clk);

    data_in  = test_data;
    tx_start = 1'b1;

    $display("TIME=%0t : TX_START = 1",
             $time);


    @(negedge tx_clk);

    tx_start = 1'b0;

    $display("TIME=%0t : TX_START = 0",
             $time);


    //================================================
    // STEP 2 : START DESERIALIZER
    //================================================

    @(negedge dut.serial_link_clk);

    rx_start = 1'b1;

    $display("TIME=%0t : RX_START = 1",
            $time);

    @(negedge dut.serial_link_clk);

    rx_start = 1'b0;

    //================================================
    // STEP 3 : WAIT FOR DESERIALIZER
    //================================================

    $display("TIME=%0t : WAITING FOR DESERIALIZER_DONE",
             $time);

    @(posedge deserializer_done);

    $display("TIME=%0t : DESERIALIZER_DONE = 1",
             $time);

    $display("TIME=%0t : DATA_OUT = %h",
             $time,
             data_out);


    //================================================
    // STEP 4 : SERIAL LINK CHECK
    //================================================

    if (data_out == test_data) begin

        $display("SERIAL LINK : PASS");

        pass_count = pass_count + 1;

    end
    else begin

        $display("SERIAL LINK : FAIL");

        $display("EXPECTED = %h",
                 test_data);

        $display("ACTUAL   = %h",
                 data_out);

        fail_count = fail_count + 1;

    end


    //================================================
// WAIT CDC DESTINATION
//================================================

$display("TIME=%0t : WAITING FOR CDC DST_VALID",
         $time);

// Wait for CDC destination
@(posedge dst_valid);

$display("TIME=%0t : DST_VALID = 1",
         $time);

$display("TIME=%0t : CDC_DATA_OUT = %h",
         $time, cdc_data_out);


//================================================
// CDC CHECK
//================================================

if (cdc_data_out == test_data) begin

    $display("CDC : PASS");
    pass_count = pass_count + 1;

end
else begin

    $display("CDC : FAIL");
    $display("EXPECTED = %h", test_data);
    $display("ACTUAL   = %h", cdc_data_out);

    fail_count = fail_count + 1;

end
//================================================
// WAIT FOR PIXEL PROCESSOR
//================================================

    $display("TIME=%0t : WAITING FOR PIXEL PROCESSOR",
            $time);

    @(posedge pixel_done);

    $display("TIME=%0t : PIXEL PROCESSOR DONE",
            $time);

    $display("PIXEL COUNT   = %0d", pixel_count);
    $display("EJECTOR DATA  = %h", ejector_data);

    if ((pixel_count == 13'd4096) &&
        (ejector_data == 63'b1)) begin

        $display("PIXEL PROCESSOR : PASS");
        pass_count = pass_count + 1;

    end
    else begin

        $display("PIXEL PROCESSOR : FAIL");
        $display("EXPECTED COUNT  = 4096");
        $display("ACTUAL COUNT    = %0d", pixel_count);
        $display("EXPECTED EJECTOR = 1");
        $display("ACTUAL EJECTOR   = %h",
                ejector_data);

        fail_count = fail_count + 1;

    end
    ////////////////////
    if ((pixel_count == 13'd4096) &&
        (ejector_data == 63'd1)) begin

        $display("PIXEL PROCESSOR : PASS");
        pass_count = pass_count + 1;

    end
    else begin

        $display("PIXEL PROCESSOR : FAIL");
        fail_count = fail_count + 1;

    end

    //================================================
    // TRANSACTION RESULT
    //================================================

    $display("");
    $display("------------------------------------------------");
    $display("TRANSACTION %0d COMPLETED",
             transaction_count);

    $display("PASS COUNT = %0d",
             pass_count);

    $display("FAIL COUNT = %0d",
             fail_count);

    $display("------------------------------------------------");


end

endtask


//==================================================
// MAIN TEST
//==================================================

initial begin


    //================================================
    // WAVEFORM
    //================================================

    $dumpfile("wave.vcd");

    $dumpvars(0, tb);


    //================================================
    // INITIAL VALUES
    //================================================

    rst      = 1'b1;

    tx_start = 1'b0;

    rx_start = 1'b0;

    data_in  = 63'b0;

    pass_count       = 0;
    fail_count       = 0;
    transaction_count = 0;


    //================================================
    // TEST START
    //================================================

    $display("");
    $display("================================================");
    $display("       SERIAL LINK + CDC TESTBENCH");
    $display("================================================");

    $display("TX CLOCK PERIOD = 10 ns");

    $display("RX CLOCK PERIOD = 14 ns");

    $display("TOTAL TRANSACTIONS = 4");

    $display("================================================");


    //================================================
    // RESET
    //================================================

    #20;

    rst = 1'b0;

    $display("");
    $display("TIME=%0t : RESET RELEASED",
             $time);


    //================================================
    // TRANSACTION 1
    //================================================

    send_transaction(
        63'h123456789ABCDEF
    );

    //================================================
    // GAP
    //================================================

    repeat (5)
        @(negedge tx_clk);


    //================================================
    // TRANSACTION 2
    //================================================

    send_transaction(
        63'h0FEDCBA987654321
    );


    //================================================
    // GAP
    //================================================

    repeat (5)
        @(negedge tx_clk);


    //================================================
    // TRANSACTION 3
    //================================================

    send_transaction(
        63'h155555555555555
    );


    //================================================
    // GAP
    //================================================

    repeat (5)
        @(negedge tx_clk);


    //================================================
    // TRANSACTION 4
    //================================================

    send_transaction(
        63'hAAAAAAAAAAAAAAA
    );


    //================================================
    // FINAL SUMMARY
    //================================================

    $display("");
    $display("================================================");
    $display("             FINAL TEST SUMMARY");
    $display("================================================");

    $display("TOTAL TRANSACTIONS = %0d",
             transaction_count);

    $display("TOTAL PASS         = %0d",
             pass_count);

    $display("TOTAL FAIL         = %0d",
             fail_count);

    $display("================================================");


    if (fail_count == 0) begin

        $display("FINAL RESULT : ALL TESTS PASSED");

    end
    else begin

        $display("FINAL RESULT : TEST FAILED");

    end


    //================================================
    // END SIMULATION
    //================================================

    #50;

    $display("");
    $display("TIME=%0t : SIMULATION FINISHED",
             $time);



    $finish;

end
///
time start_time;
time done_time;

always @(posedge tx_clk) begin
    if (dst_valid) begin
        start_time = $time;
        $display("PIXEL PROCESSOR START = %0t ns", $time);
    end

    if (pixel_done) begin
        done_time = $time;
        $display("PIXEL PROCESSOR DONE  = %0t ns", $time);
        $display("PROCESSING TIME       = %0t ns", done_time - start_time);

        if ((done_time - start_time) <= 56000)
            $display("56 us REQUIREMENT : PASS");
        else
            $display("56 us REQUIREMENT : FAIL");
    end
end
endmodule