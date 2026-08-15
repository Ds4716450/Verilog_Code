module UART_Rx(
    input clk,
    input rst,
    input enb,
    input rx_in,
    input rdy_clk,
    output reg rdy,
    output reg [7:0] data_out
);

parameter IDLE_STATE  = 3'b000;
parameter START_STATE = 3'b001;
parameter DATA_STATE  = 3'b010;
parameter STOP_STATE  = 3'b011;
parameter CLEANUP_STATE = 3'b100;

reg [2:0] state;
reg [2:0] index;
reg [3:0] sample;
reg [7:0] data_reg;


always @(posedge clk) begin

    if (rst) begin
        state    <= IDLE_STATE;
        index    <= 3'd0;
        sample   <= 4'd0;
        data_reg <= 8'd0;
        data_out <= 8'd0;
        rdy      <= 1'b0;
    end

    else begin

        // Clear ready signal when host requests it
        if (rdy_clk)
            rdy <= 1'b0;


        if (enb) begin

            case (state)

                //================================
                // IDLE
                //================================
                IDLE_STATE:
                begin
                    sample <= 4'd0;
                    index  <= 3'd0;

                    // UART idle line = 1
                    // Start bit = 0
                    if (rx_in == 1'b0) begin
                        state  <= START_STATE;
                        sample <= 4'd0;
                    end
                    else begin
                        state <= IDLE_STATE;
                    end
                end


                //================================
                // START
                //================================
                START_STATE:
                begin

                    if (sample == 4'd8) begin

                        // Check middle of start bit
                        if (rx_in == 1'b0) begin
                            state  <= DATA_STATE;
                            sample <= 4'd0;
                            index  <= 3'd0;
                        end
                        else begin
                            // False start
                            state  <= IDLE_STATE;
                            sample <= 4'd0;
                        end

                    end

                    else begin
                        sample <= sample + 1'b1;
                    end

                end


                //================================
                // DATA
                //================================
                DATA_STATE:
                begin

                    // Sample in the middle of the bit
                    if (sample == 4'd8) begin
                        data_reg[index] <= rx_in;
                    end


                    // End of this UART bit
                    if (sample == 4'd15) begin

                        sample <= 4'd0;

                        if (index == 3'd7) begin
                            // All 8 data bits received
                            state <= STOP_STATE;
                        end

                        else begin
                            index <= index + 1'b1;
                        end

                    end

                    else begin
                        sample <= sample + 1'b1;
                    end

                end


                //================================
                // STOP
                //================================
                STOP_STATE:
                begin

                    // Check stop bit at middle
                    if (sample == 4'd8) begin

                        if (rx_in == 1'b1) begin
                            state <= CLEANUP_STATE;
                        end

                        else begin
                            // Framing error
                            state <= IDLE_STATE;
                        end

                    end


                    if (sample == 4'd15) begin
                        sample <= 4'd0;
                    end

                    else begin
                        sample <= sample + 1'b1;
                    end

                end


                //================================
                // CLEANUP
                //================================
                CLEANUP_STATE:
                begin
                    data_out <= data_reg;
                    rdy      <= 1'b1;

                    state <= IDLE_STATE;
                    sample <= 4'd0;
                    index  <= 3'd0;
                end


                //================================
                // DEFAULT
                //================================
                default:
                begin
                    state  <= IDLE_STATE;
                    sample <= 4'd0;
                    index  <= 3'd0;
                    rdy    <= 1'b0;
                end

            endcase

        end

    end
end
endmodule
