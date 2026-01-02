module datapath(
  input clk, rst,
  input [31:0] i5,
  input [31:0] i7,
  input [31:0] i6,
  input [31:0] i1,
  input [31:0] i3,
  input [31:0] i4,
  input [31:0] i2,
  input [3:0] alu1_sel1, alu1_sel2,
  input alu1_op,
  input [3:0] mul1_sel1, mul1_sel2,
  input mul1_op,
  input result_en,
  input reg_10_en,
  input reg_12_en,
  input reg_2_en,
  input reg_4_en,
  input reg_6_en,
  input reg_8_en,
  output reg [31:0] result);
reg [31:0] reg_10;
reg [31:0] reg_12;
reg [31:0] reg_2;
reg [31:0] reg_4;
reg [31:0] reg_6;
reg [31:0] reg_8;


wire [31:0] alu1_out;
reg [31:0] alu1_in1, alu1_in2;
wire [31:0] mul1_out;
reg [31:0] mul1_in1, mul1_in2;
always @(*) begin
  case (alu1_sel1)
    4'd0: alu1_in1 = reg_2;
    4'd1: alu1_in1 = reg_6;
    4'd2: alu1_in1 = reg_10;
    default: alu1_in1 = 0;
  endcase
end
always @(*) begin
  case (alu1_sel2)
    4'd0: alu1_in2 = i3;
    4'd1: alu1_in2 = i5;
    4'd2: alu1_in2 = i7;
    default: alu1_in2 = 0;
  endcase
end
always @(*) begin
  case (mul1_sel1)
    4'd0: mul1_in1 = i1;
    4'd1: mul1_in1 = reg_4;
    4'd2: mul1_in1 = reg_8;
    default: mul1_in1 = 0;
  endcase
end
always @(*) begin
  case (mul1_sel2)
    4'd0: mul1_in2 = i2;
    4'd1: mul1_in2 = i4;
    4'd2: mul1_in2 = i6;
    default: mul1_in2 = 0;
  endcase
end


// ALU Unit 1
assign alu1_out = (alu1_op == 1'b0) ? (alu1_in1 + alu1_in2) : (alu1_in1 - alu1_in2);
// MUL Unit 1
assign mul1_out = (mul1_op == 1'b0) ? (mul1_in1 * mul1_in2) : (mul1_in1 / mul1_in2);


always @(posedge clk or posedge rst) begin
  if (rst) begin
        result <= 0;
    reg_10 <= 0;
    reg_12 <= 0;
    reg_2 <= 0;
    reg_4 <= 0;
    reg_6 <= 0;
    reg_8 <= 0;
  end else begin
    if (reg_10_en) reg_10 <= mul1_out;
    if (reg_12_en) reg_12 <= alu1_out;
    if (reg_2_en) reg_2 <= mul1_out;
    if (reg_4_en) reg_4 <= alu1_out;
    if (reg_6_en) reg_6 <= mul1_out;
    if (reg_8_en) reg_8 <= alu1_out;
    if (result_en) result <= alu1_out;
  end
end
endmodule