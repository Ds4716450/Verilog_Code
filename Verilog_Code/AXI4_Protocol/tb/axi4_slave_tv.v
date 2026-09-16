module tb;
reg clk;
reg rst;
//reg write_enb;
parameter addr_width=4;
parameter data_width=32;
parameter depth=16;
//write address channel
reg [addr_width-1:0]AWADDR ;
reg [7:0] AWLEN;
reg [2:0] AWSIZE;
reg [1:0] AWBURST;
reg AWVALID;
wire AWREADY;
//
integer read_beat;

// Write Data Channel
reg [data_width-1:0] WDATA;
reg [data_width/8-1:0] WSTRB;
reg WLAST;
reg WVALID;
wire WREADY;

// AXI Response Channel
wire[1:0] BRESP;
wire BVALID;
reg BREADY;

//Read address channel
reg [addr_width-1:0] ARADDR;
reg ARVALID;
wire ARREADY;
reg [7:0] ARLEN;
reg [2:0] ARSIZE;
reg [1:0] ARBURST;

// Read Data channel
wire [data_width-1:0] RDATA;
wire RLAST;
wire RVALID;
reg RREADY ;
//DUT
axi4_slave_independent dut (
    .clk     (clk),
    .rst     (rst),
    .AWADDR(AWADDR),
    .AWVALID(AWVALID),
    .AWREADY(AWREADY),
    .AWLEN        (AWLEN),
    .AWSIZE        (AWSIZE),
    .AWBURST       (AWBURST),

    .WDATA(WDATA),
    .WSTRB(WSTRB),
    .WLAST(WLAST),
    .WVALID(WVALID),
    .WREADY(WREADY),

    .BRESP(BRESP),
    .BVALID(BVALID),
    .BREADY(BREADY),
// Read address channel
    .ARADDR  (ARADDR),
    .ARVALID (ARVALID),
    .ARREADY (ARREADY),
    .ARLEN        (ARLEN),
    .ARSIZE        (ARSIZE),
    .ARBURST       (ARBURST),
// Read data channel
    .RDATA   (RDATA),
    .RLAST   (RLAST),
    .RVALID  (RVALID),
    .RREADY  (RREADY)

    //.write_enb    (write_enb) ,
);
//CLOCK
initial begin
    clk=1'b0;
    forever #5 clk=~clk;
end
//waveform
initial begin
    $dumpfile("wave.vcd");
    $dumpvars(0,tb);
end
// Test
// Initial values
initial begin
    $display("========== TESTBENCH STARTED ==========");

    // Initial values
    rst = 1'b1;

    AWADDR  = 0;
    AWLEN   = 0;
    AWSIZE  = 0;
    AWBURST = 0;
    AWVALID = 0;

    WDATA   = 0;
    WSTRB   = 0;
    WLAST   = 0;
    WVALID  = 0;

    BREADY  = 0;

    ARADDR  = 0;
    ARLEN   = 0;
    ARSIZE  = 0;
    ARBURST = 0;
    ARVALID = 0;

    RREADY  = 0;

    read_beat = 0;

    #10;
    rst = 1'b0;

    // Start AXI transaction here
    //write_enb     = 1'b0;

    AWADDR  = 4'b0;
    AWVALID = 1'b0;
    AWLEN   = 8'd3;
    AWSIZE  = 3'd2;
    AWBURST = 2'b01;

    WDATA   = 32'b0;
    WLAST   = 1'b1;
    WVALID  = 1'b0;
    WSTRB   =4'b0000;

    BREADY  = 1'b0;
    read_beat = 0;

    // Reset
   

    dut.mem[4]  = 32'hAAAABBBB;
    dut.mem[8]  = 32'hCCCCDDDD;
    dut.mem[12] = 32'hEEEEFFFF;
    dut.mem[0]  = 32'h12345678;

// Start WRITE transaction


    //===============================
    // WRAP BURST WRITE TEST
    //===============================
    $display("START: WRAP BURST WRITE");

    AWADDR  = 4'h4;
    AWLEN   = 8'd3;
    AWSIZE  = 3'd2;
    AWBURST = 2'b10;

    AWVALID = 1'b1;

    wait (AWREADY == 1'b1);

    $display("WRAP AWREADY became 1 at time=%0t", $time);

    @(posedge clk);
    #1;

    AWVALID = 1'b0;


    //==============================
    // W BEAT 0
    // Address expected = 4
    //==============================

    WDATA  = 32'h11223344;
    WSTRB  = 4'b0001;
    WLAST  = 1'b0;
    WVALID = 1'b1;

    wait (WREADY == 1'b1);
    @(posedge clk);
    #1;

    WVALID = 1'b0;


    //==============================
    // W BEAT 1
    // Address expected = 8
    //==============================

    WDATA  = 32'h55667788;
    WSTRB  = 4'b0010;
    WLAST  = 1'b0;
    WVALID = 1'b1;

    wait (WREADY == 1'b1);
    @(posedge clk);
    #1;

    WVALID = 1'b0;


    //==============================
    // W BEAT 2
    // Address expected = 12
    //==============================

    WDATA  = 32'h99AABBCC;
    WSTRB  = 4'b0100;
    WLAST  = 1'b0;
    WVALID = 1'b1;

    wait (WREADY == 1'b1);
    @(posedge clk);
    #1;

    WVALID = 1'b0;


    //==============================
    // W BEAT 3
    // Address expected = 0
    //==============================

    WDATA  = 32'hDDEEFF00;
    WSTRB  = 4'b1000;
    WLAST  = 1'b1;
    WVALID = 1'b1;

    wait (WREADY == 1'b1);
    @(posedge clk);
    #1;

    WVALID = 1'b0;
    WLAST  = 1'b0;

    $display("WRAP W transaction completed at time=%0t", $time);


    //==============================
    // B RESPONSE
    //==============================

    BREADY = 1'b1;

    wait (BVALID == 1'b1);

    @(posedge clk);
    #1;

    if (BRESP == 2'b00)
        $display("PASS: WRAP BRESP = OKAY");
    else
        $display("FAIL: WRAP BRESP = %b", BRESP);

    BREADY = 1'b0;
    $display(" WRAP W transaction completed at time=%0t", $time);
    // Disable WRITE
    //write_enb = 1'b0;
    /// Memory
    @(posedge clk);
    #1;
    $display("WRAP MEMORY CHECK");

    if (dut.mem[4] == 32'hAAAABB44)
        $display("PASS: MEM[4] = %h", dut.mem[4]);
    else
        $display("FAIL: MEM[4] = %h", dut.mem[4]);

    if (dut.mem[8] == 32'hCCCC77DD)
        $display("PASS: MEM[8] = %h", dut.mem[8]);
    else
        $display("FAIL: MEM[8] = %h", dut.mem[8]);

    if (dut.mem[12] == 32'hEEAAFFFF)
        $display("PASS: MEM[12] = %h", dut.mem[12]);
    else
        $display("FAIL: MEM[12] = %h", dut.mem[12]);

    if (dut.mem[0] == 32'hDD345678)
        $display("PASS: MEM[0] = %h", dut.mem[0]);
    else
        $display("FAIL: MEM[0] = %h", dut.mem[0]);
    BREADY = 1'b0;
    //write_enb = 1'b0;
    @(posedge clk);
    #1;
    //===============================
    // BURST READ TEST
    //===============================

    $display("START: BURST READ");

    ARADDR  = 4'h4;
    ARLEN   = 8'd3;
    ARSIZE  = 3'd2;
    ARBURST = 2'b10;

    ARVALID = 1'b1;

    wait (ARREADY == 1'b1);

    $display("ARREADY became 1 at time=%0t", $time);

    @(posedge clk);
    #1;

    ARVALID = 1'b0;

    $display("AR transaction completed at time=%0t", $time);


    //===============================
    // RECEIVE READ DATA
    //===============================

    RREADY = 1'b0;

    $display("TEST: RREADY = 0, master is NOT ready");

    wait (RVALID == 1'b1);

    @(posedge clk);
    #1;

    $display("STALL: RVALID=%b RREADY=%b RDATA=%h RLAST=%b beat=%d addr=%h",
            RVALID,
            RREADY,
            RDATA,
            RLAST,
            read_beat,
            dut.read_current_addr);


    //------------------------------------
    // Now allow the transfer
    //------------------------------------
    RREADY = 1'b1;


    repeat(4) begin

    wait (RVALID == 1'b1);

    @(posedge clk);
    #1;

    if (read_beat == 0 &&
        RDATA == 32'hAAAABB44 &&
        RLAST == 1'b0)
        $display("PASS: READ BEAT 0 = %h", RDATA);

    else if (read_beat == 1 &&
             RDATA == 32'hCCCC77DD &&
             RLAST == 1'b0)
        $display("PASS: READ BEAT 1 = %h", RDATA);

    else if (read_beat == 2 &&
             RDATA == 32'hEEAAFFFF &&
             RLAST == 1'b0)
        $display("PASS: READ BEAT 2 = %h", RDATA);

    else if (read_beat == 3 &&
             RDATA == 32'hDD345678 &&
             RLAST == 1'b1)
        $display("PASS: READ BEAT 3 = %h, RLAST=1", RDATA);

    else
        $display("FAIL: READ beat=%0d RDATA=%h RLAST=%b",
                 read_beat,
                 RDATA,
                 RLAST);
    read_beat = read_beat + 1;

end

    RREADY = 1'b0;

    #20;
    $finish;

end
initial begin
    #1000;
    $display("ERROR: TESTBENCH TIMEOUT at time=%0t", $time);
    $finish;
end
endmodule
