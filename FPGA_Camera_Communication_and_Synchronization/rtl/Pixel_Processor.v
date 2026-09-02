module Pixel_Processor(clk,rst,start,done,ejector_data,pixel_count);
input clk,rst,start;
output reg done;
output reg [62:0]ejector_data;
output reg [12:0]pixel_count;
reg [1:0]state;
reg [12:0]count;
parameter  
IDLE_STATE=2'b00,
PROCESS_STATE=2'b01,
DONE_STATE=2'b10;
always @(posedge clk) begin
    if(rst)begin
        done<=1'b0;
        ejector_data<=63'b0;
        pixel_count<=13'd0;
        count<=13'd0;
        state<=IDLE_STATE;
    end
    else begin
         // Default: DONE is a one-clock pulse
         done <= 1'b0;
        case(state)
        //===============================
        // UDLE STATE
        //================================
        IDLE_STATE:begin
            if(start)begin
                count <= 13'd0;
                pixel_count<=13'd0;
                state<=PROCESS_STATE;
        end
            else 
                state<=IDLE_STATE;
        end
        //============================
        // PROCESS STATE
        //========================
        PROCESS_STATE:begin
            if (count>=13'd4096)begin
                count<=13'd4096;
                pixel_count<=13'd4096;
                state<=DONE_STATE;
            end
            else begin
                count<=count+13'd2;
                pixel_count<=pixel_count+13'd2;
                state<=PROCESS_STATE;
        end
        end
        //==========================
        // DONE STATE
        //==========================
        DONE_STATE:begin
            ejector_data<=63'b1;
            done<=1'b1;
            state<=IDLE_STATE;
        end
        //=============================
        //DEFAULT STATE
        //===============================
        default:begin
            done<=1'b0;
            pixel_count<=13'd0;
            ejector_data<=63'b0;
            count<=13'b0;
            state<=IDLE_STATE;
        end
        endcase
    end
end
endmodule
