module Deserializer(rst,rx_clk,rx_start,serial_in,deserializer_done,data_out);
input rst,rx_clk,rx_start;
input serial_in;
output reg [62:0] data_out;
output reg deserializer_done;
reg [1:0]state;
reg [6:0]count;
reg [62:0]data_reg;
parameter IDLE_STATE=2'b00;
parameter RECEIVE_STATE=2'b01;
parameter FINAL_STATE=2'b10;
always @(posedge rx_clk)begin
    if(rst)begin
        data_out<=63'b0;
        data_reg<=63'b0;
        deserializer_done<=1'b0;
        count<=7'd0;
        state<=IDLE_STATE;
    end
    else begin
        case(state)
        //===================
        // IDLE STATE
        //===================
        IDLE_STATE:begin
            deserializer_done<=1'b0;
            count<=7'd0;
            if(rx_start)begin
                // Capture FIRST serial bit immediately
                data_reg <= {62'b0, serial_in};
                // First bit captured
                count <= 7'd1;
                state<=RECEIVE_STATE;
            end
            else
                state<=IDLE_STATE;
        end
        //===========================
        // RECEIVER STATE
        //==========================
        RECEIVE_STATE:begin
            if(count==7'd62)begin
                data_out<={data_reg[61:0], serial_in};
                data_reg<={data_reg[61:0],serial_in};
                count<=7'd63;
                deserializer_done<=1'b1;
                state<=FINAL_STATE;
            end
            else begin 
                data_reg <= {data_reg[61:0], serial_in};
                count<=count+7'd1;
                state<=RECEIVE_STATE;
            end
        end
        //========================
        //FINAL STATE
        //=====================
        FINAL_STATE:begin
            deserializer_done<=1'b0;
            state<=IDLE_STATE;
        end
        //======================
        //DEFAULT CASE
        //====================
        default: begin
            data_out<=63'b0;
            data_reg<=63'b0;
            count<=7'd0;
            deserializer_done<=1'b0;
            state<=IDLE_STATE;
        end
        endcase
    end
end
endmodule
