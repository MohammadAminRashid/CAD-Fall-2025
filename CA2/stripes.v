module stripes(
    input clk,rst,
    input [0:63] B , 
    input[0:3] A_serial ,
    input[33:0] initial_sum,
    input i_is_msb,i_is_lsb,i_valid,
    output [33:0] out
    );
wire[33:0] I0,I1,I2,I3 ,Y , par_load,accumulator_out , adder_inital_sum_out;
wire [15:0] B0,B1,B2,B3 ,neg_B0,neg_B1,neg_B2,neg_B3;
wire [15:0] mux_out0,mux_out1,mux_out2,mux_out3;
wire [1:0] s0,s1,s2,s3;

assign s0={~A_serial[0] , A_serial[0] & i_is_msb};
assign s1={~A_serial[1] , A_serial[1] & i_is_msb};
assign s2={~A_serial[2] , A_serial[2] & i_is_msb};
assign s3={~A_serial[3] , A_serial[3] & i_is_msb};

assign I0={{18{B0[15]}}, B0};
assign I1={{18{B1[15]}}, B1};
assign I2={{18{B2[15]}}, B2};
assign I3={{18{B3[15]}}, B3};

assign B0=B[0:15];
assign B1=B[16:31];
assign B2=B[32:47];
assign B3=B[48:63];


shift_register #(34) accumulator(clk,1'b1,i_valid,1'b0 , par_load , accumulator_out);
twos_complement #(16) tc0(B0,neg_B0);
twos_complement #(16) tc1(B1,neg_B1);
twos_complement #(16) tc2(B2,neg_B2);
twos_complement #(16) tc3(B3,neg_B3);


mux4to1 #(16) m0(B0,neg_B0,16'b0000000000000000 , 16'bxxxxxxxxxxxxxxxx ,s0 ,mux_out0);
mux4to1 #(16) m1(B1,neg_B1,16'b0000000000000000 , 16'bxxxxxxxxxxxxxxxx ,s1 ,mux_out1);
mux4to1 #(16) m2(B2, neg_B2,16'b0000000000000000 , 16'bxxxxxxxxxxxxxxxx ,s2, mux_out2);
mux4to1 #(16) m3(B3,neg_B3,16'b0000000000000000 , 16'bxxxxxxxxxxxxxxxx , s3,mux_out3);

adder4 #(34) adder1(I0,I1,I2,I3,Y);
adder2 #(34) adder2(Y,accumulator_out,par_load);
adder2 #(34) adder3(accumulator_out , initial_sum ,adder_inital_sum_out );

mux2to1 #(34) mux4(accumulator_out , adder_inital_sum_out, i_is_lsb , out );
endmodule