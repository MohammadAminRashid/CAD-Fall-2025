module hash_generator_controller(clk , rst , start , co , done_rnd , start_rnd , en ,  sa , sb , sc , sd,sf,loada, loadb , loadc, loadd,loadf , done);
input clk , rst , start , co , done_rnd;
output reg start_rnd , en ,  sa , sb , sc , sd,sf,loada, loadb , loadc, loadd,loadf , done;

reg [3:0] ps , ns;
parameter [3:0] idle = 4'd0 , S1 = 4'd1 , S2 = 4'd2 , S3 = 4'd3 , S4 = 4'd4 , S5 = 4'd5 , S6 = 4'd6 , S7 = 4'd7 , S8 = 4'd8 , S9 = 4'd9 , S10 = 4'd10 , S11 = 4'd11;


always@(ps , start , co , done_rnd) 
    begin
        case(ps)
            idle : if(start == 0) ns=idle;
                    else ns = S1;
            S1 : ns = S2;
            S2 : ns = S3;
            S3 : ns = S4;
            S4 : if(done_rnd == 0) ns=S4;
                    else ns = S5;
            S5 : ns = S6;
            S6 : ns = S7;
            S7 : ns = S8;
            S8 : ns = S9;
            S9 :if(co== 0) ns=S11;
                    else ns = S10;
            S10 : ns = idle;
            S11 : ns = S2;
            default : ns = 4'bx;
        endcase
    end

    always@(ps)
    begin
        en = 0 ; sa = 0 ; sb = 0 ; sc = 0 ; sd = 0; sf = 0; loada = 0; loadb = 0; loadc = 0;  loadd = 0; loadf = 0; done = 0 ;
        case(ps) 
            S1 : begin loada = 1 ; loadb = 1 ; loadc = 1 ; loadd = 1 ; end
            S2 : begin loadf = 1 ; end 
            S3 : begin start_rnd = 1 ; end
            S5 : begin loadf = 1 ; sf = 1 ;end
            S6 : begin loada = 1 ; sa = 1 ; end
            S7 : begin loadd = 1 ; sd = 1 ; end
            S8 : begin loadc = 1 ; sc = 1 ; end
            S9 : begin loadb = 1 ; sb = 1 ; end
            S10 : begin done = 1 ; end
            S11 : begin en = 1 ; end
        endcase 
    end

    always@(posedge clk or posedge rst)
    begin
        if(rst == 1) ps <= idle;
        else ps <= ns; 
    end
endmodule