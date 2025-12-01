module xor_c1(input x, input y, output f);
    c1 c1_inst (
        .A0(1'b0), .A1(1'b1), .SA(x),
        .B0(1'b1), .B1(1'b0), .SB(x),
        .S0(y),    .S1(1'b0),
        .f(f)
    );
endmodule
