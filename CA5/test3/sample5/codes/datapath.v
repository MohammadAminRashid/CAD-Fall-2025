module datapath(
  input clk, rst,
  input [31:0] i8,
  input [31:0] i6,
  input [31:0] i2,
  input [31:0] i7,
  input [31:0] i5,
  input [31:0] i4,
  input [31:0] i3,
  input [31:0] i1,
  input [3:0] alu1_sel1, alu1_sel2,
  input alu1_op,
  input [3:0] mul1_sel1, mul1_sel2,
  input mul1_op,
  input [3:0] log1_sel1, log1_sel2,
  input log1_op,
  input result_en,
  input reg_12_en,
  input reg_13_en,
  input reg_14_en,
  input reg_2_en,
  input reg_5_en,
  input reg_6_en,
  input reg_9_en,
  output reg [31:0] result);
reg [31:0] reg_12;
reg [31:0] reg_13;
reg [31:0] reg_14;
reg [31:0] reg_2;
reg [31:0] reg_5;
reg [31:0] reg_6;
reg [31:0] reg_9;


wire [31:0] alu1_out;
reg [31:0] alu1_in1, alu1_in2;
wire [31:0] mul1_out;
reg [31:0] mul1_in1, mul1_in2;
wire [31:0] log1_out;
reg [31:0] log1_in1, log1_in2;
always @(*) begin
  case (alu1_sel1)
    4'd0: alu1_in1 = i1;
    4'd1: alu1_in1 = i3;
    4'd2: alu1_in1 = reg_9;
    default: alu1_in1 = 0;
  endcase
end
always @(*) begin
  case (alu1_sel2)
    4'd0: alu1_in2 = i2;
    4'd1: alu1_in2 = i4;
    4'd2: alu1_in2 = reg_12;
    default: alu1_in2 = 0;
  endcase
end
always @(*) begin
  case (log1_sel1)
    4'd0: log1_in1 = i7;
    4'd1: log1_in1 = reg_6;
    default: log1_in1 = 0;
  endcase
end
always @(*) begin
  case (log1_sel2)
    4'd0: log1_in2 = i8;
    4'd1: log1_in2 = reg_13;
    default: log1_in2 = 0;
  endcase
end
always @(*) begin
  case (mul1_sel1)
    4'd0: mul1_in1 = reg_2;
    4'd1: mul1_in1 = i5;
    default: mul1_in1 = 0;
  endcase
end
always @(*) begin
  case (mul1_sel2)
    4'd0: mul1_in2 = reg_5;
    4'd1: mul1_in2 = i6;
    default: mul1_in2 = 0;
  endcase
end


// ALU Unit 1
assign alu1_out = (alu1_op == 1'b0) ? (alu1_in1 + alu1_in2) : (alu1_in1 - alu1_in2);
// MUL Unit 1
assign mul1_out = (mul1_op == 1'b0) ? (mul1_in1 * mul1_in2) : (mul1_in1 / mul1_in2);
// LOG Unit 1
assign log1_out = (log1_op == 1'b0) ? (log1_in1 & log1_in2) : (log1_in1 | log1_in2);


always @(posedge clk or posedge rst) begin
  if (rst) begin
        result <= 0;
    reg_12 <= 0;
    reg_13 <= 0;
    reg_14 <= 0;
    reg_2 <= 0;
    reg_5 <= 0;
    reg_6 <= 0;
    reg_9 <= 0;
  end else begin
    if (reg_12_en) reg_12 <= log1_out;
    if (reg_13_en) reg_13 <= alu1_out;
    if (reg_14_en) reg_14 <= log1_out;
    if (reg_2_en) reg_2 <= alu1_out;
    if (reg_5_en) reg_5 <= alu1_out;
    if (reg_6_en) reg_6 <= mul1_out;
    if (reg_9_en) reg_9 <= mul1_out;
    if (result_en) result <= log1_out;
  end
end
endmodule