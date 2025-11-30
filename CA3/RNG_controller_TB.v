module tb_rng_controller;

    // Inputs
    reg rst;
    reg clk;
    reg start_rnd;
    reg co;

    // Outputs for Behavioral Module
    wire load_SR_beh, en_SR_beh, en_count_beh, rst_count_beh, done_rnd_beh;

    // Outputs for Structural Module
    wire load_SR_oh, en_SR_oh, en_count_oh, rst_count_oh, done_rnd_oh;

    // Instantiate the Behavioral Unit (Golden Reference)
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

    // Instantiate the Structural Unit (Device Under Test)
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

    // Clock Generation
    always #5 clk = ~clk;

    initial begin
        // Initialize Inputs
        clk = 0;
        rst = 1;
        start_rnd = 0;
        co = 0;

        // Monitor signal changes
        $monitor("Time=%0t | Rst=%b Start=%b Co=%b || BEH State(Load/En/Done): %b/%b/%b || OH State(Load/En/Done): %b/%b/%b", 
                 $time, rst, start_rnd, co, 
                 load_SR_beh, en_SR_beh, done_rnd_beh,
                 load_SR_oh, en_SR_oh, done_rnd_oh);

        // 1. Reset Pulse
        #50;
        rst = 0;
        $display("--- Reset Released ---");

        // 2. Wait in IDLE state
        #20;
        
        // 3. Start signal pulse
        start_rnd = 1;
        #10;
        start_rnd = 0; // Pulse start
        $display("--- Start Signal Pulsed ---");

        // 4. Wait in State A (Counting)
        #30;

        // 5. Assert Carry Out (co) to finish count
        co = 1;
        #10;
        co = 0;
        $display("--- Carry Out Pulsed ---");

        // 6. Should be in State B (Done) then back to Idle
        #20;

        // 7. End Simulation
        #20;
        $finish;
    end
      
endmodule