module random_number_generator(clk ,rst  ,start_rnd , par_load , rnd , done_rnd);
    input clk , rst , start_rnd;
    input [5:0] par_load;
    output [1:0] rnd;
    output done_rnd;
    
    wire load_SR , en_SR , en_count , rst_count , co;

    random_number_generator_dp r1(clk,rst, load_SR , en_SR , en_count , rst_count ,par_load , rnd , co);
    random_number_generator_controller_oh c1(rst , clk, start_rnd , co , load_SR, en_SR, en_count , rst_count, done_rnd);

endmodule