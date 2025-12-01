module mux4to1 #(parameter N = 32) (
    input [N-1:0] A, B, C , D,  
    input [1:0]select,            
    output [N-1:0] Y     
);

genvar i;
generate
    for (i = 0; i < N; i = i + 1) begin : mux_block
        c1 mux_inst (
            .A0(A[i]),
            .A1(B[i]),
            .SA(select[0]),
            .B0(C[i]),
            .B1(D[i]),
            .SB(select[0]),
            .S0(select[1]),
            .S1(1'b0),
            .f(Y[i])
        );
    end
endgenerate
               
endmodule
