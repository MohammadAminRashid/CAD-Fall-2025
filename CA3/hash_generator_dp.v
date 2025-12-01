module hash_generator_dp #(parameter WORD_WIDTH = 8)(
    input  [4*WORD_WIDTH-1:0] message,
    input  [WORD_WIDTH-1:0] a0, b0, c0, d0, constant,
    input  clk, rst, en,
    input  s,sf,load,loadf,loadm,
    input  [1:0] s1,  
    output [4*WORD_WIDTH-1:0] hash,     
    output [5:0] out_counter,
    output co
);

    wire [4*WORD_WIDTH-1:0] M;
    wire [WORD_WIDTH-1:0] A, B, C, D, F, f0;
    wire [WORD_WIDTH-1:0] adder_out_1, adder_out_2, adder_out_3, adder_out_4;
    wire [WORD_WIDTH-1:0] mux4to1_out, mult_out;
    wire [WORD_WIDTH-1:0] parload_a, parload_b, parload_c, parload_d, par_load_f;

    counter #(6) count (clk, rst ,rst, en,6'b000000,co,out_counter);

    muxed_register #(WORD_WIDTH) Areg(clk, rst, load , s , a0 , D, A);
    muxed_register #(WORD_WIDTH) Breg(clk, rst, load , s , b0 ,adder_out_1, B);
    muxed_register #(WORD_WIDTH) Creg(clk, rst, load , s , c0 ,B, C);
    muxed_register #(WORD_WIDTH) Dreg(clk, rst, load , s , d0 ,C, D);
    muxed_register #(WORD_WIDTH) Freg(clk, rst, loadf , sf ,f0 ,adder_out_2 , F);

    register #(4*WORD_WIDTH) Mreg(clk, loadm, rst, message, M);

    adder #(WORD_WIDTH) adder1(mult_out, B, adder_out_1);
    adder4 #(WORD_WIDTH) adder2 (A , constant , F , mux4to1_out , 1'b0 , adder_out_2);

    mux4to1 #(WORD_WIDTH) mux_msg (M[4*WORD_WIDTH-1:3*WORD_WIDTH],M[3*WORD_WIDTH-1:2*WORD_WIDTH],M[2*WORD_WIDTH-1:WORD_WIDTH],M[WORD_WIDTH-1: 0],s1,mux4to1_out);

    ALU #(WORD_WIDTH) alu (A, B, C, D, out_counter[5:4], f0);
    mult4 mul (F[WORD_WIDTH-1:WORD_WIDTH/2], F[WORD_WIDTH/2-1:0], mult_out);

    assign hash = {A, B, C, D};

endmodule
