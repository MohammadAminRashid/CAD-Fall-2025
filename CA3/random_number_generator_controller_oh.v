module random_number_generator_controller_oh(rst , clk, start_rnd , co , load_SR, en_SR, en_count , rst_count, done_rnd);
    input rst , clk, start_rnd , co ;
    output load_SR, en_SR, en_count , rst_count, done_rnd;

    wire w1 , w2 , w3 , not_start_rnd , not_co , x;

    not_c1 n1(
        .x(start_rnd),
        .f(not_start_rnd)
    );
    not_c1 n2(
        .x(co),
        .f(not_co)
    );
    s2 s2_inst_1 (
                    .D00(1'b0),
                    .D01(1'b1),
                    .D10(1'b1),
                    .D11(1'b1),
                    .A1(w3),
                    .B1(x),
                    .A0(w1),
                    .B0(not_start_rnd),
                    .clr(rst),   
                    .clk(clk),
                    .out(w1)
                );

    s2 s2_inst_2 (
                    .D00(1'b0),
                    .D01(start_rnd),
                    .D10(not_co),
                    .D11(1'b0),
                    .A1(1'b0),
                    .B1(w2),
                    .A0(w1),
                    .B0(1'b1),
                    .clr(rst),   
                    .clk(clk),
                    .out(w2)
                );

    s2 s2_inst_3 (
                    .D00(1'b0),
                    .D01(1'b1),
                    .D10(1'b0),
                    .D11(1'b1),
                    .A1(1'b0),
                    .B1(1'b0),
                    .A0(w2),
                    .B0(co),
                    .clr(rst),   
                    .clk(clk),
                    .out(w3)
                );


        c1 c1_inst_b (
                .A0(1'b1),
                .A1(1'b0),
                .SA(w3),
                .B0(1'b0),
                .B1(1'b0),
                .SB(1'b0),
                .S0(w1),
                .S1(w2),
                .f(x)
            );

    assign load_SR = w1;
    assign rst_count = w1;
    assign en_count = w2;
    assign en_SR = w2;
    assign done_rnd = w3;

endmodule