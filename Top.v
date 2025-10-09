module Top(clk , rst , start , msg , hash , done);
    input clk , rst , start;
    input [127:0] msg;
    output [127:0] hash;
    output done;

    wire start_rnd , done_rnd;
    wire [1:0] rnd;
    wire [5:0] out_counter;

    hash_generator h1(clk , rst , start , msg , done_rnd , rnd , start_rnd, out_counter , hash , done);
    random_number_generator r1(clk ,rst  ,start_rnd , out_counter , rnd , done_rnd);

endmodule