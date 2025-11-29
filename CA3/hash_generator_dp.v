module hash_generator_dp #(parameter WORD_WIDTH = 32)(
    input  [4*WORD_WIDTH-1:0] message,
    input  [WORD_WIDTH-1:0] a0, b0, c0, d0, constant,
    input  clk, rst, en,
    input  sa, sb, sc, sd, sf, loada, loadb, loadc, loadd, loadf, loadm,
    input  [1:0] s1,  
    output [4*WORD_WIDTH-1:0] hash,     
    output [5:0] out_counter,
    output co
);

    wire [4*WORD_WIDTH-1:0] M;
    wire [WORD_WIDTH-1:0] A, B, C, D, F, f0;
    wire [WORD_WIDTH-1:0] adder_out_1, adder_out_2, adder_out_3, adder_out_4;
    wire [WORD_WIDTH-1:0] mux4to1_out, left_rotate_out;
    wire [WORD_WIDTH-1:0] parload_a, parload_b, parload_c, parload_d, par_load_f;

    counter #(6) count (clk, rst, en,6'b111111,co,out_counter);

    register #(WORD_WIDTH) Areg(clk, loada, rst, parload_a, A);
    register #(WORD_WIDTH) Breg(clk, loadb, rst, parload_b, B);
    register #(WORD_WIDTH) Creg(clk, loadc, rst, parload_c, C);
    register #(WORD_WIDTH) Dreg(clk, loadd, rst, parload_d, D);
    register #(WORD_WIDTH) Freg(clk, loadf, rst, par_load_f, F);

    register #(4*WORD_WIDTH) Mreg(clk, loadm, rst, message, M);

    mux2to1 #(WORD_WIDTH) muxa(a0, D, sa, parload_a);
    mux2to1 #(WORD_WIDTH) muxb(b0, adder_out_1, sb, parload_b);
    mux2to1 #(WORD_WIDTH) muxc(c0, B, sc, parload_c);
    mux2to1 #(WORD_WIDTH) muxd(d0, C, sd, parload_d);
    mux2to1 #(WORD_WIDTH) muxf(f0, adder_out_2, sf, par_load_f);

    adder #(WORD_WIDTH) adder1(left_rotate_out, B, adder_out_1);
    adder #(WORD_WIDTH) adder2(adder_out_3, adder_out_4, adder_out_2);
    adder #(WORD_WIDTH) adder3(A, constant, adder_out_3);
    adder #(WORD_WIDTH) adder4(F, mux4to1_out, adder_out_4);

    mux4to1 #(WORD_WIDTH) mux_msg (M[4*WORD_WIDTH-1:3*WORD_WIDTH],M[3*WORD_WIDTH-1:2*WORD_WIDTH],M[2*WORD_WIDTH-1:WORD_WIDTH],M[WORD_WIDTH-1: 0],s1,mux4to1_out);

    ALU #(WORD_WIDTH) alu (A, B, C, D, out_counter[5:4], f0);
    left_rotate #(WORD_WIDTH) lf (F, out_counter, left_rotate_out);

    assign hash = {A, B, C, D};

endmodule
