module counter_version2 #(parameter N=3)(  
    input clk,rst,load,en_count,
    input [N-1:0]par_load,
    output co,
    output  [N-1:0] W 
);

wire  [N-1:0] en;
 wire out , en_not , v1 ;
assign en[0]=en_count;
genvar i;
    generate
        for (i = 0; i < N-1; i = i + 1) begin : gen_reg
              wire out , en_not ;
            s2 s2_inst (
                .D00(en[i]),
                .D01(en_not),
                .D10(par_load[i]),
                .D11(par_load[i]),
                .A1(load),
                .B1(1'b0),
                .A0(out),
                .B0(1'b1),
                .clr(rst),   
                .clk(clk),
                .out(out)
            );


             c1 not_block (
                .A0(1'b1),
                .A1(1'b0),
                .SA(en[i]),
                .B0(1'b0),
                .B1(1'b0),
                .SB(1'b0),
                .S0(1'b0),
                .S1(1'b0),
                .f(en_not)
            );

            c1 and_block (  //en[i]  & out
                .A0(1'b0),
                .A1(1'b0),
                .SA(1'b0),
                .B0(en[i]),
                .B1(en[i]),
                .SB(1'b0),
                .S0(out),
                .S1(1'b0),
                .f(en[i+1])
            );


            assign W[i]=out;
        end
    endgenerate


    s2 s2_inst (
                .D00(en[N-1]),
                .D01(en_not),
                .D10(par_load[N-1]),
                .D11(par_load[N-1]),
                .A1(load),
                .B1(1'b0),
                .A0(out),
                .B0(1'b1),
                .clr(rst),   
                .clk(clk),
                .out(out)
            );


             c1 not_block (
                .A0(1'b1),
                .A1(1'b0),
                .SA(en[N-1]),
                .B0(1'b0),
                .B1(1'b0),
                .SB(1'b0),
                .S0(1'b0),
                .S1(1'b0),
                .f(en_not)
            );


      c2 U1_c2 (
                .D00(1'b0),
                .D01(1'b0),
                .D10(1'b0),
                .D11(W[0]),
                .A1(W[1]),
                .B1(1'b0),
                .A0(W[2]),
                .B0(W[3]),
                .out(v1)
            );


      c2 U2_c2 (
                .D00(1'b0),
                .D01(1'b0),
                .D10(1'b0),
                .D11(1'b1),
                .A1(v1),
                .B1(1'b0),
                .A0(W[4]),
                .B0(W[5]),
                .out(co)
            );
    assign W[N-1]=out;

  

endmodule