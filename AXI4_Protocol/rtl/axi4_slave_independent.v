module axi4_slave_independent #(
    parameter addr_width=4,
    parameter data_width=32,
    parameter depth=16
)(
input clk,
input rst,
//write address channela
input [addr_width-1:0]AWADDR ,
input AWVALID,
output reg  AWREADY,
input [7:0] AWLEN,
input [2:0] AWSIZE,
input [1:0] AWBURST,

// Write Data Channel
input [data_width-1:0] WDATA,
input [data_width/8-1:0] WSTRB,
input WLAST,
input WVALID,
output reg  WREADY,

// Write Response Channel
output reg [1:0] BRESP,
output reg BVALID,
input BREADY,

//Read address channel
input [addr_width-1:0] ARADDR,
input ARVALID,
output reg  ARREADY,
input [7:0] ARLEN,
input [2:0] ARSIZE,
input [1:0] ARBURST,


// Read Data channel
output reg  [data_width-1:0] RDATA,
output reg RLAST,
output reg RVALID,
input RREADY
);
reg [2:0]state;
reg aw_received;
reg w_received;


//finite state machine
parameter IDLE_STATE=3'b000;

parameter Capture_Addr=3'b001;
parameter SEND_DATA=3'b010;
parameter Get_Response=3'b011;
//Recievr side 
parameter READ_ADDR      = 3'b100;
parameter READ_DATA      = 3'b101;

reg [addr_width-1:0] current_addr;
reg [addr_width-1:0] araddr_reg;
reg [data_width-1:0] wdata_reg;
reg [data_width/8-1:0] wstrb_reg;
reg [7:0] burst_len_reg;
reg [2:0] burst_size_reg;
reg [1:0] burst_type_reg;
reg [7:0] beat_count;
reg [addr_width-1:0] wrap_base;
reg [addr_width:0] wrap_boundary;
reg [addr_width-1:0] beat_bytes;

//
// Read Burst Registers
reg [addr_width-1:0] read_current_addr;
reg [7:0] read_burst_len;
reg [2:0] read_burst_size;
reg [1:0] read_burst_type;
reg [7:0] read_beat_count;
reg [addr_width-1:0] read_wrap_base;
reg [addr_width:0] read_wrap_boundary;
reg [addr_width-1:0] read_beat_bytes;

//localparam Okay=2'b00;
// instaiate memory 
reg [data_width-1:0] mem[0:depth-1];

always@(posedge clk) begin
if (rst) begin

    state <= IDLE_STATE;

    AWREADY <= 1'b0;
    WREADY  <= 1'b0;
    BVALID  <= 1'b0;
    BRESP   <= 2'b00;

    ARREADY <= 1'b0;
    RVALID  <= 1'b0;
    RLAST   <= 1'b0;
    RDATA   <= '0;

    aw_received <= 1'b0;
    w_received  <= 1'b0;

    current_addr  <= '0;
    burst_len_reg <= 8'd0;
    burst_size_reg <= 3'd0;
    burst_type_reg <= 2'b00;
    beat_count <= 8'd0;

    wdata_reg <= '0;
    wstrb_reg <= '0;

    read_current_addr <= '0;
    read_burst_len <= 8'd0;
    read_burst_size <= 3'd0;
    read_burst_type <= 2'b00;
    read_beat_count <= 8'd0;

    wrap_base <= '0;
    wrap_boundary <= '0;
    beat_bytes <= '0;

    read_wrap_base <= '0;
    read_wrap_boundary <= '0;
    read_beat_bytes <= '0;

end
    else begin
        case (state)
//=================================
//       IDLE STATE
//================================
    IDLE_STATE: begin

        // Ready for address and data
        AWREADY <= !aw_received;
        WREADY  <= 1'b1;

    //=========================================
    // AW CHANNEL
    //=========================================
    if (AWVALID && AWREADY) begin

        current_addr  <= AWADDR;
        burst_len_reg  <= AWLEN;
        burst_size_reg <= AWSIZE;
        burst_type_reg <= AWBURST;

        beat_bytes <= (1 << AWSIZE);
        wrap_boundary  <= (AWLEN + 1) * (1 << AWSIZE);
        wrap_base <= (AWADDR / ((AWLEN + 1) * (1 << AWSIZE))) *
             ((AWLEN + 1) * (1 << AWSIZE));

        beat_count <= 8'd0;
        aw_received <= 1'b1;
    end


    //=========================================
    // W CHANNEL
    //=========================================
    if (WVALID && WREADY) begin

        // Write current WDATA into current address
        if (WSTRB[0])
            mem[current_addr][7:0] <= WDATA[7:0];

        if (WSTRB[1])
            mem[current_addr][15:8] <= WDATA[15:8];

        if (WSTRB[2])
            mem[current_addr][23:16] <= WDATA[23:16];

        if (WSTRB[3])
            mem[current_addr][31:24] <= WDATA[31:24];


        //=====================================
        // Check last W beat
        //=====================================
        if (WLAST) begin

            beat_count <= beat_count + 1'b1;

            state <= Get_Response;

        end
        else begin

            beat_count <= beat_count + 1'b1;

            // INCR burst address
        if (burst_type_reg == 2'b01) begin

            // INCR burst
            current_addr <= current_addr + beat_bytes;

        end
        else if (burst_type_reg == 2'b00) begin

            // FIXED burst
            current_addr <= current_addr;
 
        end
        else if (burst_type_reg == 2'b10) begin

            // WRAP burst

            if ((current_addr + beat_bytes) >=
                (wrap_base + wrap_boundary)) begin

                current_addr <= wrap_base;

            end
            else begin

                current_addr <= current_addr + beat_bytes;

            end

        end

            state <= IDLE_STATE;

        end

    end


    //================================================
    // 3. If no write transaction is happening,
    //    go to READ_ADDR
    //================================================
    else if (!aw_received && !AWVALID) begin

        state <= READ_ADDR;

    end

end
    //===============================
    // Response  STATE
    //============================
        Get_Response: begin
            BVALID<=1'b1;
            BRESP  <= 2'b00;   
            if (BVALID & BREADY)begin
                state<=IDLE_STATE;
                BVALID<=1'b0;
             // Clear transaction flags
                aw_received <= 1'b0;
                w_received  <= 1'b0;
                // Reset beat counter
                beat_count <= 8'd0;

                state <= IDLE_STATE;
            end
            else
                state <= Get_Response;
        end
    //===============================
    // Read Adrres  STATE
    //============================
    READ_ADDR:begin
        ARREADY<=1'b1;
        if(ARVALID & ARREADY) begin
            read_current_addr<=ARADDR;
            read_burst_len<=ARLEN;
            read_burst_size<=ARSIZE;
            read_burst_type<=ARBURST;
            read_beat_count<= 8'd0;
            ARREADY<=1'b0;

            read_beat_bytes <= (1 << ARSIZE);
            read_wrap_boundary <= (ARLEN + 1) * (1 << ARSIZE);

            if (ARBURST == 2'b10) begin
                read_wrap_base <= (ARADDR / ((ARLEN + 1) * (1 << ARSIZE))) *
                  ((ARLEN + 1) * (1 << ARSIZE));
            end
            state<=READ_DATA;
        end
        else
            state<=READ_ADDR;
        end
    //============================
    // Read DATA  STATE
    //============================
    READ_DATA: begin

    // Present current read data
    RDATA  <= mem[read_current_addr];
    RVALID <= 1'b1;

    // Last beat
    if (read_beat_count == read_burst_len)
        RLAST <= 1'b1;
    else
        RLAST <= 1'b0;


    $display("READ DEBUG: read_addr=%h mem_data=%h beat=%d RVALID=%b RREADY=%b RLAST=%b",
             read_current_addr,
             mem[read_current_addr],
             read_beat_count,
             RVALID,
             RREADY,
             RLAST);
    $display("WRAP DEBUG: type=%b beat_bytes=%d wrap_base=%h wrap_boundary=%h current_addr=%h",
         read_burst_type,
         read_beat_bytes,
         read_wrap_base,
         read_wrap_boundary,
         read_current_addr);

    // Read transfer happens
    if (RVALID && RREADY) begin

        // Last beat completed
        if (read_beat_count == read_burst_len) begin

            RVALID <= 1'b0;
            RLAST  <= 1'b1;

            state <= IDLE_STATE;

        end

        // More beats remaining
        else begin

            read_beat_count <= read_beat_count + 1'b1;

            if (read_burst_type == 2'b01) begin

            // INCR burst
                read_current_addr <= read_current_addr + read_beat_bytes;

        end
            else if (read_burst_type == 2'b00) begin

            // FIXED burst
                read_current_addr <= read_current_addr;
            end
            else if (read_burst_type == 2'b10) begin
                    if ((read_current_addr + read_beat_bytes) >=
                        (read_wrap_base + read_wrap_boundary)) begin

                        read_current_addr <= read_wrap_base;
                        end
                    else 
                        read_current_addr <= read_current_addr + read_beat_bytes;

        end

            state <= READ_DATA;

        end

    end

end
    //============================
    // DEFAULT  STATE
    //============================
        default: begin
            state<=IDLE_STATE;
        end

        endcase
    end
end
endmodule
