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
  input [31:0] i8,
  output [31:0] result,
  output done
);

  wire op_ready;
  wire [3:0] alu1_sel1, alu1_sel2;
  wire alu1_op;
  wire [3:0] mul1_sel1, mul1_sel2;
  wire mul1_op;
  wire [3:0] log1_sel1, log1_sel2;
  wire log1_op;
  wire reg_12_en;
  wire reg_13_en;
  wire reg_14_en;
  wire reg_2_en;
  wire reg_5_en;
  wire reg_6_en;
  wire reg_9_en;
  wire result_en;

  controller ctrl_inst(
    .clk(clk),
    .rst(rst),
    .start(start),
    .op_ready(op_ready),
    .alu1_sel1(alu1_sel1), .alu1_sel2(alu1_sel2), .alu1_op(alu1_op),
    .mul1_sel1(mul1_sel1), .mul1_sel2(mul1_sel2), .mul1_op(mul1_op),
    .log1_sel1(log1_sel1), .log1_sel2(log1_sel2), .log1_op(log1_op),
    .done(done),
    .result_en(result_en),
    .reg_12_en(reg_12_en),
    .reg_13_en(reg_13_en),
    .reg_14_en(reg_14_en),
    .reg_2_en(reg_2_en),
    .reg_5_en(reg_5_en),
    .reg_6_en(reg_6_en),
    .reg_9_en(reg_9_en)
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
    .i8(i8),
    .alu1_sel1(alu1_sel1), .alu1_sel2(alu1_sel2), .alu1_op(alu1_op),
    .mul1_sel1(mul1_sel1), .mul1_sel2(mul1_sel2), .mul1_op(mul1_op),
    .log1_sel1(log1_sel1), .log1_sel2(log1_sel2), .log1_op(log1_op),
    .result_en(result_en),
    .reg_12_en(reg_12_en),
    .reg_13_en(reg_13_en),
    .reg_14_en(reg_14_en),
    .reg_2_en(reg_2_en),
    .reg_5_en(reg_5_en),
    .reg_6_en(reg_6_en),
    .reg_9_en(reg_9_en),
    .result(result)
  );

endmodule