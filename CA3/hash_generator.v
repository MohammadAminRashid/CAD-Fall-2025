module hash_generator #(parameter WORD_WIDTH =8)(clk , rst , start , message,a0,b0,c0,d0 , done_rnd , s1 , start_rnd , out_counter , hash , done);
    input clk , rst , start , done_rnd;
    input [1:0] s1;
    input [4*WORD_WIDTH-1:0] message;
    input [WORD_WIDTH-1:0] a0,b0,c0,d0;
    output start_rnd , done;
    output [5:0] out_counter;
    output [4*WORD_WIDTH-1:0] hash;

    wire en ,  s , sf , load , loadf,loadm , co , clear , rst_or_clr;
    wire [WORD_WIDTH-1:0] constant;
   
    or_c1 or_ins (clear, rst, rst_or_clr);
    hash_generator_dp #(WORD_WIDTH) d1(message,a0 , b0 , c0 , d0,constant,clk,rst_or_clr, en ,  s,sf,load,loadm,s1, hash, out_counter, co);

    hash_generator_controller c1(clk , rst , start , co , done_rnd , start_rnd , en , s,sf,load,loadf,loadm , done , clear);

    ROM #(.BW(WORD_WIDTH),.N(64)) r1 (out_counter,constant);


endmodule 