module Top(clk , rst , start , message,a0,b0,c0,d0 , hash , done);
    input clk , rst , start;
    input [127:0] message;
    input [31:0] a0,b0,c0,d0;
    output [127:0] hash;
    output done;

    wire start_rnd , done_rnd;
    wire [1:0] rnd;
    wire [5:0] out_counter;

    hash_generator h1(clk , rst , start , message,a0,b0,c0,d0 , done_rnd , rnd , start_rnd, out_counter , hash , done);
    random_number_generator r1(clk ,rst  ,start_rnd , out_counter , rnd , done_rnd);

endmodule