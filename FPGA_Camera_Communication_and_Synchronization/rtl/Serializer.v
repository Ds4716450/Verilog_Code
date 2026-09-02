`timescale 1ns/1ps
module Serializer(rst,tx_clk,tx_start,serializer_done,data_in,serial_data);
input rst,tx_clk,tx_start;
input [62:0]data_in;
output reg serial_data;
output reg serializer_done;
reg [62:0]data_reg;
reg [1:0]state;
reg [6:0]count;
parameter IDLE_STATE=2'b00;
parameter LOAD_STATE=2'b01;
parameter SHIFT_STATE=2'b10;
always@(posedge tx_clk) begin
    if (rst) begin
        serial_data<=1'b0;
        data_reg<=63'b0;
        state<=IDLE_STATE;
        serializer_done<=1'b0;
        count<=7'd0;
    end
    else begin
        case(state)
        //===================
        // IDLE STATE
        //==================
        IDLE_STATE: begin
            serializer_done<=1'b0;
            serial_data<=1'b0;
            count<=7'd0;
            if(tx_start)
                state<=LOAD_STATE;
            else
                state<=IDLE_STATE;
        end
        //======================
        // LOAD STATE
        //======================
        LOAD_STATE:begin
            data_reg<=data_in;
            serial_data <= data_in[62];
            count<=7'd0;
            state<=SHIFT_STATE;
        end
        //=======================
        // SHIFT STATE
        //=======================
        SHIFT_STATE:begin
            // Output next bit
            serial_data <= data_reg[61];
            // Shift register
            data_reg<={data_reg[61:0],1'b0};
            if (count==7'd61)begin
               count<=7'd62;
               state<=IDLE_STATE;
               serializer_done<=1'b1;
            end
            else begin
                count<=count+7'd1;
                state<=SHIFT_STATE;
            end
        end
        //====================
        // DEFAULT CASE
        //===================
        default:begin
            state<=IDLE_STATE;
            serial_data<=1'b0;
            data_reg<=63'b0;
            serializer_done<=1'b0;
            count<=7'd0;
        end

        endcase
    end
end
endmodule
