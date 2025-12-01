module tb_rng_controller;

    reg rst;
    reg clk;
    reg start_rnd;
    reg co;

    wire load_SR_beh, en_SR_beh, en_count_beh, rst_count_beh, done_rnd_beh;
    wire load_SR_oh, en_SR_oh, en_count_oh, rst_count_oh, done_rnd_oh;

    random_number_generator_controller uut_beh (
        .rst(rst), 
        .clk(clk), 
        .start_rnd(start_rnd), 
        .co(co), 
        .load_SR(load_SR_beh), 
        .en_SR(en_SR_beh), 
        .en_count(en_count_beh), 
        .rst_count(rst_count_beh), 
        .done_rnd(done_rnd_beh)
    );

    random_number_generator_controller_oh uut_struct (
        .rst(rst), 
        .clk(clk), 
        .start_rnd(start_rnd), 
        .co(co), 
        .load_SR(load_SR_oh), 
        .en_SR(en_SR_oh), 
        .en_count(en_count_oh), 
        .rst_count(rst_count_oh), 
        .done_rnd(done_rnd_oh)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 0;
        rst = 1;
        start_rnd = 0;
        co = 0;

        $monitor("Time=%0t | Rst=%b Start=%b Co=%b || BEH State(Load/En/Done): %b/%b/%b || OH State(Load/En/Done): %b/%b/%b", 
                 $time, rst, start_rnd, co, 
                 load_SR_beh, en_SR_beh, done_rnd_beh,
                 load_SR_oh, en_SR_oh, done_rnd_oh);

        #20;
        rst = 0;
        #50
        start_rnd = 1;
        #20;
        start_rnd = 0; 
        #10;
        #30;
        co = 1;
        #10;
        co = 0;
        #20;
        #20;
        $finish;
    end
      
endmodule