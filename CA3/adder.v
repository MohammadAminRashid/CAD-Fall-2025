module adder #(parameter N = 32)(
    input  [N-1:0] A,
    input  [N-1:0] B,
    input          cin,
    output [N-1:0] SUM,
    output         cout
);

    wire [N:0] C;  
    assign C[0] = cin;

    genvar i;
    generate
        for (i = 0; i < N; i = i + 1) begin : ADD_STAGE
            FA fa_inst (
                .a(A[i]),
                .b(B[i]),
                .cin(C[i]),
                .sum(SUM[i]),
                .cout(C[i+1])
            );
        end
    endgenerate

    assign cout = C[N];

endmodule

