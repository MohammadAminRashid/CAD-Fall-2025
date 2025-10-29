module MVM_dp(clk , rst , s1 , encnt1 , encnt2 , encnt3 , encnt4 , d1 , d2 , shift_en , i_valid ,write,dummy,stripes_rst ,co1 , co2 , co3 );
    input clk , rst , s1 , encnt1 , encnt2 , encnt3 , encnt4 , d1 , d2 , shift_en , i_valid , write , dummy,stripes_rst;
    output co1 , co2 , co3 ;

    wire write , w2 , w3 , co4;
    wire [2:0] outcnt3 ;
    wire [3:0] outcnt1 , outcnt4;
    wire [6:0] u1 , adr , outcnt2 , w1;
    wire [33:0] w_data , r_data , PE1_out , PE2_out;
    wire [7:0] load_a;
    wire [7:0] load_b;

    wire [15:0] B [7:0];
    wire a [7:0];
    wire w4;

    assign w2 = &outcnt1;
    assign w3 = !(|outcnt1);
    // assign write = w2;

    counter #(4)c1 (clk , rst , encnt1 , 4'd15 , co1 , outcnt1 );
    counter #(7)c2 (clk , rst , (encnt2 && !w4)|| dummy , u1 , co2 , outcnt2 );
    counter #(3)c3 (clk , rst , encnt3 , 3'd7 , co3 , outcnt3);
    counter #(4)c4 (clk , rst , encnt4 , 4'd8 , co4 , outcnt4 ); //7 -> 8
    mux2to1 #(7)m1 (7'd7, 7'd71,s1,u1);


    adder2 #(7) address_adder({{3{1'b0}},outcnt4}, 7'd71, w1 );
    mux2to1 #(7)m2 (outcnt2 , w1 , write , adr);
    ROM #(34, 128) ROM_module (clk,adr, w_data,write, r_data);


    demux demux1(d1,outcnt2[2:0],load_a);
    demux demux2(d2,outcnt3[2:0],load_b);

    stripes PE1(clk , rst || stripes_rst , {B[0],B[1],B[2],B[3]}, {a[0],a[1],a[2],a[3]} , 34'd0 , w3 , w2 , i_valid , PE1_out );
    stripes PE2(clk , rst ||stripes_rst , {B[4],B[5],B[6],B[7]}, {a[4],a[5],a[6],a[7]} ,34'd0 , w3 , w2, i_valid , PE2_out );

    adder2 #(34) result_adder(PE2_out,PE1_out , w_data);

    register #(16) B0 (clk , load_b[0],rst ,  r_data , B[0] );
    register #(16) B1 (clk , load_b[1],rst ,  r_data , B[1] );
    register #(16) B2 (clk , load_b[2],rst ,  r_data , B[2] );
    register #(16) B3 (clk , load_b[3],rst ,  r_data , B[3] );
    register #(16) B4 (clk , load_b[4],rst ,  r_data , B[4] );
    register #(16) B5 (clk , load_b[5],rst ,  r_data , B[5] );
    register #(16) B6 (clk , load_b[6],rst ,  r_data , B[6] );
    register #(16) B7 (clk , load_b[7],rst ,  r_data , B[7] );

    register #(1) carry_out (clk , 1,rst ,co2 , w4 );



    ring_shift_register #(16) a0(clk , shift_en , load_a[0] , r_data , a[0] );
    ring_shift_register #(16) a1(clk , shift_en , load_a[1] , r_data , a[1] );
    ring_shift_register #(16) a2(clk , shift_en , load_a[2] , r_data , a[2] );
    ring_shift_register #(16) a3(clk , shift_en , load_a[3] , r_data , a[3] );
    ring_shift_register #(16) a4(clk , shift_en , load_a[4] , r_data , a[4] );
    ring_shift_register #(16) a5(clk , shift_en , load_a[5] , r_data , a[5] );
    ring_shift_register #(16) a6(clk , shift_en , load_a[6] , r_data , a[6] );
    ring_shift_register #(16) a7(clk , shift_en , load_a[7] , r_data , a[7] );

    

endmodule