module adder #(parameter N = 8)(
    input  [N-1:0] A,
    input  [N-1:0] B,
    input          cin,
    output [N-1:0] sum
);

    wire [N:0] C;   
    assign C[0] = cin;

    genvar i;
    generate
        for (i = 0; i < N-1; i = i + 1) begin : ADD_STAGE
            FA fa_inst (
                .a(A[i]),
                .b(B[i]),
                .cin(C[i]),
                .sum(sum[i]),
                .cout(C[i+1])
            );
        end
    endgenerate

    wire w_last;
    c1 c1_inst1(1'b0 , 1'b1 , A[N-1] , 1'b1 , 1'b0 , A[N-1] , B[N-1] , 1'b0 , w_last);
    c1 c1_inst2(1'b0 , 1'b1 , w_last , 1'b1 , 1'b0 , w_last , C[N-1] , 1'b0 , sum[N-1]);

endmodule
