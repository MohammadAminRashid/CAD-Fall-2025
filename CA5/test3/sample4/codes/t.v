`timescale 1ns/1ps

module Top_TB;

  reg clk;
  reg rst;
  reg start;

  reg [31:0] i1, i2, i3, i4, i5, i6, i7;

  wire [31:0] result;
  wire done;

  // Instantiate DUT
  Top uut (
    .clk(clk),
    .rst(rst),
    .start(start),
    .i1(i1),
    .i2(i2),
    .i3(i3),
    .i4(i4),
    .i5(i5),
    .i6(i6),
    .i7(i7),
    .result(result),
    .done(done)
  );

  // Clock generator
  always #5 clk = ~clk;   // 100 MHz clock

  initial begin
    $display("----- Simulation Start -----");
    
    // Initial values
    clk   = 0;
    rst   = 1;
    start = 0;

    // Apply reset
    #20 rst = 0;
    #20 rst = 1;
    #20 rst = 0;

    // Assign input values
    i1 = 10;
    i2 = 20;
    i3 = 5;
    i4 = 7;
    i5 = 3;
    i6 = 9;
    i7 = 4;


    // Wait a little
    #20;

    // Start computation
    start = 1;
    #10 start = 0;

    // Wait for done
    wait(done == 1);

    $display("DONE signal arrived.");
    $display("RESULT = %d (0x%08h)", result, result);

    #20;

    $display("----- Simulation Finished -----");
    $stop;
  end

endmodule
