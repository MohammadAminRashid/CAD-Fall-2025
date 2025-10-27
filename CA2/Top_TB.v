`timescale 1ns/1ns

module Top_TB;
    reg clk , rst , start ;
    wire done;

    MVM_top m1( clk,rst,start, done);
    always #5 clk = ~clk;

    initial begin
        rst = 1;
        start = 0;
        #12 rst = 0;
        start = 1;
        #12
        start = 0;
        #10000

        $finish;
    end

endmodule
