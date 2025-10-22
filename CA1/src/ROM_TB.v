`timescale 1ns / 1ns

module ROM_TB();
    reg clk;
    reg [5:0] address;

    wire [31:0] data_out; 

    ROM #(.BW(32),.N(64)) r1 (address,data_out);
    initial begin  
    clk = 0; 
    forever #5 clk = ~clk;
    end
    initial begin
        address = 6'd5;
        #10
        address = 6'd10;
        #10
        address = 6'd63;
        #20 
        $stop;      
    end
endmodule