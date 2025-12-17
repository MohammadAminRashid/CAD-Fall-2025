module Top_TB();
    reg clk , rst , start;
    reg [31:0] msg;
    reg [7:0] a0,b0,c0,d0;

    wire [31:0] hash;
    wire [5:0] out_counter;
    wire [7:0] constant;
    wire done;

    ROM #(.BW(8),.N(64)) r1 (out_counter,constant);
    Top t1 (clk , rst , start , msg ,a0,b0,c0,d0, constant, hash , done ,out_counter);
    initial begin  
    clk = 0; 
    forever #1 clk = ~clk;
    end
    initial begin
        a0 = 8'h01;
        b0 = 8'h89;
        c0 = 8'hfe;
        d0 = 8'h76;
        rst = 1;
        start = 0;
        msg = 32'h3761eded;  
        #10 rst = 0;
        #10 start = 1;
        #20 start = 0;
        #3000;
        $stop;      
    end
endmodule

