module datapath(
  input clk, rst,
  input [31:0] i1,
  input [31:0] i5,
  input [31:0] i2,
  input [31:0] i4,
  input [31:0] i3,
  input [31:0] i6,
  input result_en,
  input reg_10_en,
  input reg_2_en,
  input reg_4_en,
  input reg_7_en,
  input reg_8_en,
  output reg [31:0] result);
reg [31:0] reg_10;
reg [31:0] reg_2;
reg [31:0] reg_4;
reg [31:0] reg_7;
reg [31:0] reg_8;


always @(*) begin
  case (alu1_sel1)
    4'd0: alu1_in1 = reg_2;
    default: alu1_in1 = 0;
  endcase
end
always @(*) begin
  case (alu1_sel2)
    4'd0: alu1_in2 = i3;
    default: alu1_in2 = 0;
  endcase
end
always @(*) begin
  case (alu2_sel1)
    4'd0: alu2_in1 = i4;
    default: alu2_in1 = 0;
  endcase
end
always @(*) begin
  case (alu2_sel2)
    4'd0: alu2_in2 = i5;
    default: alu2_in2 = 0;
  endcase
end
always @(*) begin
  case (log1_sel1)
    4'd0: log1_in1 = reg_4;
    default: log1_in1 = 0;
  endcase
end
always @(*) begin
  case (log1_sel2)
    4'd0: log1_in2 = reg_7;
    default: log1_in2 = 0;
  endcase
end
always @(*) begin
  case (mul1_sel1)
    4'd0: mul1_in1 = i1;
    4'd1: mul1_in1 = reg_8;
    default: mul1_in1 = 0;
  endcase
end
always @(*) begin
  case (mul1_sel2)
    4'd0: mul1_in2 = i2;
    4'd1: mul1_in2 = i6;
    default: mul1_in2 = 0;
  endcase
end




always @(posedge clk or posedge rst) begin
  if (rst) begin
        result <= 0;
    reg_10 <= 0;
    reg_2 <= 0;
    reg_4 <= 0;
    reg_7 <= 0;
    reg_8 <= 0;
  end else begin
    if (reg_10_en) reg_10 <= mul1_out;
    if (reg_2_en) reg_2 <= mul1_out;
    if (reg_4_en) reg_4 <= alu1_out;
    if (reg_7_en) reg_7 <= alu2_out;
    if (reg_8_en) reg_8 <= log1_out;
    if (result_en) result <= mul1_out;
  end
end
endmodule