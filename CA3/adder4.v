module adder4 #(parameter N = 8)(
    input  [N-1:0] A,
    input  [N-1:0] B,
    input  [N-1:0] C,
    input  [N-1:0] D,
    input          cin,
    output [N-1:0] sum
);

    wire [N-1:0] S1, S2;

    adder #(N) add1 (
        .A(A),
        .B(B),
        .cin(cin),
        .sum(S1)
    );

    adder #(N) add2 (
        .A(C),
        .B(D),
        .cin(1'b0),
        .sum(S2)
    );

    adder #(N) add3 (
        .A(S1),
        .B(S2),
        .cin(1'b0),
        .sum(sum)
    );

endmodule
