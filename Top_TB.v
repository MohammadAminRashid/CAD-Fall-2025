module Top_TB #(parameter WORD_WIDTH = 32)();
    reg clk , rst , start;
    reg [4*WORD_WIDTH-1:0] msg;
    reg [WORD_WIDTH-1:0] a0,b0,c0,d0;

    wire [4*WORD_WIDTH-1:0] hash;
    wire done;

    Top t1(clk , rst , start , msg ,a0,b0,c0,d0, hash , done);
    initial begin  
    clk = 0; 
    forever #1 clk = ~clk;
    end
    initial begin
        a0=32'h67452301;
        b0=32'hefcdab89;
        c0=32'h98badcfe;
        d0=32'h10325476;
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