module twos_complement #(parameter N = 16) (
    input [N-1:0] A,               
    output [N-1:0] Y     
);
    assign Y = (~A)+1; 
endmodule
