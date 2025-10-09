module hash_generator(clk , rst , start , msg , done_rnd , s1 , start_rnd , out_counter , hash , done);
    input clk , rst , start , done_rnd;
    input [1:0] s1;
    input [127:0] msg;
    output start_rnd , done;
    output [5:0] out_counter;
    output [127:0] hash;

    wire en ,  sa , sb , sc , sd , sf , loada , loadb , loadc, loadd , loadf , co;
    wire [31:0] constant;


    hash_generator_dp d1(msg[127:96] , msg[95:64] , msg[63:32] , msg[31:0],constant,clk,rst, en ,  sa , sb , sc , sd,sf,loada, loadb , loadc, loadd,loadf,s1, hash, out_counter, co);

    hash_generator_controller c1(clk , rst , start , co , done_rnd , start_rnd , en ,  sa , sb , sc , sd,sf,loada, loadb , loadc, loadd,loadf , done);

    ROM #(.BW(32),.N(64)) r1 (out_counter,constant);


endmodule 