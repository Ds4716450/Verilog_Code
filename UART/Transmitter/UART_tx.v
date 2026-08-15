module UART_tx(
    tx,
    busy,
    clk,
    rst,
    enb,
    data_in,
    wr_enb
);

input clk, rst, enb, wr_enb;
input [7:0] data_in;

output reg busy;
output reg tx;

reg [1:0] state;
reg [7:0] data_reg;
reg [2:0] index;

parameter IDLE_STATE  = 2'b00;
parameter START_STATE = 2'b01;
parameter DATA_STATE  = 2'b10;
parameter STOP_STATE  = 2'b11;


always @(posedge clk) begin

    if (rst) begin
        data_reg <= 8'b0;
        tx       <= 1'b1;
        busy     <= 1'b0;
        index    <= 3'b0;
        state    <= IDLE_STATE;
    end

    else begin

        case (state)

            //================================
            // IDLE
            //================================
            IDLE_STATE:
            begin
                tx <= 1'b1;

                if (wr_enb) begin
                    busy     <= 1'b1;
                    index    <= 3'd0;
                    data_reg <= data_in;
                    state    <= START_STATE;
                end

                else begin
                    busy  <= 1'b0;
                    state <= IDLE_STATE;
                end
            end


            //================================
            // START BIT
            //================================
            START_STATE:
            begin
                if (enb) begin
                    tx    <= 1'b0;
                    state <= DATA_STATE;
                end
            end


            //================================
            // DATA BITS
            //================================
            DATA_STATE:
            begin
                if (enb) begin

                    tx <= data_reg[index];

                    if (index == 3'd7) begin
                        state <= STOP_STATE;
                    end

                    else begin
                        index <= index + 1'b1;
                    end

                end
            end


            //================================
            // STOP BIT
            //================================
            STOP_STATE:
            begin
                if (enb) begin
                    tx    <= 1'b1;
                    busy  <= 1'b0;
                    state <= IDLE_STATE;
                end
            end


            //================================
            // DEFAULT
            //================================
            default:
            begin
                tx    <= 1'b1;
                busy  <= 1'b0;
                index <= 3'd0;
                state <= IDLE_STATE;
            end

        endcase

    end

end

endmodule
