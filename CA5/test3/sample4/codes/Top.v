module Top(
  input clk,
  input rst,
  input start,
  input [31:0] i1,
  input [31:0] i2,
  input [31:0] i3,
  input [31:0] i4,
  input [31:0] i5,
  input [31:0] i6,
  input [31:0] i7,
  output [31:0] result,
  output done
);

  wire op_ready;
  wire [3:0] alu1_sel1, alu1_sel2;
  wire alu1_op;
  wire [3:0] mul1_sel1, mul1_sel2;
  wire mul1_op;
  wire reg_10_en;
  wire reg_12_en;
  wire reg_2_en;
  wire reg_4_en;
  wire reg_6_en;
  wire reg_8_en;
  wire result_en;

  controller ctrl_inst(
    .clk(clk),
    .rst(rst),
    .start(start),
    .op_ready(op_ready),
    .alu1_sel1(alu1_sel1), .alu1_sel2(alu1_sel2), .alu1_op(alu1_op),
    .mul1_sel1(mul1_sel1), .mul1_sel2(mul1_sel2), .mul1_op(mul1_op),
    .done(done),
    .result_en(result_en),
    .reg_10_en(reg_10_en),
    .reg_12_en(reg_12_en),
    .reg_2_en(reg_2_en),
    .reg_4_en(reg_4_en),
    .reg_6_en(reg_6_en),
    .reg_8_en(reg_8_en)
  );

  datapath dp_inst(
    .clk(clk),
    .rst(rst),
    .i1(i1),
    .i2(i2),
    .i3(i3),
    .i4(i4),
    .i5(i5),
    .i6(i6),
    .i7(i7),
    .alu1_sel1(alu1_sel1), .alu1_sel2(alu1_sel2), .alu1_op(alu1_op),
    .mul1_sel1(mul1_sel1), .mul1_sel2(mul1_sel2), .mul1_op(mul1_op),
    .result_en(result_en),
    .reg_10_en(reg_10_en),
    .reg_12_en(reg_12_en),
    .reg_2_en(reg_2_en),
    .reg_4_en(reg_4_en),
    .reg_6_en(reg_6_en),
    .reg_8_en(reg_8_en),
    .result(result)
  );

endmodule