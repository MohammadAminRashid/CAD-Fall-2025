module MVM_dp(clk , rst , s1 , encnt1 , encnt2 , encnt3 , encnt4 , d1 , d2 , shift_en , i_valid , co1 , co2 , co3 );
    input clk , rst , s1 , encnt1 , encnt2 , encnt3 , encnt4 , d1 , d2 , shift_en , i_valid;
    output co1 , co2 , co3 ;

    wire write , w2 , w3;
    wire [2:0] outcnt3 , outcnt4;
    wire [3:0] outcnt1;
    wire [6:0] u1 , adr , outcnt2 , w1;
    wire [33:0] w_data , r_data;

    counter #(4)c1 (clk , rst , encnt1 , 2'd3 , co1 , outcnt1 );
    counter #(7)c2 (clk , rst , encnt2 , u1 , co2 , outcnt2 );
    counter #(3)c3 (clk , rst , encnt3 , 3'd7 , co3 , outcnt3);
    counter #(3)c4 (clk , rst , encnt4 , 3'd7 , co4 , outcnt4 );
    mux2to1 #(7)m1 (7'd7, 7'd71,s1,u1);

    adder2 #(7) (outcnt4 , 7'd72 , w1);
    mux2to1 #(7)m2 (outcnt2 , w1 , write , adr);
    ROM #(34, 128) ( adr, w_data,write, r_data);

    assign w2 = &outcnt1;
    assign w3 = !(&outcnt1);
    assign write = w2;
    




endmodule