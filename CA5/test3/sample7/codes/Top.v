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
  wire reg_10_en;
  wire reg_13_en;
  wire reg_14_en;
  wire reg_2_en;
  wire reg_4_en;
  wire reg_6_en;
  wire reg_9_en;
  wire result_en;

  controller ctrl_inst(
    .clk(clk),
    .rst(rst),
    .start(start),
    .op_ready(op_ready),
    .done(done),
    .result_en(result_en),
    .reg_10_en(reg_10_en),
    .reg_13_en(reg_13_en),
    .reg_14_en(reg_14_en),
    .reg_2_en(reg_2_en),
    .reg_4_en(reg_4_en),
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
    .result_en(result_en),
    .reg_10_en(reg_10_en),
    .reg_13_en(reg_13_en),
    .reg_14_en(reg_14_en),
    .reg_2_en(reg_2_en),
    .reg_4_en(reg_4_en),
    .reg_6_en(reg_6_en),
    .reg_9_en(reg_9_en),
    .result(result)
  );

endmodule