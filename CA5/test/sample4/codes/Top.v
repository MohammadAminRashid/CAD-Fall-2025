module Top(
  input clk,
  input rst,
  input start,
  input [31:0] i1,
  input [31:0] i2,
  input [31:0] i3,
  output [31:0] result,
  output done
);

  wire op_ready;
  wire [3:0] alu1_sel1, alu1_sel2;
  wire alu1_op;
  wire [3:0] alu2_sel1, alu2_sel2;
  wire alu2_op;
  wire [3:0] mul1_sel1, mul1_sel2;
  wire mul1_op;
  wire [3:0] log1_sel1, log1_sel2;
  wire log1_op;
  wire reg_10_en;
  wire reg_11_en;
  wire reg_2_en;
  wire reg_3_en;
  wire reg_5_en;
  wire reg_6_en;
  wire reg_7_en;
  wire reg_8_en;
  wire reg_9_en;
  wire result_en;

  controller ctrl_inst(
    .clk(clk),
    .rst(rst),
    .start(start),
    .op_ready(op_ready),
    .alu1_sel1(alu1_sel1), .alu1_sel2(alu1_sel2), .alu1_op(alu1_op),
    .alu2_sel1(alu2_sel1), .alu2_sel2(alu2_sel2), .alu2_op(alu2_op),
    .mul1_sel1(mul1_sel1), .mul1_sel2(mul1_sel2), .mul1_op(mul1_op),
    .log1_sel1(log1_sel1), .log1_sel2(log1_sel2), .log1_op(log1_op),
    .done(done),
    .result_en(result_en),
    .reg_10_en(reg_10_en),
    .reg_11_en(reg_11_en),
    .reg_2_en(reg_2_en),
    .reg_3_en(reg_3_en),
    .reg_5_en(reg_5_en),
    .reg_6_en(reg_6_en),
    .reg_7_en(reg_7_en),
    .reg_8_en(reg_8_en),
    .reg_9_en(reg_9_en)
  );

  datapath dp_inst(
    .clk(clk),
    .rst(rst),
    .i1(i1),
    .i2(i2),
    .i3(i3),
    .alu1_sel1(alu1_sel1), .alu1_sel2(alu1_sel2), .alu1_op(alu1_op),
    .alu2_sel1(alu2_sel1), .alu2_sel2(alu2_sel2), .alu2_op(alu2_op),
    .mul1_sel1(mul1_sel1), .mul1_sel2(mul1_sel2), .mul1_op(mul1_op),
    .log1_sel1(log1_sel1), .log1_sel2(log1_sel2), .log1_op(log1_op),
    .result_en(result_en),
    .reg_10_en(reg_10_en),
    .reg_11_en(reg_11_en),
    .reg_2_en(reg_2_en),
    .reg_3_en(reg_3_en),
    .reg_5_en(reg_5_en),
    .reg_6_en(reg_6_en),
    .reg_7_en(reg_7_en),
    .reg_8_en(reg_8_en),
    .reg_9_en(reg_9_en),
    .result(result)
  );

endmodule