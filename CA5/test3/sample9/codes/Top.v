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
  output [31:0] result,
  output done
);

  wire op_ready;
  wire reg_10_en;
  wire reg_2_en;
  wire reg_4_en;
  wire reg_7_en;
  wire reg_8_en;
  wire result_en;

  controller ctrl_inst(
    .clk(clk),
    .rst(rst),
    .start(start),
    .op_ready(op_ready),
    .done(done),
    .result_en(result_en),
    .reg_10_en(reg_10_en),
    .reg_2_en(reg_2_en),
    .reg_4_en(reg_4_en),
    .reg_7_en(reg_7_en),
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
    .result_en(result_en),
    .reg_10_en(reg_10_en),
    .reg_2_en(reg_2_en),
    .reg_4_en(reg_4_en),
    .reg_7_en(reg_7_en),
    .reg_8_en(reg_8_en),
    .result(result)
  );

endmodule