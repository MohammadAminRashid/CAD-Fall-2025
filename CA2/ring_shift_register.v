module ring_shift_register #(parameter N=16)(
    input clk,en_SR, load_SR,
    input [N-1:0] par_load , 
    output  W_MSB
);
    reg [N-1:0] W;   
    always @(posedge clk) begin 
        if (load_SR) 
            W <= par_load;
        else if (en_SR) 
            W<= {W[N-2:0],W[N-1]};
    end
    assign W_MSB = W[N-1];
endmodule