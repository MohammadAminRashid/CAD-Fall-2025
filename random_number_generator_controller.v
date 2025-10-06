module random_number_generator_controller(rst , clk, start_rnd , co , load_SR, en_SR, en_count , rst_count, done_rnd);
input rst , clk, start_rnd , co ;
output reg load_SR, en_SR, en_count , rst_count, done_rnd;

reg [1:0] ps , ns;
parameter [1:0] idle = 2'd0 , A = 2'd1 , B = 2'd2;


always@() 
    begin
        case(ps , start_rnd , co)
            idle : if(start_rnd == 0) ns=idle;
                    else ns = A;
            A : if(co == 0) ns=A;
                else ns = B;
            B : ns = idle;
            default : ns = 3'bx;
        endcase
    end

    always@(*)
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