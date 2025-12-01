module and_c1(input x, input y, output f);
    c1 c1_inst (
        .A0(1'b0), .A1(1'b0), .SA(1'b0),
        .B0(y), .B1(y), .SB(1'b0),
        .S0(x),    .S1(1'b0),
        .f(f)
    );
endmodule
