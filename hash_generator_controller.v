module hash_generator_controller(clk , rst , start , co , done_rnd , start_rnd , en ,  sa , sb , sc , sd,sf,loada, loadb , loadc, loadd,loadf,s1);
input clk , rst , start , co , done_rnd;
output reg en ,  sa , sb , sc , sd,sf,loada, loadb , loadc, loadd,loadf,s1;

reg [3:0] ps , ns;
parameter [3:0] idle = 4'd0 , S1 = 4'd1 , S2 = 4'd2 , S3 = 4'd3 , S4 = 4'd4 , S5 = 4'd5 , S6 = 4'd6 , S7 = 4'd7 , S8 = 4'd8 , S9 = 4'd9 , S10 = 4'd10 , S11 = 4'd11;


always@(ps , start , co , done_rnd) 
    begin
        case(ps)
            idle : if(start == 0) ns=idle;
                    else ns = S1;
            S1 : ns = S2;
            S2 : ns = S3;
            S3 : if(done_rnd == 0) ns=idle;
                    else ns = S1;
            S4 : ns = S5;
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
        load_SR = 0 ; en_SR = 0 ; en_count = 0 ; rst_count = 0 ; done_rnd = 0;
        case(ps)
            idle : begin load_SR = 1 ; rst_count = 1 ; end 
            A : begin en_count = 1 ; en_SR = 1; end
            B : begin done_rnd = 1 ; end 
        endcase 
    end

    always@(posedge clk or posedge rst)
    begin
        if(rst == 1) ps <= idle;
        else ps <= ns; 
    end
endmodule