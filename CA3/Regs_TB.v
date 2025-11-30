`timescale 1ns / 1ns

module Regs_TB;

    reg clk;
    reg rst, load;
    reg [31:0] par_load_reg;
    wire [31:0] Wreg;

    reg en_SR, load_SR, SerIn;
    reg [7:0] par_load_sr;
    wire [7:0] Wsr;

    register #(32) UREG (
        .clk(clk),
        .load(load),
        .rst(rst),
        .par_load(par_load_reg),
        .W(Wreg)
    );

    shift_register #(8) USR (
        .clk(clk),
        .en_SR(en_SR),
        .load_SR(load_SR),
        .SerIn(SerIn),
        .par_load(par_load_sr),
        .W(Wsr)
    );

    always #5 clk = ~clk;   

    initial begin

        //reg
        clk = 0;

        rst = 1; load = 0; par_load_reg = 0;
        #10;
        rst = 0;

        par_load_reg = 32'hA5A5_F00D;
        load = 1;
        #10;
        load = 0;
        #20;

        //sr
        load_SR = 1; en_SR = 0;
        par_load_sr = 6'b101011;
        #10;
        load_SR = 0;

        SerIn = 1;
        en_SR = 1;
        #10;
        en_SR = 0;
        #20;
        load_SR = 1;
        en_SR   = 1;
        par_load_sr = 6'b000111;
        #10;
        load_SR = 0; en_SR = 0;

        $stop;
    end

endmodule
