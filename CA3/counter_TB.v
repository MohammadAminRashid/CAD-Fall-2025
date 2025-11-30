`timescale 1ns/1ps

module tb_counter;

parameter N = 3;

reg clk, rst, load, en_count;
reg [N-1:0] par_load;
wire [N-1:0] W;
wire co;

counter #(N) uut (
    .clk(clk),
    .rst(rst),
    .load(load),
    .en_count(en_count),
    .par_load(par_load),
    .co(co),
    .W(W)
);

// ------------------- Clock Generator -------------------
initial begin
    clk = 0;
    forever #5 clk = ~clk;   // کلاک 10ns = 100MHz
end

// ---------------------- Test Logic ----------------------
initial begin
  
    $display("Time\t rst load en_count par_load | W co");

    $monitor("%0t\t %b    %b     %b      %b    | %b %b",
             $time, rst, load, en_count, par_load, W, co);


    rst = 1;
    load = 0;
    en_count = 0;
    par_load = 3'b000;
    #20;

    rst = 0;
    #10;

    $display("\n--- Testing LOAD ---");
    par_load = 3'b101;
    load = 1;
    #10;
    load = 0;
    #20;

    // مرحله ۴: تست counting
    $display("\n--- Testing COUNT ENABLE ---");
    en_count = 1;
    #80;   


    $display("\n--- Testing LOAD again ---");
    par_load = 3'b011;
    load = 1;
    #10;
    load = 0;
    #100;

    en_count=0;
    #100;
    $display("\n--- Simulation Finished ---");
    $stop;
end

endmodule
