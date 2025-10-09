module Top_TB();
    reg clk , rst , start;
    reg [127:0] msg;

    wire [127:0] hash;
    wire done;

    Top t1(clk , rst , start , msg , hash , done);
    initial begin  
    clk = 0; 
    forever #1 clk = ~clk;
    end
    initial begin
        rst = 1;
        start = 0;
        msg = 128'h41a801a8e81df62b14a661b85c97bf45;
        #10 rst = 0;
        #10 start = 1;
        #20 start = 0;
        #30000;
        $stop;      
    end
endmodule