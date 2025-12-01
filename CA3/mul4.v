module mult4(
    input [3:0] x,
    input [3:0] y,
    output [7:0] p
);

    // --------------------------------------------------------
    // 1. Partial Product Generation (x[i] & y[j])
    // --------------------------------------------------------
    wire [3:0] pp0, pp1, pp2, pp3; // pp[row][col] -> pp_y_x effectively

    // We need 16 AND gates. 
    // Format: pp_row_col = x[col] AND y[row]
    // Note: Your diagram labels inputs like x1y0. 
    // I will generate wires named pp_x_y (e.g., pp_1_0) for clarity.
    
    wire pp_0_0, pp_1_0, pp_2_0, pp_3_0; // Row 0 (y=0)
    wire pp_0_1, pp_1_1, pp_2_1, pp_3_1; // Row 1 (y=1)
    wire pp_0_2, pp_1_2, pp_2_2, pp_3_2; // Row 2 (y=2)
    wire pp_0_3, pp_1_3, pp_2_3, pp_3_3; // Row 3 (y=3)

    // Row 0 (y=0)
    and_c1 a00(.x(x[0]), .y(y[0]), .f(pp_0_0));
    and_c1 a10(.x(x[1]), .y(y[0]), .f(pp_1_0));
    and_c1 a20(.x(x[2]), .y(y[0]), .f(pp_2_0));
    and_c1 a30(.x(x[3]), .y(y[0]), .f(pp_3_0));

    // Row 1 (y=1)
    and_c1 a01(.x(x[0]), .y(y[1]), .f(pp_0_1));
    and_c1 a11(.x(x[1]), .y(y[1]), .f(pp_1_1));
    and_c1 a21(.x(x[2]), .y(y[1]), .f(pp_2_1));
    and_c1 a31(.x(x[3]), .y(y[1]), .f(pp_3_1));

    // Row 2 (y=2)
    and_c1 a02(.x(x[0]), .y(y[2]), .f(pp_0_2));
    and_c1 a12(.x(x[1]), .y(y[2]), .f(pp_1_2));
    and_c1 a22(.x(x[2]), .y(y[2]), .f(pp_2_2));
    and_c1 a32(.x(x[3]), .y(y[2]), .f(pp_3_2));

    // Row 3 (y=3)
    and_c1 a03(.x(x[0]), .y(y[3]), .f(pp_0_3));
    and_c1 a13(.x(x[1]), .y(y[3]), .f(pp_1_3));
    and_c1 a23(.x(x[2]), .y(y[3]), .f(pp_2_3));
    and_c1 a33(.x(x[3]), .y(y[3]), .f(pp_3_3));


    // --------------------------------------------------------
    // 2. Output P0
    // --------------------------------------------------------
    assign p[0] = pp_0_0;


    // --------------------------------------------------------
    // 3. First Stage Adders (Top Row of Diagram - HAs)
    // --------------------------------------------------------
    wire s_ha1, c_ha1;
    wire s_ha2, c_ha2;
    wire s_ha3, c_ha3;

    // Rightmost HA (Inputs: x1y0, x0y1) -> Output P1
    HA ha1 (
        .x(pp_1_0), 
        .y(pp_0_1), 
        .sum(p[1]),   // Direct to Output P1
        .cout(c_ha1)
    );

    // Middle HA (Inputs: x2y0, x1y1)
    HA ha2 (
        .x(pp_2_0), 
        .y(pp_1_1), 
        .sum(s_ha2), 
        .cout(c_ha2)
    );

    // Leftmost HA (Inputs: x3y0, x2y1)
    HA ha3 (
        .x(pp_3_0), 
        .y(pp_2_1), 
        .sum(s_ha3), 
        .cout(c_ha3)
    );


    // --------------------------------------------------------
    // 4. Second Stage Adders (Second Row of Diagram - FAs)
    // --------------------------------------------------------
    wire s_fa21, c_fa21;
    wire s_fa22, c_fa22;
    wire s_fa23, c_fa23;

    // Rightmost FA (Inputs: Carry from HA1, Sum from HA2, x0y2) -> Output P2
    FA fa21 (
        .a(c_ha1), 
        .b(s_ha2), 
        .cin(pp_0_2), 
        .sum(p[2]),   // Direct to Output P2
        .cout(c_fa21)
    );

    // Middle FA (Inputs: Carry from HA2, Sum from HA3, x1y2)
    FA fa22 (
        .a(c_ha2), 
        .b(s_ha3), 
        .cin(pp_1_2), 
        .sum(s_fa22), 
        .cout(c_fa22)
    );

    // Leftmost FA (Inputs: Carry from HA3, x3y1, x2y2)
    // Note: x3y1 is the standalone wire coming from top-left in diagram
    FA fa23 (
        .a(c_ha3), 
        .b(pp_3_1), 
        .cin(pp_2_2), 
        .sum(s_fa23), 
        .cout(c_fa23)
    );


    // --------------------------------------------------------
    // 5. Third Stage Adders (Third Row of Diagram - FAs)
    // --------------------------------------------------------
    wire s_fa31, c_fa31;
    wire s_fa32, c_fa32;
    wire s_fa33, c_fa33;

    // Rightmost FA (Inputs: Carry from FA21, Sum from FA22, x0y3) -> Output P3
    FA fa31 (
        .a(c_fa21), 
        .b(s_fa22), 
        .cin(pp_0_3), 
        .sum(p[3]),   // Direct to Output P3
        .cout(c_fa31)
    );

    // Middle FA (Inputs: Carry from FA22, Sum from FA23, x1y3)
    FA fa32 (
        .a(c_fa22), 
        .b(s_fa23), 
        .cin(pp_1_3), 
        .sum(s_fa32), 
        .cout(c_fa32)
    );

    // Leftmost FA (Inputs: Carry from FA23, x3y2, x2y3)
    // Note: x3y2 is the standalone wire coming from top-left
    FA fa33 (
        .a(c_fa23), 
        .b(pp_3_2), 
        .cin(pp_2_3), 
        .sum(s_fa33), 
        .cout(c_fa33)
    );


    // --------------------------------------------------------
    // 6. Final Stage (Bottom Diagonal Row - P4, P5, P6, P7)
    // --------------------------------------------------------
    wire c_ha41;
    wire c_fa42;

    // HA producing P4 (Inputs: Carry from FA31, Sum from FA32)
    HA ha41 (
        .x(c_fa31), 
        .y(s_fa32), 
        .sum(p[4]), 
        .cout(c_ha41)
    );

    // FA producing P5 (Inputs: Carry from HA41, Sum from FA33, Carry from FA32)
    FA fa42 (
        .a(c_ha41), 
        .b(s_fa33), 
        .cin(c_fa32), 
        .sum(p[5]), 
        .cout(c_fa42)
    );

    // FA producing P6 and P7 (Inputs: Carry from FA42, Carry from FA33, x3y3)
    FA fa43 (
        .a(c_fa42), 
        .b(c_fa33), 
        .cin(pp_3_3), 
        .sum(p[6]), 
        .cout(p[7])
    );

endmodule