
module adder2 #(parameter N = 34) (
    input [N-1:0] A, B,               
    output [N-1:0] Y     
);
    assign Y = A + B; 
endmodule
