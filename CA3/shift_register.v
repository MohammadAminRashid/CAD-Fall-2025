module shift_register #(parameter N = 6)(
    input clk,
    input en_SR,
    input load_SR,
    input SerIn,
    input [N-1:0] par_load,
    output [N-1:0] W
);
    genvar i;
    generate
        for (i = 0; i < N; i = i + 1) begin : gen_shift
            // D00 = hold (W[i])
            // D01 = parallel load bit
            // D10 = shifted-in value: bit (i==0 ? SerIn : W[i-1])
            // D11 = unused (tie 0)
            //
            // Control wiring:
            // A1 = en_SR & ~load_SR, B1 = 1'b0  => s1 = en_SR & ~load_SR
            // A0 = load_SR,         B0 = load_SR => s0 = load_SR
            // This yields:
            //  load_SR == 1  -> s1=0, s0=1 -> selects D01 (parallel load)
            //  load_SR == 0 && en_SR == 1 -> s1=1, s0=0 -> selects D10 (shift)
            //  neither -> s1=0, s0=0 -> selects D00 (hold)
            wire d10 = (i == 0) ? SerIn : W[i-1];

            s2 s2_inst_sr (
                .D00(W[i]),
                .D01(par_load[i]),
                .D10(d10),
                .D11(1'b0),
                .A1(en_SR & ~load_SR),
                .B1(1'b0),
                .A0(load_SR),
                .B0(load_SR),
                .clr(1'b0),   
                .clk(clk),
                .out(W[i])
            );
        end
    endgenerate
endmodule