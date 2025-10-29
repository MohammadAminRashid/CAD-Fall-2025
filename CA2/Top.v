module MVM_top(
    input clk,rst,start,    
    output done     
);

    wire s1, encnt1, encnt2, encnt3, encnt4;
    wire d1, d2, shift_en, i_valid, clear, write , dummy , stripes_rst;
    wire co1, co2, co3;


 MVM_controller cont(clk , rst , start , co1 , co2 , co3 , s1 , encnt1 , encnt2 , encnt3 , encnt4 , d1 , d2 , shift_en , i_valid , clear , write,dummy,stripes_rst,done);


 MVM_dp dp(clk , rst|| clear , s1 , encnt1 , encnt2 , encnt3 , encnt4 , d1 , d2 , shift_en , i_valid,write,dummy,stripes_rst , co1 , co2 , co3 );


endmodule
