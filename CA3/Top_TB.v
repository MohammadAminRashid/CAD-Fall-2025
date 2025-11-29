module Top_TB();
    reg clk , rst , start;
    reg [127:0] msg;
    reg [31:0] a0,b0,c0,d0;

    wire [127:0] hash;
    wire done;

    Top #(32)t1 (clk , rst , start , msg ,a0,b0,c0,d0, hash , done);
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
        msg = 128'h6c8728a4103f03b980c436bf819a1a5e;
        #10 rst = 0;
        #10 start = 1;
        #20 start = 0;
        #30000;
        $stop;      
    end
endmodule

