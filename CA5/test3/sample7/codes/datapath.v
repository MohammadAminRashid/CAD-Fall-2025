module datapath(
  input clk, rst,
  input [31:0] i8,
  input [31:0] i1,
  input [31:0] i5,
  input [31:0] i6,
  input [31:0] i2,
  input [31:0] i4,
  input [31:0] i7,
  input [31:0] i3,
  input [3:0] mul1_sel1, mul1_sel2,
  input mul1_op,
  input [3:0] log1_sel1, log1_sel2,
  input log1_op,
  input [3:0] log2_sel1, log2_sel2,
  input log2_op,
  input result_en,
  input reg_10_en,
  input reg_13_en,
  input reg_14_en,
  input reg_2_en,
  input reg_4_en,
  input reg_6_en,
  input reg_9_en,
  output reg [31:0] result);
reg [31:0] reg_10;
reg [31:0] reg_13;
reg [31:0] reg_14;
reg [31:0] reg_2;
reg [31:0] reg_4;
reg [31:0] reg_6;
reg [31:0] reg_9;


wire [31:0] mul1_out;
reg [31:0] mul1_in1, mul1_in2;
wire [31:0] log1_out;
reg [31:0] log1_in1, log1_in2;
wire [31:0] log2_out;
reg [31:0] log2_in1, log2_in2;
always @(*) begin
  case (log1_sel1)
    4'd0: log1_in1 = i5;
    4'd1: log1_in1 = reg_6;
    4'd2: log1_in1 = reg_10;
    default: log1_in1 = 0;
  endcase
end
always @(*) begin
  case (log1_sel2)
    4'd0: log1_in2 = i6;
    4'd1: log1_in2 = reg_9;
    4'd2: log1_in2 = reg_13;
    default: log1_in2 = 0;
  endcase
end
always @(*) begin
  case (log2_sel1)
    4'd0: log2_in1 = i7;
    default: log2_in1 = 0;
  endcase
end
always @(*) begin
  case (log2_sel2)
    4'd0: log2_in2 = i8;
    default: log2_in2 = 0;
  endcase
end
always @(*) begin
  case (mul1_sel1)
    4'd0: mul1_in1 = i1;
    4'd1: mul1_in1 = reg_2;
    4'd2: mul1_in1 = reg_4;
    default: mul1_in1 = 0;
  endcase
end
always @(*) begin
  case (mul1_sel2)
    4'd0: mul1_in2 = i2;
    4'd1: mul1_in2 = i3;
    4'd2: mul1_in2 = i4;
    default: mul1_in2 = 0;
  endcase
end


// MUL Unit 1
assign mul1_out = (mul1_op == 1'b0) ? (mul1_in1 * mul1_in2) : (mul1_in1 / mul1_in2);
// LOG Unit 1
assign log1_out = (log1_op == 1'b0) ? (log1_in1 & log1_in2) : (log1_in1 | log1_in2);
// LOG Unit 2
assign log2_out = (log2_op == 1'b0) ? (log2_in1 & log2_in2) : (log2_in1 | log2_in2);


always @(posedge clk or posedge rst) begin
  if (rst) begin
        result <= 0;
    reg_10 <= 0;
    reg_13 <= 0;
    reg_14 <= 0;
    reg_2 <= 0;
    reg_4 <= 0;
    reg_6 <= 0;
    reg_9 <= 0;
  end else begin
    if (reg_10_en) reg_10 <= log1_out;
    if (reg_13_en) reg_13 <= log2_out;
    if (reg_14_en) reg_14 <= log1_out;
    if (reg_2_en) reg_2 <= mul1_out;
    if (reg_4_en) reg_4 <= mul1_out;
    if (reg_6_en) reg_6 <= mul1_out;
    if (reg_9_en) reg_9 <= log1_out;
    if (result_en) result <= log1_out;
  end
end
endmodule