`timescale 1ns/1ps
/////////////////////////////////////////////////////////////
/////////////HANDSHAKE SOURCE //////////////////////////////
///////////////////////////////////////////////////////////
module Handshake_source(rst,src_data,src_clk,src_valid,ack_src,req_src,src_data_out);
input rst,src_clk,src_valid,ack_src;
input [62:0]src_data;
output reg  req_src;
output reg [62:0]src_data_out;
reg [1:0]state;
reg ack_sync_ff1;
reg ack_sync_ff2;
//reg [62:0]src_data_reg;
parameter  IDLE_STATE=2'b00;
parameter SEND_REQ_STATE=2'b01;
parameter WAIT_ACK_STATE=2'b10;
always @(posedge src_clk) begin
    if(rst)begin
        req_src<=1'b0;
        state<=IDLE_STATE;
        ack_sync_ff1<=1'b0;
        ack_sync_ff2<=1'b0;
        //src_data_reg<=63'b0;
        src_data_out<=63'b0;
    end
    else begin
        //Synchronization ACK from destination
        ack_sync_ff1<=ack_src;
        ack_sync_ff2<=ack_sync_ff1;
    case (state)
    //============================
    // IDLE STATE
    //===========================
    IDLE_STATE:begin
        req_src<=1'b0;
        if(src_valid)
            state<=SEND_REQ_STATE;
        else
            state<=IDLE_STATE;
    end
    //==========================
    // SEND REQUEST
    //==========================
    SEND_REQ_STATE: begin
        req_src<=1'b1;
        //src_data_reg<=src_data;
        src_data_out<=src_data;
        state<=WAIT_ACK_STATE;
    end
    //============================
    // WAIT ACK REQUEST
    //============================
    WAIT_ACK_STATE:begin
        req_src<=1'b1;
        if(ack_sync_ff2)begin
            req_src<=1'b0;
            state<=IDLE_STATE;
        end
        else begin
            state<=WAIT_ACK_STATE;
        end
    end
    //=========================
    // DEFAULT STATE
    //==========================
    default: begin
        req_src<=1'b0;
        state<=IDLE_STATE;
    end
    endcase
    end
end
endmodule

/////////////////////////////////////////////////////////////
/////////// HANDSHAKE DESTINATION///////////////////////////
///////////////////////////////////////////////////////////
module Handshake_Destination(rst,dst_clk,ack_dst,req_dst,data_in,dst_data,dst_valid);
input rst,dst_clk,req_dst;
input [62:0]data_in;
output reg ack_dst;
output reg [62:0]dst_data;
output reg dst_valid;

reg [1:0]state;
reg req_sync_ff1;
reg req_sync_ff2;

parameter IDLE_STATE=2'b00;
parameter WAIT_REQ=2'b01;
parameter CAPTURE_STATE=2'b10;
parameter SEND_ACK=2'b11;
always @(posedge dst_clk)begin
    if(rst)begin
        state<=IDLE_STATE;
        req_sync_ff1<=1'b0;
        req_sync_ff2<=1'b0;
        ack_dst<=1'b0;
        dst_data<=63'b0;
        dst_valid<=1'b0;
    end
    else begin
        // dst_valid is a one-clock pulse
        dst_valid<=1'b0;
        //Synchronization REQ from source
        req_sync_ff1<=req_dst;
        req_sync_ff2<=req_sync_ff1;
        case(state)
        //=======================
        // IDLE STATE
        //=======================
        IDLE_STATE:begin
            ack_dst<=1'b0;
            state<=WAIT_REQ;
        end
        //=========================
        //  WAIT REQUEST
        //========================
        WAIT_REQ: begin 
            ack_dst<=1'b0;
            if (req_sync_ff2)
                state<=CAPTURE_STATE;
            else 
                state<=WAIT_REQ;
            end
        //==========================
        //   CAPTURE STATE
        //========================
        CAPTURE_STATE:begin
            dst_data<=data_in;
            dst_valid<=1'b1;
            ack_dst<=1'b0;
            state<=SEND_ACK;
        end
        //==========================
        // SEND ACK
        //=========================
        SEND_ACK:begin
            ack_dst<=1'b1;
            state<=IDLE_STATE;
        end
        //======================
        // Default state
        //=======================
        default:begin
            ack_dst<=1'b0;
            dst_data<=63'b0;
            dst_valid<=1'b0;
            state<=IDLE_STATE;
        end
        endcase
    end
end
endmodule

//////////////////////////////////////
/////// CDC Module///////////////////
/////////////////////////////////////

module CDC (
    input rst,
    input src_clk,
    input dst_clk,
    input [62:0] src_data,
    input src_valid,

    output wire [62:0] dst_data,
    output wire dst_valid,
    // DEBUG SIGNALS
    output wire debug_req,
    output wire debug_ack,
    output wire debug_req_sync1,
    output wire debug_req_sync2
);

    // wires
    wire req_src;
    wire ack_dst;
    wire [62:0] src_data_out;
    wire [62:0] dst_data_int;
    wire dst_valid_int;
    //
    assign debug_req       = req_src;
    assign debug_ack       = ack_dst;
    assign debug_req_sync1 = u_destination.req_sync_ff1;
    assign debug_req_sync2 = u_destination.req_sync_ff2;

    //=========================================
    // SOURCE
    //=========================================

    Handshake_source u_source (
        .rst          (rst),
        .src_clk      (src_clk),
        .src_valid    (src_valid),
        .src_data     (src_data),
        .ack_src      (ack_dst),
        .req_src      (req_src),
        .src_data_out (src_data_out)
    );
    assign dst_data  = dst_data_int;
    assign dst_valid = dst_valid_int;

    //=========================================
    // DESTINATION
    //=========================================

    Handshake_Destination u_destination (
        .rst      (rst),
        .dst_clk  (dst_clk),
        .ack_dst  (ack_dst),
        .req_dst  (req_src),
        .data_in  (src_data_out),
        .dst_data (dst_data_int),
        .dst_valid (dst_valid_int)
    );

endmodule