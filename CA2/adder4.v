module adder4 #(parameter N = 34) (
    input [N-1:0] A, B,C,D,               
    output [N-1:0] Y     
);
    assign Y=A+B+C+D; 
endmodule
