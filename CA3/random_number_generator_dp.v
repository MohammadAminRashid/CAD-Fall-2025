module random_number_generator_dp (
input clk, load_SR, en_SR , en_count , rst_count,
input [5:0] par_load ,
output [1:0] rnd,
output co 
);

wire SerIn;
wire w1;
wire[5:0] out;
wire [2:0] out_counter;
shift_register #(6) sr(clk , en_SR ,load_SR , SerIn , par_load , out );
counter #(3) count(clk,rst_count,en_count,3'b101 , co , out_counter);

// xor(SerIn , out[1],out[3] ,out[5]);
c1 c1_inst_1(1'b0 , 1'b1 , out[1] , 1'b1 , 1'b0 , out[1] , out[3] , 1'b0 , w1);
c1 c1_inst_2(1'b0 , 1'b1 , w1 , 1'b1 , 1'b0 , w1 , out[5] , 1'b0 , SerIn);
assign rnd=out[5:4];

endmodule

