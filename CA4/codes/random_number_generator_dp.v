module random_number_generator_dp (
input clk, load_SR, en_SR , en_count , rst_count,
input [5:0] par_load ,
output [1:0] rnd,
output co 
);

wire SerIn;
wire[5:0] out;
wire [2:0] out_counter;
shift_register #(6) sr(clk , en_SR ,load_SR , SerIn , par_load , out );
counter #(3) count(clk,rst_count,en_count,3'b101 , co , out_counter);

xor(SerIn , out[1],out[3] ,out[5]);
assign rnd=out[5:4];

endmodule

