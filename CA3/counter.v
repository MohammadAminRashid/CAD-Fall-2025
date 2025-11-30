module counter #(parameter N=3)(  
    input clk,rst,load,en_count,
    input [N-1:0]par_load,
    output co,
    output  [N-1:0] W 
);

wire  [N:0] en;
assign en[0]=en_count;
genvar i;
    generate
        for (i = 0; i < N; i = i + 1) begin : gen_reg
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

    assign co=en[N];

endmodule