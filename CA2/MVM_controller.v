module MVM_controller(clk , rst , start , co1 , co2 , co3 , s1 , encnt1 , encnt2 , encnt3 , encnt4 , d1 , d2 , shift_en , i_valid , clear , done);
input clk , rst , start , co1 , co2 , co3;
output reg s1 , encnt1 , encnt2 , encnt3 , encnt4 , d1 , d2 , shift_en , i_valid , clear , done;

reg [2:0] ps , ns;
parameter [2:0] idle = 3'd0 , S1 = 3'd1 , S2 = 3'd2 , S3 = 3'd3 , S4 = 3'd4 , S5 = 3'd5;


always@(ps , start , co1 , co2 , co3) 
    begin
        case(ps)
            idle : if(start == 0) ns=idle;
                    else ns = S1;
            S1 : if(co2 == 0) ns=S1;
                    else ns = S2;
            S2 : if(co3 == 0) ns=S2;
                    else ns = S3;
            S3 : if(co1 == 0) ns=S3;
                    else ns = S4;
            S4 : if(co2 == 0) ns=S2;
                    else ns = S5;
            S5 : ns = idle;
            default : ns = 4'bx;         
        endcase
    end

    always@(ps)
    begin
        s1 = 0; encnt1 = 0; encnt2 = 0; encnt3 = 0; encnt4 = 0; d1 = 0; d2 = 0; shift_en = 0; i_valid = 0; clear = 0; done = 0;
        case(ps) 
            idle: begin clear = 1; end
            S1 : begin d1 = 1 ; encnt2 = 1 ; end
            S2 : begin s1 = 1 ; encnt2 = 1 ; encnt3 = 1;  d2=1 ; end 
            S3 : begin s1 = 1 ; encnt1 = 1 ; encnt4 = 1; i_valid = 1; shift_en = 1; end
            S4 : begin s1 = 1 ;end
            S5 : begin done = 1; end
        endcase 
    end

    always@(posedge clk or posedge rst)
    begin
        if(rst == 1) ps <= idle;
        else ps <= ns; 
    end
endmodule