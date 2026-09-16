`timescale 1ns/1ps
module Camera_system_top(
    input rst,
    input tx_clk,
    input rx_clk,
    input tx_start,
    input rx_start,
    input [62:0] data_in,
 

    output wire serial_data,
    output wire [62:0] data_out,
    output wire serializer_done,
    output wire deserializer_done,

    output wire [62:0]cdc_data_out,
    output wire dst_valid,
    //
    output wire debug_req,
    output wire debug_ack,
    output wire debug_req_sync1,
    output wire debug_req_sync2,
    //
    output wire [62:0] ejector_data,
    output wire [12:0] pixel_count,
    output wire     pixel_done
);

//==================================================
// INTERNAL SIGNALS
//==================================================

wire serial_link_data;
wire serial_link_clk;
wire cdc_valid;
assign cdc_valid=deserializer_done;

//==================================================
// SERIALIZER
//==================================================

Serializer serial_source(
    .rst(rst),
    .tx_clk(tx_clk),
    .tx_start(tx_start),
    .data_in(data_in),
    .serial_data(serial_data),
    .serializer_done(serializer_done)
);


//==================================================
// SERIAL LINK
//==================================================

Serial_link link(
    .serial_data(serial_data),
    .tx_clk(tx_clk),
    .serial_link_data(serial_link_data),
    .serial_link_clk(serial_link_clk)
);


//==================================================
// DESERIALIZER
//==================================================
Deserializer Deser_block(
    .rst(rst),
    .rx_clk(serial_link_clk),
    .serial_in(serial_link_data),
    .rx_start(rx_start),
    .data_out(data_out),
    .deserializer_done(deserializer_done)
);

CDC cdc_test (
    .rst       (rst),
    .src_clk   (serial_link_clk),
    .dst_clk   (tx_clk),
    .src_data  (data_out),
    .src_valid  (cdc_valid),

    .dst_data  (cdc_data_out),
    .dst_valid (dst_valid),
    //
    .debug_req       (debug_req),
    .debug_ack       (debug_ack),
    .debug_req_sync1 (debug_req_sync1),
    .debug_req_sync2 (debug_req_sync2)
);

//==================================================
// PIXEL PROCESSOR
//==================================================
Pixel_Processor pixel_processor (
    .clk          (tx_clk),
    .rst          (rst),
    .start        (dst_valid),
    .done         (pixel_done),
    .ejector_data (ejector_data),
    .pixel_count  (pixel_count)
);
endmodule
