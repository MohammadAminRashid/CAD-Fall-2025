module muxed_reg #(parameter N = 8)(
    input clk,
    input rst,
    input load,
    input sel,
    input [N-1:0] P0,
    input [N-1:0] P1,
    output [N-1:0] W
);

    genvar i;
    generate
        for (i = 0; i < N; i = i + 1) begin : GEN_S2

            s2 s2_inst (
                .D00(W[i]),       
                .D01(W[i]),     
                .D10(P0[i]),      
                .D11(P1[i]),       
                .A1(load),    
                .B1(1'b0),
                .A0(sel),   
                .B0(1'b1),       
                .clr(rst),
                .clk(clk),
                .out(W[i])
            );

        end
    endgenerate

endmodule
