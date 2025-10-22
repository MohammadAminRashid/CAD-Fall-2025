module shift_register #(parameter N=6)(
    input clk,rst,en_SR, load_SR,SerIn,
    input [N-1:0] par_load , 
    output reg [N-1:0] W
);

    always @(posedge clk , posedge rst) begin 
        if(rst)
           W<=0;
        else begin
         if (load_SR) 
            W = par_load ;
         if (en_SR ) 
            W= {W[N-2:0],SerIn};

        end
    end
endmodule