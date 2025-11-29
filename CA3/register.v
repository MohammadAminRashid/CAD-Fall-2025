module register #(parameter N=32)(
    input clk,load , reset,
    input [N-1:0] par_load,
    output reg [N-1:0] W
);

    always @(posedge clk or posedge reset) begin 
        if (reset) 
            W <= {N{1'b0}};
        else if (load) 
            W <= par_load;
    end
endmodule