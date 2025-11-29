module register #(parameter N = 32)(
    input clk,
    input load,
    input rst,
    input  [N-1:0] par_load,
    output [N-1:0] W
);
    genvar i;
    generate
        for (i = 0; i < N; i = i + 1) begin : gen_reg
            // D00 = hold previous W[i]
            // D01 = parallel load bit
            // D10/D11 = unused (tie 0)
            // A1=B1=0  -> s1 = 0
            // A0=B0=load -> s0 = load
            // -> if load==0 select D00 (hold), if load==1 select D01 (par_load)
            s2 s2_inst (
                .D00(W[i]),
                .D01(par_load[i]),
                .D10(1'b0),
                .D11(1'b0),
                .A1(1'b0),
                .B1(1'b0),
                .A0(load),
                .B0(load),
                .clr(rst),   
                .clk(clk),
                .out(W[i])
            );
        end
    endgenerate
endmodule