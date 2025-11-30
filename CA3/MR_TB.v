`timescale 1ns/1ns

module MR_TB;
    reg clk;
    reg rst;
    reg load;
    reg sel;
    reg  [7:0] P0;
    reg  [7:0] P1;
    wire [7:0] W;

    muxed_reg #(8) dut (
        .clk(clk),
        .rst(rst),
        .load(load),
        .sel(sel),
        .P0(P0),
        .P1(P1),
        .W(W)
    );

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        rst  = 1;
        load = 0;
        sel  = 0;
        P0   = 0;
        P1   = 0;

        #20 rst = 0;
        #10 load = 1; sel = 0; P0 = 8'hA5;
        #10 load = 0;
        #20;
        #10 load = 1; sel = 1; P1 = 8'h3C;
        #10 load = 0;
        #20 load = 1; sel = 0; P0 = 8'hF0;
        #10 load = 0;
        #20 rst = 1;
        #10 rst = 0;
        #10 load = 1; sel = 1; P1 = 8'h0F;
        #10 load = 1; sel = 0; P0 = 8'h55;
        #10 load = 0;
        #50 $stop;
    end

endmodule
