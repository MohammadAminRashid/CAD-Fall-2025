module datapath(
  input clk, rst,
  input [31:0] i3,
  input [31:0] i2,
  input [31:0] i1,
  input [3:0] alu1_sel1, alu1_sel2,
  input alu1_op,
  input [3:0] alu2_sel1, alu2_sel2,
  input alu2_op,
  input [3:0] mul1_sel1, mul1_sel2,
  input mul1_op,
  input [3:0] log1_sel1, log1_sel2,
  input log1_op,
  input result_en,
  input reg_2_en,
  input reg_4_en,
  input reg_5_en,
  input reg_6_en,
  input reg_7_en,
  output reg [31:0] result);
reg [31:0] reg_2;
reg [31:0] reg_4;
reg [31:0] reg_5;
reg [31:0] reg_6;
reg [31:0] reg_7;


wire [31:0] alu1_out;
reg [31:0] alu1_in1, alu1_in2;
wire [31:0] alu2_out;
reg [31:0] alu2_in1, alu2_in2;
wire [31:0] mul1_out;
reg [31:0] mul1_in1, mul1_in2;
wire [31:0] log1_out;
reg [31:0] log1_in1, log1_in2;
always @(*) begin
  case (alu1_sel1)
    4'd0: alu1_in1 = i1;
    default: alu1_in1 = 0;
  endcase
end
always @(*) begin
  case (alu1_sel2)
    4'd0: alu1_in2 = i3;
    4'd1: alu1_in2 = i2;
    default: alu1_in2 = 0;
  endcase
end
always @(*) begin
  case (alu2_sel1)
    4'd0: alu2_in1 = i2;
    default: alu2_in1 = 0;
  endcase
end
always @(*) begin
  case (alu2_sel2)
    4'd0: alu2_in2 = i3;
    default: alu2_in2 = 0;
  endcase
end
always @(*) begin
  case (mul1_sel1)
    4'd0: mul1_in1 = reg_4;
    4'd1: mul1_in1 = reg_2;
    default: mul1_in1 = 0;
  endcase
end
always @(*) begin
  case (mul1_sel2)
    4'd0: mul1_in2 = reg_5;
    4'd1: mul1_in2 = reg_6;
    default: mul1_in2 = 0;
  endcase
end


// ALU Unit 1
assign alu1_out = (alu1_op == 1'b0) ? (alu1_in1 + alu1_in2) : (alu1_in1 - alu1_in2);
// ALU Unit 2
assign alu2_out = (alu2_op == 1'b0) ? (alu2_in1 + alu2_in2) : (alu2_in1 - alu2_in2);
// MUL Unit 1
assign mul1_out = (mul1_op == 1'b0) ? (mul1_in1 * mul1_in2) : (mul1_in1 / mul1_in2);
// LOG Unit 1
assign log1_out = (log1_op == 1'b0) ? (log1_in1 & log1_in2) : (log1_in1 | log1_in2);


always @(posedge clk or posedge rst) begin
  if (rst) begin
        result <= 0;
    reg_2 <= 0;
    reg_4 <= 0;
    reg_5 <= 0;
    reg_6 <= 0;
    reg_7 <= 0;
  end else begin
    if (reg_2_en) reg_2 <= alu1_out;
    if (reg_4_en) reg_4 <= alu1_out;
    if (reg_5_en) reg_5 <= alu2_out;
    if (reg_6_en) reg_6 <= mul1_out;
    if (reg_7_en) reg_7 <= mul1_out;
    if (result_en) result <= mul1_out;
  end
end
endmodule