module tb;
reg rst,clk,x;
wire y;
Finite_State_Machine dut (.y(y), .x(x), .clk(clk), .rst(rst));
initial begin
    $dumpfile("wave.vcd");
    $dumpvars(0,tb);
end

task FSM_check;
input x_test; //input variable sequence
input y_test;

begin
    x=x_test;// assign variable
    //@(posedge clk);
    #1;
    if(y==y_test)  // condition
        $display("Pass: y=%b y_test=%b",y,y_test);
    else
        $display("Fail: y=%b y_test=%b",y,y_test);
    @(posedge clk);
end
endtask

// Test sequence/Case
initial begin
    rst=1'b1; //reset/initial condition
    x=1'b0;
    #12 
    rst=1'b0;
    FSM_check(1'b1,1'b0); // follow input variable sequnce
    FSM_check(1'b0,1'b0 );//different case
    FSM_check(1'b1,1'b0 );
    FSM_check(1'b0,1'b1);
    FSM_check(1'b1,1'b0);
    FSM_check(1'b0,1'b1);
    FSM_check(1'b1,1'b0);
$finish;
end

initial begin
    clk=1'b0;
    forever #5 clk=~clk;
end
endmodule
