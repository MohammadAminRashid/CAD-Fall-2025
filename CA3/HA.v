module HA(input x, input y, output sum , output cout);

    xor_c1 xor_c1_inst (
        .x(x), .y(y), .f(sum)
    );
    and_c1 and_c1_inst (
        .x(x), .y(y), .f(cout)
    );
endmodule
