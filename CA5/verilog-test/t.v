`timescale 1ns/1ps

module Top_tb;

  reg clk;
  reg rst;
  reg start;
  reg [31:0] i1, i2 ;
  wire [31:0] result;
  wire done;

  // Instantiate Top module
  Top uut (
    .clk(clk),
    .rst(rst),
    .start(start),
    .i1(i1),
    .i2(i2),
    .result(result),
    .done(done)
  );

  // Clock generation: 10 ns period
  initial clk = 0;
  always #5 clk = ~clk;

  initial begin
    // Initialize signals
    rst = 1;
    start = 0;
    i1 = 32'd0;
    i2 = 32'd0;
    // Apply reset
    #10;
    rst = 0;

    // Apply test inputs
    #10;
    i1 = 32'd1;
    i2 = 32'd3;
    start = 1;

    #10;
    start = 0; // deassert start

    // Wait for done signal
    wait(done == 1);

    // Display result
    $display("Simulation finished. Result = %d", result);

    // Finish simulation
    #10;
    $finish;
  end

  // Optional: monitor signals
  initial begin
    $monitor("Time=%0t clk=%b rst=%b start=%b i1=%d i2=%d result=%d done=%b",
             $time, clk, rst, start, i1, i2, result, done);
  end

endmodule
