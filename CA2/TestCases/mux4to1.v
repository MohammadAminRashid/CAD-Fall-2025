module mux4to1 #(parameter N = 34) (
    input [N-1:0] A, B, C , D,  
    input [1:0]select,            
    output [N-1:0] Y     
);
    assign Y = (select==2'b00) ? A :
               (select==2'b01) ? B :
               (select==2'b10) ? C :
               (select==2'b11) ? D :
               {N{1'b0}};
               
endmodule