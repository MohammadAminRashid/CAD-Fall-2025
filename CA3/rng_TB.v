module rng_TB();
    reg clk , rst , start_rnd ;
    reg [5:0] par_load;

    wire [1:0] rnd;
    wire done_rnd;

    random_number_generator r1(clk ,rst  ,start_rnd , par_load , rnd , done_rnd);
    initial begin  
    clk = 0; 
    forever #5 clk = ~clk;
    end
    initial begin
        rst = 1;
        #7;
        rst=0;
        par_load = 6'd51;
        #10
        start_rnd = 1;
        #11 start_rnd = 0;
        #90 
        par_load = 6'd7;
        #10 start_rnd = 1;
        #9 start_rnd = 0;
        #90 
        $stop;      
    end
endmodule