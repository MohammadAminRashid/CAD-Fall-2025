module datapath(
  input clk, rst,
  input [31:0] i4,
  input [31:0] i5,
  input [31:0] i2,
  input [31:0] i6,
  input [31:0] i1,
  input [31:0] i3,
  input [3:0] alu1_sel1, alu1_sel2,
  input alu1_op,
  input [3:0] mul1_sel1, mul1_sel2,
  input mul1_op,
  input [3:0] mul2_sel1, mul2_sel2,
  input mul2_op,
  input [3:0] mul3_sel1, mul3_sel2,
  input mul3_op,
  input [3:0] mul4_sel1, mul4_sel2,
  input mul4_op,
  input [3:0] log1_sel1, log1_sel2,
  input log1_op,
  input result_en,
  input reg_10_en,
  input reg_11_en,
  input reg_12_en,
  input reg_2_en,
  input reg_5_en,
  input reg_6_en,
  input reg_7_en,
  output reg [31:0] result);
reg [31:0] reg_10;
reg [31:0] reg_11;
reg [31:0] reg_12;
reg [31:0] reg_2;
reg [31:0] reg_5;
reg [31:0] reg_6;
reg [31:0] reg_7;


wire [31:0] alu1_out;
reg [31:0] alu1_in1, alu1_in2;
wire [31:0] mul1_out;
reg [31:0] mul1_in1, mul1_in2;
wire [31:0] mul2_out;
reg [31:0] mul2_in1, mul2_in2;
wire [31:0] mul3_out;
reg [31:0] mul3_in1, mul3_in2;
wire [31:0] mul4_out;
reg [31:0] mul4_in1, mul4_in2;
wire [31:0] log1_out;
reg [31:0] log1_in1, log1_in2;
always @(*) begin
  case (alu1_sel1)
    4'd0: alu1_in1 = reg_2;
    4'd1: alu1_in1 = reg_6;
    default: alu1_in1 = 0;
  endcase
end
always @(*) begin
  case (alu1_sel2)
    4'd0: alu1_in2 = reg_5;
    4'd1: alu1_in2 = reg_11;
    default: alu1_in2 = 0;
  endcase
end
always @(*) begin
  case (log1_sel1)
    4'd0: log1_in1 = reg_7;
    default: log1_in1 = 0;
  endcase
end
always @(*) begin
  case (log1_sel2)
    4'd0: log1_in2 = reg_10;
    default: log1_in2 = 0;
  endcase
end
always @(*) begin
  case (mul1_sel1)
    4'd0: mul1_in1 = i1;
    default: mul1_in1 = 0;
  endcase
end
always @(*) begin
  case (mul1_sel2)
    4'd0: mul1_in2 = i2;
    default: mul1_in2 = 0;
  endcase
end
always @(*) begin
  case (mul2_sel1)
    4'd0: mul2_in1 = i3;
    default: mul2_in1 = 0;
  endcase
end
always @(*) begin
  case (mul2_sel2)
    4'd0: mul2_in2 = i4;
    default: mul2_in2 = 0;
  endcase
end
always @(*) begin
  case (mul3_sel1)
    4'd0: mul3_in1 = i1;
    default: mul3_in1 = 0;
  endcase
end
always @(*) begin
  case (mul3_sel2)
    4'd0: mul3_in2 = i2;
    default: mul3_in2 = 0;
  endcase
end
always @(*) begin
  case (mul4_sel1)
    4'd0: mul4_in1 = i5;
    default: mul4_in1 = 0;
  endcase
end
always @(*) begin
  case (mul4_sel2)
    4'd0: mul4_in2 = i6;
    default: mul4_in2 = 0;
  endcase
end


// ALU Unit 1
assign alu1_out = (alu1_op == 1'b0) ? (alu1_in1 + alu1_in2) : (alu1_in1 - alu1_in2);
// MUL Unit 1
assign mul1_out = (mul1_op == 1'b0) ? (mul1_in1 * mul1_in2) : (mul1_in1 / mul1_in2);
// MUL Unit 2
assign mul2_out = (mul2_op == 1'b0) ? (mul2_in1 * mul2_in2) : (mul2_in1 / mul2_in2);
// MUL Unit 3
assign mul3_out = (mul3_op == 1'b0) ? (mul3_in1 * mul3_in2) : (mul3_in1 / mul3_in2);
// MUL Unit 4
assign mul4_out = (mul4_op == 1'b0) ? (mul4_in1 * mul4_in2) : (mul4_in1 / mul4_in2);
// LOG Unit 1
assign log1_out = (log1_op == 1'b0) ? (log1_in1 & log1_in2) : (log1_in1 | log1_in2);


always @(posedge clk or posedge rst) begin
  if (rst) begin
        result <= 0;
    reg_10 <= 0;
    reg_11 <= 0;
    reg_12 <= 0;
    reg_2 <= 0;
    reg_5 <= 0;
    reg_6 <= 0;
    reg_7 <= 0;
  end else begin
    if (reg_10_en) reg_10 <= mul4_out;
    if (reg_11_en) reg_11 <= log1_out;
    if (reg_12_en) reg_12 <= alu1_out;
    if (reg_2_en) reg_2 <= mul1_out;
    if (reg_5_en) reg_5 <= mul2_out;
    if (reg_6_en) reg_6 <= alu1_out;
    if (reg_7_en) reg_7 <= mul3_out;
    if (result_en) result <= alu1_out;
  end
end
endmodule