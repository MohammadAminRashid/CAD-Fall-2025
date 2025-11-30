`define First_Quarter 2'b00            
`define Second_Quarter 2'b01            
`define Third_Quarter  2'b10   
`define Fourth_Quarter 2'b11                 




module ALU #(parameter N=8)(
 input [N-1:0] A,B,C,D,
 input [1:0] opc,
 output  [N-1:0] out
  );
genvar i;
generate
    for (i = 0; i < N; i = i + 1) begin : alu_bit
        wire bit_out;
        wire a_out , b_out , c_out , d_out ;
          c1 c1_inst_a (
                .A0(1'b1),
                .A1(1'b0),
                .SA(B[i]),
                .B0(1'b1),
                .B1(1'b0),
                .SB(D[i]),
                .S0(opc[0]),
                .S1(1'b0),
                .f(a_out)
            );

                c1 c1_inst_b (
                .A0(C[i]),
                .A1(B[i]),
                .SA(opc[0]),
                .B0(D[i]),
                .B1(C[i]),
                .SB(opc[0]),
                .S0(a_out),
                .S1(1'b0),
                .f(b_out)
            );


                c1 c1_inst_c (
                .A0(B[i]),
                .A1(a_out),
                .SA(D[i]),
                .B0(a_out),
                .B1(1'b1),
                .SB(B[i]),
                .S0(opc[0]),
                .S1(1'b0),
                .f(c_out)
            );


                c1 c1_inst_d (
                .A0(1'b0),
                .A1(1'b1),
                .SA(c_out),
                .B0(1'b1),
                .B1(1'b0),
                .SB(c_out),
                .S0(C[i]),
                .S1(1'b0),
                .f(d_out)
            );

                c1 c1_inst_e (
                .A0(b_out),
                .A1(b_out),
                .SA(1'b0),
                .B0(d_out),
                .B1(d_out),
                .SB(1'b0),
                .S0(opc[1]),
                .S1(1'b0),
                .f(bit_out)
            );
        assign out[i] = bit_out;
    end
endgenerate

endmodule



// module ALU_p #(parameter N=8)(
// input [N-1:0] A,B,C,D,
// input [1:0] opc,

// output reg [N-1:0] out
// );

//  always @(A,B,C,D,opc) begin 

//     case(opc)

//     `First_Quarter: out= (B & C) | ((~B) & D) ;
//     `Second_Quarter: out= (D & B) | ((~D) & C);
//     `Third_Quarter: out= B ^ C ^ D;
//     `Fourth_Quarter : out= C ^ (B |(~D) ) ;
//     default:out=0;

//     endcase

//   end
// endmodule


