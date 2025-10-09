module hash_generator(clk , rst , start , message,a0,b0,c0,d0 , done_rnd , s1 , start_rnd , out_counter , hash , done);
    input clk , rst , start , done_rnd;
    input [1:0] s1;
    input [127:0] message;
    input [31:0] a0,b0,c0,d0;
    output start_rnd , done;
    output [5:0] out_counter;
    output [127:0] hash;

    wire en ,  sa , sb , sc , sd , sf , loada , loadb , loadc, loadd , loadf,loadm , co;
    wire [31:0] constant;


    hash_generator_dp d1(message,a0 , b0 , c0 , d0,constant,clk,rst, en ,  sa , sb , sc , sd,sf,loada, loadb , loadc, loadd,loadf,loadm,s1, hash, out_counter, co);

    hash_generator_controller c1(clk , rst , start , co , done_rnd , start_rnd , en ,  sa , sb , sc , sd,sf,loada, loadb , loadc, loadd,loadf,loadm , done);

    ROM #(.BW(32),.N(64)) r1 (out_counter,constant);


endmodule 