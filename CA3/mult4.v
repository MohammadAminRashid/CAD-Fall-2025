module mult4(
    input [3:0] x,
    input [3:0] y,
    output [7:0] p
);
    wire [3:0] pp0, pp1, pp2, pp3; 
    
    wire pp_0_0, pp_1_0, pp_2_0, pp_3_0; 
    wire pp_0_1, pp_1_1, pp_2_1, pp_3_1; 
    wire pp_0_2, pp_1_2, pp_2_2, pp_3_2; 
    wire pp_0_3, pp_1_3, pp_2_3, pp_3_3; 

    and_c1 a00(.x(x[0]), .y(y[0]), .f(pp_0_0));
    and_c1 a10(.x(x[1]), .y(y[0]), .f(pp_1_0));
    and_c1 a20(.x(x[2]), .y(y[0]), .f(pp_2_0));
    and_c1 a30(.x(x[3]), .y(y[0]), .f(pp_3_0));

    and_c1 a01(.x(x[0]), .y(y[1]), .f(pp_0_1));
    and_c1 a11(.x(x[1]), .y(y[1]), .f(pp_1_1));
    and_c1 a21(.x(x[2]), .y(y[1]), .f(pp_2_1));
    and_c1 a31(.x(x[3]), .y(y[1]), .f(pp_3_1));

    and_c1 a02(.x(x[0]), .y(y[2]), .f(pp_0_2));
    and_c1 a12(.x(x[1]), .y(y[2]), .f(pp_1_2));
    and_c1 a22(.x(x[2]), .y(y[2]), .f(pp_2_2));
    and_c1 a32(.x(x[3]), .y(y[2]), .f(pp_3_2));

    and_c1 a03(.x(x[0]), .y(y[3]), .f(pp_0_3));
    and_c1 a13(.x(x[1]), .y(y[3]), .f(pp_1_3));
    and_c1 a23(.x(x[2]), .y(y[3]), .f(pp_2_3));
    and_c1 a33(.x(x[3]), .y(y[3]), .f(pp_3_3));

    assign p[0] = pp_0_0;

    wire s_ha1, c_ha1;
    wire s_ha2, c_ha2;
    wire s_ha3, c_ha3;

    HA ha1 (
        .x(pp_1_0), 
        .y(pp_0_1), 
        .sum(p[1]),   
        .cout(c_ha1)
    );
    HA ha2 (
        .x(pp_2_0), 
        .y(pp_1_1), 
        .sum(s_ha2), 
        .cout(c_ha2)
    );
    HA ha3 (
        .x(pp_3_0), 
        .y(pp_2_1), 
        .sum(s_ha3), 
        .cout(c_ha3)
    );

    // --------------------------------------------------------
    wire s_fa21, c_fa21;
    wire s_fa22, c_fa22;
    wire s_fa23, c_fa23;

    FA fa21 (
        .a(c_ha1), 
        .b(s_ha2), 
        .cin(pp_0_2), 
        .sum(p[2]),   
        .cout(c_fa21)
    );
    FA fa22 (
        .a(c_ha2), 
        .b(s_ha3), 
        .cin(pp_1_2), 
        .sum(s_fa22), 
        .cout(c_fa22)
    );
    FA fa23 (
        .a(c_ha3), 
        .b(pp_3_1), 
        .cin(pp_2_2), 
        .sum(s_fa23), 
        .cout(c_fa23)
    );

    // --------------------------------------------------------
    wire s_fa31, c_fa31;
    wire s_fa32, c_fa32;
    wire s_fa33, c_fa33;

    FA fa31 (
        .a(c_fa21), 
        .b(s_fa22), 
        .cin(pp_0_3), 
        .sum(p[3]),   
        .cout(c_fa31)
    );
    FA fa32 (
        .a(c_fa22), 
        .b(s_fa23), 
        .cin(pp_1_3), 
        .sum(s_fa32), 
        .cout(c_fa32)
    );
    FA fa33 (
        .a(c_fa23), 
        .b(pp_3_2), 
        .cin(pp_2_3), 
        .sum(s_fa33), 
        .cout(c_fa33)
    );
    // --------------------------------------------------------
    wire c_ha41;
    wire c_fa42;

    HA ha41 (
        .x(c_fa31), 
        .y(s_fa32), 
        .sum(p[4]), 
        .cout(c_ha41)
    );
    FA fa42 (
        .a(c_ha41), 
        .b(s_fa33), 
        .cin(c_fa32), 
        .sum(p[5]), 
        .cout(c_fa42)
    );
    FA fa43 (
        .a(c_fa42), 
        .b(c_fa33), 
        .cin(pp_3_3), 
        .sum(p[6]), 
        .cout(p[7])
    );

endmodule