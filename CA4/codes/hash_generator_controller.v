module hash_generator_controller(clk , rst , start , co , done_rnd , start_rnd , en ,  s ,sf,load,loadf,loadm , done , clear);
input clk , rst , start , co , done_rnd;
output reg start_rnd , en ,  s ,sf,load,loadf,loadm , done , clear;

reg [3:0] ps , ns;
parameter [3:0] idle = 4'd0 , A = 4'd1 , B = 4'd2 , C = 4'd3 , D = 4'd4 , E = 4'd5 , F = 4'd6 , G = 4'd7 , H = 4'd8;


always@(ps , start , co , done_rnd) 
    begin
        case(ps)
            idle : if(start == 0) ns=idle;
                    else ns = A;
            A : if(start == 1) ns=A;
                    else ns = B;
            B : ns = C;
            C : ns = D;
            D : if(done_rnd == 0) ns=D;
                    else ns = E;
            E : ns = F;
            F : if(co== 0) ns = H;
                    else ns = G;
            G : ns = idle;
            H : ns = C;
            default : ns = 4'bx;
        endcase
    end

    always@(ps)
    begin
        start_rnd = 0 ; en = 0 ; s = 0 ; sf = 0; load = 0; loadf = 0; loadm = 0; done = 0 ; clear = 0 ;
        case(ps) 
            A : begin clear = 1 ; end
            B : begin load = 1 ; loadm = 1 ; end
            C : begin loadf = 1 ; start_rnd = 1 ; end 
            D : begin  end
            E : begin loadf = 1 ; sf = 1 ;end
            F : begin load = 1 ; s = 1 ; end
            G : begin done = 1 ; end
            H : begin en = 1 ; end
        endcase 
    end

    always@(posedge clk or posedge rst)
    begin
        if(rst == 1) ps <= idle;
        else ps <= ns; 
    end
endmodule