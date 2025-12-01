// module Top_TB();
//     reg clk , rst , start;
//     reg [31:0] msg;
//     reg [7:0] a0,b0,c0,d0;

//     wire [31:0] hash;
//     wire done;

//     Top #(8)t1 (clk , rst , start , msg ,a0,b0,c0,d0, hash , done);
//     initial begin  
//     clk = 0; 
//     forever #1 clk = ~clk;
//     end
//     initial begin
//         a0=8'h01;
//         b0=8'h89;
//         c0=8'hfe;
//         d0=8'h76;
//         rst = 1;
//         start = 0;
//         msg = 32'h3761eded;
//         #10 rst = 0;
//         #10 start = 1;
//         #20 start = 0;
//         #3000;
//         $stop;      
//     end
// endmodule


module Top_TB();

    reg clk , rst , start;
    reg [31:0] msg;
    reg [7:0] a0,b0,c0,d0;

    wire [31:0] hash;
    wire done;

    integer fd;           // file descriptor
    integer status;       // read status
    integer i;            // loop index

    Top #(8) t1 (
        clk , rst , start , msg ,
        a0 , b0 , c0 , d0 ,
        hash , done
    );

    // clock generator
    initial begin  
        clk = 0; 
        forever #1 clk = ~clk;
    end

    initial begin
        // init
        a0 = 8'h01;
        b0 = 8'h89;
        c0 = 8'hfe;
        d0 = 8'h76;

        rst = 1;
        start = 0;
        msg = 0;

        #10 rst = 0;

        // open file
        fd = $fopen("testcase.txt","r");
        if(fd == 0) begin
            $display("ERROR: cannot open testcase.txt");
            $stop;
        end

        // read 64 messages from file
        for(i = 0; i < 64; i = i + 1) begin
            
            // read one hex value
            status = $fscanf(fd, "%h\n", msg);
            if(status != 1) begin
                $display("ERROR: invalid format in testcase.txt at line %0d", i+1);
                $stop;
            end

            $display("\n==============================");
            $display("MSG[%0d] = %h", i, msg);

            // trigger start
            start = 1;
            #20 start = 0;

            // wait for done
            wait(done == 1);

            // print hash
            $display("HASH[%0d] = %h", i, hash);

            // small delay between tests
            #5;
        end

        $fclose(fd);
        $stop;
    end
endmodule
