module hash_generator #(parameter WORD_WIDTH = 32)(clk , rst , start , message,a0,b0,c0,d0 , constant , done_rnd , s1 , start_rnd , out_counter , hash , done);
    input clk , rst , start , done_rnd;
    input [1:0] s1;
    input [4*WORD_WIDTH-1:0] message;
    input [WORD_WIDTH-1:0] a0,b0,c0,d0;
    input [WORD_WIDTH-1:0] constant;
    output start_rnd , done;
    output [5:0] out_counter;
    output [4*WORD_WIDTH-1:0] hash;

    wire en ,  s , sf , load , loadf,loadm , co , clear;
    


    hash_generator_dp #(WORD_WIDTH) d1(message,a0 , b0 , c0 , d0,constant,clk,(rst | clear), en ,  s , s, s , s,sf,load, load , load, load,loadf,loadm,s1, hash, out_counter, co);

    hash_generator_controller c1(clk , rst , start , co , done_rnd , start_rnd , en ,  s ,sf,load,loadf,loadm , done , clear);

    


endmodule 