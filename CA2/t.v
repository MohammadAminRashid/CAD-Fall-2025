`timescale 1ns/1ns

module stripes_tb;

    reg clk, rst;
    reg [0:63] B;
    reg [0:3] A_serial;
    reg [33:0] initial_sum;
    reg i_is_msb, i_is_lsb, i_valid;
    wire [33:0] out;

    stripes dut (
        .clk(clk),
        .rst(rst),
        .B(B),
        .A_serial(A_serial),
        .initial_sum(initial_sum),
        .i_is_msb(i_is_msb),
        .i_is_lsb(i_is_lsb),
        .i_valid(i_valid),
        .out(out)
    );

    always #5 clk = ~clk;

    initial begin
        #1
        clk = 0;
        rst = 1;
        B = 64'h0003_0005_0005_0001;
        A_serial = 4'b0000;
        initial_sum = 34'd0;
        i_is_msb = 0;
        i_is_lsb = 0;
        i_valid = 0;
        #2 rst=0;

        #2
        i_is_msb = 1;
        A_serial = 4'b0000;
        i_valid = 1;
        #12
        i_is_msb=0;
            A_serial = 4'b0000;
        #10
            A_serial = 4'b0000;
        #10
            A_serial = 4'b0000;
        #10
            A_serial = 4'b0000;
        #10
            A_serial = 4'b0000;
        #10
            A_serial = 4'b0000;
        #10
            A_serial = 4'b0000;
        #10
            A_serial = 4'b0000;
        #10
            A_serial = 4'b0000;
        #10
            A_serial = 4'b0000;
        #10
            A_serial = 4'b0000;
        #10
            A_serial = 4'b0010;
        #10
            A_serial = 4'b0111;
        #10
            i_is_lsb=1;
            A_serial = 4'b1100;
        #10
        i_is_lsb=0;
        #10
        #30

        $finish;
    end

endmodule
