module counter #(parameter N=3)(  
    input clk,rst_count,en_count,
    input [N-1:0]upper_bound,
    output co,
    output reg [N-1:0] W 
);

always @(posedge clk or posedge rst_count) begin
   if(rst_count)
        W<={N{1'b0}};
   else if(en_count)
        W<=W+1;

   
end

   assign co = (W==upper_bound) ? 1 : 0 ;
endmodule