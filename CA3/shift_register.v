module shift_register #(parameter N = 6)(
    input clk,
    input en_SR,
    input load_SR,
    input SerIn,
    input  [N-1:0] par_load,
    output [N-1:0] W
);

    s2 s2_bit0 (
        .D00(W[0]),      
        .D01(par_load[0]),    
        .D10(SerIn),           
        .D11(par_load[0]),
        .A1(en_SR ),
        .B1(1'b0),
        .A0(load_SR),
        .B0(1'b1),
        .clr(1'b0),
        .clk(clk),
        .out(W[0])
    );

    genvar i;
    generate
        for (i = 1; i < N; i = i + 1) begin : gen_shift
            s2 s2_inst (
                .D00(W[i]),         
                .D01(par_load[i]),   
                .D10(W[i-1]),        
                .D11(par_load[i]),

                .A1(en_SR),
                .B1(1'b0),
                .A0(load_SR),
                .B0(1'b1),

                .clr(1'b0),
                .clk(clk),
                .out(W[i])
            );
        end
    endgenerate

endmodule
