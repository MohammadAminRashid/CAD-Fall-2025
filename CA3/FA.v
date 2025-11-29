module FA(a , b , cin , sum , cout);
    input a , b , cin;
    output sum ,cout;

    wire w1;

    c1 c1_inst_1(1'b0 , 1'b1 , a , 1'b1 , 1'b0 , a , b , 1'b0 , w1);
    c1 c1_inst_2(1'b0 , 1'b1 , w1 , 1'b1 , 1'b0 , w1 , cin , 1'b0 , sum);
    c2 c2_inst(1'b0 , 1'b0 , cin , 1'b1 , a , b , a , b , cout);
endmodule