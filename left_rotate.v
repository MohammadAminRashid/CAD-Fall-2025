`define First_Quarter 2'b00            
`define Second_Quarter 2'b01            
`define Third_Quarter  2'b10   
`define Fourth_Quarter 2'b11  

module left_rotate #(parameter N=32)(
    input[N-1:0] inp,
    input [5:0] rotate_index,
    output reg [N-1:0] out 
);

reg [5:0] rotate;

always @(inp,rotate_index) begin
    if(rotate_index[5:4]== `First_Quarter)begin

                    if(rotate_index[1:0]== `First_Quarter)begin
                        rotate=7;
        
                    end
                    else if(rotate_index[1:0]==`Second_Quarter)begin
                        rotate=12;

                    end

                    else if(rotate_index[1:0]==`Third_Quarter) begin
                        rotate=17;

                    end
                    else if(rotate_index[1:0]==`Fourth_Quarter)begin
                        rotate=22;
                    end
        
    end
    else if(rotate_index[5:4]==`Second_Quarter)begin
                    if(rotate_index[1:0]== `First_Quarter)begin
                        rotate=5;
        
                    end
                    else if(rotate_index[1:0]==`Second_Quarter)begin
                        rotate=9;

                    end

                    else if(rotate_index[1:0]==`Third_Quarter) begin
                        rotate=14;

                    end
                    else if(rotate_index[1:0]==`Fourth_Quarter)begin
                        rotate=20;

                    end

    end

    else if(rotate_index[5:4]==`Third_Quarter) begin
                    if(rotate_index[1:0]== `First_Quarter)begin
                        rotate=4;
        
                    end
                    else if(rotate_index[1:0]==`Second_Quarter)begin
                        rotate=11;

                    end

                    else if(rotate_index[1:0]==`Third_Quarter) begin
                        rotate=16;

                    end
                    else if(rotate_index[1:0]==`Fourth_Quarter)begin
                        rotate=23;



                    end

    end
    else if(rotate_index[5:4]==`Fourth_Quarter)begin

                    if(rotate_index[1:0]== `First_Quarter)begin
                        rotate=6;
        
                    end
                    else if(rotate_index[1:0]==`Second_Quarter)begin
                        rotate=10;

                    end

                    else if(rotate_index[1:0]==`Third_Quarter) begin
                        rotate=15;

                    end
                    else if(rotate_index[1:0]==`Fourth_Quarter)begin
                        rotate=21;


                    end

    end


      out = (inp << rotate) | (inp >> (N - rotate));

end


endmodule