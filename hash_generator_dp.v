module hash_generator_dp(
    input[127:0] message,
    input[31:0] a0 , b0 , c0 , d0,constant,
    input clk,rst, en ,  sa , sb , sc , sd,sf,loada, loadb , loadc, loadd,loadf,loadm,
    input [1:0]s1,
    output [127:0] hash,
    output [5:0] out_counter,
    output co
);


wire[127:0] M;//add
wire [31:0] A, B, C,D ,F ,f0 ,adder_out_1 , adder_out_2,adder_out_3,adder_out_4, mux4to1_out,
parload_a ,parload_b ,parload_c ,parload_d,par_load_f;


counter #(6) count(clk,rst,en,6'b111111 ,co,out_counter);


register #(32) Areg(clk , loada , rst , parload_a ,A );
register #(32) Breg(clk , loadb , rst , parload_b ,B );
register #(32) Creg(clk , loadc , rst , parload_c ,C );
register #(32) Dreg(clk , loadd , rst , parload_d ,D);
register #(32) Freg(clk , loadf , rst , par_load_f ,F);

register #(128) Mreg(clk , loadm , rst , message ,M); ///add

mux2to1#(32) muxa(a0,D , sa , parload_a);
mux2to1#(32) muxb(b0,adder_out_1 , sb , parload_b);
mux2to1#(32) muxc(c0,B , sc , parload_c);
mux2to1#(32) muxd(d0,C , sd , parload_d);
mux2to1#(32) muxf(f0,adder_out_2 , sf,par_load_f);

adder #(32) adder1(left_rotate_out,B,adder_out_1);

adder #(32) adder2(adder_out_3,adder_out_4 , adder_out_2);
adder #(32) adder3(A,constant,adder_out_3);
adder #(32) adder4(F,mux4to1_out , adder_out_4);

mux4to1 #(32) mux(M[127:96],M[95:64],M[63:32],M[31:0],s1,mux4to1_out);


ALU #(32)alu (A,B,C,D,out_counter[5:4],f0);
left_rotate #(32) lf(F , out_counter , left_rotate_out);

assign hash = {A,B,C,D};

endmodule