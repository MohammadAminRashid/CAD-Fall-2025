`timescale 1ns/1ps
module tb_mult4;
    reg  [3:0] A;
    reg  [3:0] B;
    wire [7:0] P;

    mult4 dut (.x(A), .y(B), .p(P));

    initial begin
        A = 4'd0; B = 4'd0; #10;
        A = 4'd1; B = 4'd1; #10;
        A = 4'd3; B = 4'd4; #10;
        A = 4'd7; B = 4'd6; #10;
        A = 4'd15; B = 4'd15; #10;
        A = 4'd9; B = 4'd5; #10;
        A = 4'd12; B = 4'd11; #10;
        A = 4'd2; B = 4'd13; #10;

        $stop;
    end
endmodule