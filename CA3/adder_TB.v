`timescale 1ns/1ns

module adder_TB;

    reg  [7:0] A;
    reg  [7:0] B;
    reg  [7:0] C;
    reg  [7:0] D;
    reg  cin;
    wire [7:0] sum;
    wire [7:0] sum1;

    adder #(8) dut (
        .A(A),
        .B(B),
        .cin(cin),
        .sum(sum)
    );

    adder4 #(8) dut1(
        .A(A),
        .B(B),
        .C(C),
        .D(D),
        .cin(cin),
        .sum(sum1)
    );

    initial begin
        C = 8'h00; D = 8'h00;
        A = 8'h00; B = 8'h00; cin = 0;
        #10;

        A = 8'h15; B = 8'h27; cin = 0;   // 21 + 39 = 60
        #10;

        A = 8'h10; B = 8'h20; cin = 0;   // 16 + 32 = 48
        #10;

        A = 8'hAA; B = 8'h55; cin = 0;   // 170 + 85 = 255
        #10;

        A = 8'h3C; B = 8'h12; cin = 0;   // 60 + 18 = 78
        #10;

        A = 8'h7F; B = 8'h02; cin = 0;   // 127 + 2 = 129
        #10;
        
        A = 8'h0C; B = 8'h02; C = 8'h10; D = 8'h03; cin = 0;  // 12+2+16+3=33
        #10;

        A = 8'h1A; B = 8'h05; C = 8'h02; D = 8'h10; cin = 0;  // 26+5+2+16=49
        #10;

        $stop;
    end

endmodule
