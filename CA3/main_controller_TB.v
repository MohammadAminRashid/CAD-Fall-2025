`timescale 1ns/1ps

module tb_hash_generator_controller;

    reg clk;
    reg rst;
    reg start;
    reg co;
    reg done_rnd;

    wire start_rnd;
    wire en;
    wire s;
    wire sf;
    wire load;
    wire loadf;
    wire loadm;
    wire done;

    hash_generator_controller DUT (
        .clk(clk),
        .rst(rst),
        .start(start),
        .co(co),
        .done_rnd(done_rnd),
        .start_rnd(start_rnd),
        .en(en),
        .s(s),
        .sf(sf),
        .load(load),
        .loadf(loadf),
        .loadm(loadm),
        .done(done)
    );

    // =============================
    // Clock Generator: 10ns period
    // =============================
    initial clk = 0;
    always #5 clk = ~clk;

    // =============================
    // Initial Stimulus
    // =============================
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0, tb_hash_generator_controller);

        rst = 1;
        start = 0;
        co = 0;
        done_rnd = 0;

        // Reset pulse
        #20;
        rst = 0;
        #10;

        // =============================
        // Test Sequence
        // =============================

        $display("=== Apply start pulse ===");
        start = 1;
        #10;
        start = 0;

        #50;

        $display("=== Simulate done_rnd ===");
        done_rnd = 1;
        #20;
        done_rnd = 0;

        #40;
        $display("=== Trigger co ===");
        co = 1;
        #10;
        co = 0;

        #100;
        done_rnd=1;
        co=1;
        #20;
        done_rnd=0;
        #50;
        start=1;
        #100

        $display("=== Test finished ===");
        $finish;
    end

    initial begin
        $monitor("[%0t] rst=%b start=%b co=%b done_rnd=%b  || start_rnd=%b en=%b s=%b sf=%b load=%b loadf=%b loadm=%b done=%b",
            $time, rst, start, co, done_rnd, start_rnd, en, s, sf, load, loadf, loadm, done
        );
    end

endmodule
