module full_TB();

    reg clk, rst, start;
    reg [31:0] msg;
    reg [7:0] a0, b0, c0, d0;

    wire [31:0] hash;
    wire done;

    integer fd;             
    integer fd_results;     
    integer fd_gold;        
    integer status;         
    integer status_gold;    
    integer i;             
    integer error_count;   

    reg [31:0] expected_hash;
    wire [5:0] out_counter;
    wire [7:0] constant;

    ROM #(.BW(8),.N(64)) r1 (out_counter,constant);
    Top t1 (
        clk, rst, start, msg,
        a0, b0, c0, d0,
        constant, hash , done ,out_counter
    );

    initial begin
        clk = 0;
        forever #1 clk = ~clk;
    end

    initial begin
        a0 = 8'h01;
        b0 = 8'h89;
        c0 = 8'hfe;
        d0 = 8'h76;

        rst = 1;
        start = 0;
        msg = 0;
        error_count = 0;

        #10 rst = 0;

        fd = $fopen("testcase.txt", "r");
        if (fd == 0) begin
            $display("ERROR: cannot open testcase.txt");
            $stop;
        end

        fd_results = $fopen("hash_results.txt", "w");
        if (fd_results == 0) begin
            $display("ERROR: cannot create hash_results.txt");
            $stop;
        end

        fd_gold = $fopen("out_hw.txt", "r");
        if (fd_gold == 0) begin
            $display("ERROR: cannot open out_hw.txt");
            $stop;
        end

        for (i = 0; i < 64; i = i + 1) begin
            
            status = $fscanf(fd, "%h\n", msg);
            status_gold = $fscanf(fd_gold, "%h\n", expected_hash);

            if (status != 1) begin
                $display("ERROR: invalid format or end of file in testcase.txt at line %0d", i+1);
                $stop;
            end
            if (status_gold != 1) begin
                $display("ERROR: invalid format or end of file in out_hw.txt at line %0d", i+1);
                $stop;
            end

            $display("\n==============================");
            $display("TEST CASE [%0d]", i);
            $display("MSG Input     : %h", msg);

            start = 1;
            #20 start = 0;

            wait(done == 1);
            $fdisplay(fd_results, "%h", hash);
            if (hash !== expected_hash) begin
                $display("STATUS        : [FAILED] X");
                $display("Calculated    : %h", hash);
                $display("Expected      : %h", expected_hash);
                error_count = error_count + 1;
            end else begin
                $display("STATUS        : [PASSED]");
                $display("Hash Output   : %h", hash);
            end
            #5;
        end
        $fclose(fd);
        $fclose(fd_results);
        $fclose(fd_gold);

        $display("\n==============================");
        $display("SIMULATION COMPLETE");
        if (error_count == 0) begin
            $display("ALL TESTS PASSED SUCCESSFULLY.");
        end else begin
            $display("TOTAL FAILURES: %0d", error_count);
        end
        $display("==============================");
        
        $stop;
    end
endmodule