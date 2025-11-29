`timescale 1ns/1ns

module adder_TB;

    reg  [7:0] A;
    reg  [7:0] B;
    reg  cin;
    wire [7:0] SUM;
    wire cout;

    adder #(8) dut (
        .A(A),
        .B(B),
        .cin(cin),
        .SUM(SUM),
        .cout(cout)
    );

    initial begin
        A = 8'h00; B = 8'h00; cin = 0;
        #10;

        A = 8'h15; B = 8'h27; cin = 0;
        #10;

        A = 8'hFF; B = 8'h01; cin = 0;
        #10;

        A = 8'hAA; B = 8'h55; cin = 1;
        #10;

        A = 8'h3C; B = 8'hC3; cin = 0;
        #10;

        A = 8'h7F; B = 8'h02; cin = 1;
        #10;

        $stop;
    end

endmodule
