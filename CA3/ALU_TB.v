`timescale 1ns/1ps

module tb_ALU;

    parameter N = 8;

    reg [N-1:0] A, B, C, D;
    reg [1:0] opc;

    wire [N-1:0] out_gen;
    wire [N-1:0] out_p;

    integer t, i;

 
    ALU #(N) alu_gen_inst(
        .A(A),
        .B(B),
        .C(C),
        .D(D),
        .opc(opc),
        .out(out_gen)
    );

    ALU_p #(N) alu_p_inst(
        .A(A),
        .B(B),
        .C(C),
        .D(D),
        .opc(opc),
        .out(out_p)
    );

    initial begin
        for (t = 0; t < 100; t = t + 1) begin

            A = $random;
            B = $random;
            C = $random;
            D = $random;

            for (i = 0; i < 4; i = i + 1) begin
                opc = i;
                #5;

                if (out_gen !== out_p) begin
                    $display("MISMATCH at test=%0d opc=%b\n A=%h B=%h C=%h D=%h \n out_gen=%h out_p=%h",
                              t, opc, A, B, C, D, out_gen, out_p);
                end else begin
                    $display("MATCH test=%0d opc=%b out=%h", t, opc, out_gen);
                end
            end
        end

        $display("===== All tests finished =====");
        $stop;
    end

endmodule
