module not_c1(input x, output f);
    c1 c1_inst (
        .A0(1'b1), .A1(1'b0), .SA(x),
        .B0(1'b0), .B1(1'b0), .SB(1'b0),
        .S0(1'b0),    .S1(1'b0),
        .f(f)
    );
endmodule
