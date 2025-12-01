module hash_generator_controller(clk , rst , start , co , done_rnd , start_rnd , en ,  s , sf,load,loadf,loadm , done);
input clk , rst , start , co , done_rnd;
output  start_rnd , en ,  s,sf,load,loadf,loadm , done , clear;

wire A,B,C,D,E,F,G,H;
wire o1,o2 , x , y;


                c1 c1_inst_a (
                .A0(1'b1),
                .A1(1'b0),
                .SA(F),
                .B0(1'b0),
                .B1(1'b0),
                .SB(1'b0),
                .S0(D),
                .S1(E),
                .f(o1)
            );



            
               

                c1 c1_inst_b (
                .A0(1'b1),
                .A1(1'b0),
                .SA(C),
                .B0(1'b0),
                .B1(1'b0),
                .SB(1'b0),
                .S0(A),
                .S1(B),
                .f(o2)
            );

      

                        c2 U_c2 (
                .D00(1'b0),
                .D01(1'b1),
                .D10(1'b0),
                .D11(1'b0),
                .A1(G),
                .B1(H),
                .A0(o1),
                .B0(o2),
                .out(x)
            );
               

                c1 c1_inst_c (
                .A0(1'b1),
                .A1(1'b0),
                .SA(start),
                .B0(1'b1),
                .B1(1'b0),
                .SB(done_rnd),
                .S0(D),
                .S1(1'b0),
                .f(y)
            );


//  STATE A

s2 S2_A (
  .D00(1'b0),
  .D01(1'b1),
  .D10(1'b1),
  .D11(1'b1),
  .A1 (x),
  .B1 (G),
  .A0 (A),
  .B0 (y),
  .clr(rst),
  .clk(clk),
  .out(A)
);




//  STATE B

s2 S2_B (
  .D00(1'b0),
  .D01(1'b1),
  .D10(1'b0),
  .D11(1'b1),
  .A1 (1'b0),
  .B1 (1'b0),
  .A0 (A),
  .B0 (start),
  .clr(rst),
  .clk(clk),
  .out(B)
);



//  STATE C



s2 S2_C (
  .D00(1'b0),
  .D01(1'b0),
  .D10(1'b1),
  .D11(1'b1),
  .A1 (B),
  .B1 (H),
  .A0 (1'b0),
  .B0 (1'b0),
  .clr(rst),
  .clk(clk),
  .out(C)
);



//  STATE D

s2 S2_D (
  .D00(1'b0),
  .D01(1'b1),
  .D10(1'b1),
  .D11(1'b1),
  .A1 (C),
  .B1 (1'b0),
  .A0 (D),
  .B0 (y),
  .clr(rst),
  .clk(clk),
  .out(D)
);



//  STATE E

s2 S2_E (
  .D00(1'b0),
  .D01(1'b0),
  .D10(1'b0),
  .D11(1'b1),
  .A1 (D),
  .B1 (1'b0),
  .A0 (done_rnd),
  .B0 (1'b1),
  .clr(rst),
  .clk(clk),
  .out(E)
);



//  STATE F

s2 S2_F (
  .D00(1'b0),
  .D01(1'b0),
  .D10(1'b1),
  .D11(1'b1),
  .A1 (E),
  .B1 (1'b0),
  .A0 (1'b0),
  .B0 (1'b0),
  .clr(rst),
  .clk(clk),
  .out(F)
);



//  STATE G

s2 S2_G (
  .D00(1'b0),
  .D01(1'b1),
  .D10(1'b0),
  .D11(1'b0),
  .A1 (1'b0),
  .B1 (1'b0),
  .A0 (F),
  .B0 (co),
  .clr(rst),
  .clk(clk),
  .out(G)
);



//  STATE H

s2 S2_H (
  .D00(1'b0),
  .D01(1'b0),
  .D10(1'b1),
  .D11(1'b0),
  .A1 (F),
  .B1 (1'b0),
  .A0 (co),
  .B0 (1'b1),
  .clr(rst),
  .clk(clk),
  .out(H)
);


or_c1 or1(C, E, loadf);
or_c1 or2(F, B , load);



assign start_rnd=C;
assign en=H;
assign s =F;
assign sf=E;
assign loadm=B;
assign done =G;
assign clear=A;

endmodule