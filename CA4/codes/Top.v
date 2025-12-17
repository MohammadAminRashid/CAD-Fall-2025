module Top  #(parameter WORD_WIDTH = 32) (clk , rst , start , message,a0,b0,c0,d0 , constant , hash , done , out_counter);
    input clk , rst , start;
    input [4*WORD_WIDTH-1:0] message;
    input [WORD_WIDTH-1:0] a0,b0,c0,d0;
    input [WORD_WIDTH-1:0] constant;
    output [4*WORD_WIDTH-1:0] hash;
    output done;
    output [5:0] out_counter;

    wire start_rnd , done_rnd;
    wire [1:0] rnd;

    hash_generator #(WORD_WIDTH) h1(clk , rst , start , message,a0,b0,c0,d0 , constant , done_rnd , rnd , start_rnd, out_counter , hash , done);
    random_number_generator r1(clk ,rst  ,start_rnd , out_counter , rnd , done_rnd);

endmodule
