module datapath(
  input clk, rst,
  input [31:0] i8,
  input [31:0] i3,
  input [31:0] i1,
  input [31:0] i7,
  input [31:0] i4,
  input [31:0] i6,
  input [31:0] i5,
  input [31:0] i2,
  input [3:0] alu1_sel1, alu1_sel2,
  input alu1_op,
  input [3:0] alu2_sel1, alu2_sel2,
  input alu2_op,
  input [3:0] alu3_sel1, alu3_sel2,
  input alu3_op,
  input [3:0] alu4_sel1, alu4_sel2,
  input alu4_op,
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
wire [31:0] alu2_out;
reg [31:0] alu2_in1, alu2_in2;
wire [31:0] alu3_out;
reg [31:0] alu3_in1, alu3_in2;
wire [31:0] alu4_out;
reg [31:0] alu4_in1, alu4_in2;
always @(*) begin
  case (alu1_sel1)
    4'd0: alu1_in1 = i1;
    4'd1: alu1_in1 = reg_2;
    4'd2: alu1_in1 = reg_6;
    default: alu1_in1 = 0;
  endcase
end
always @(*) begin
  case (alu1_sel2)
    4'd0: alu1_in2 = i2;
    4'd1: alu1_in2 = reg_5;
    4'd2: alu1_in2 = reg_13;
    default: alu1_in2 = 0;
  endcase
end
always @(*) begin
  case (alu2_sel1)
    4'd0: alu2_in1 = i3;
    4'd1: alu2_in1 = reg_9;
    default: alu2_in1 = 0;
  endcase
end
always @(*) begin
  case (alu2_sel2)
    4'd0: alu2_in2 = i4;
    4'd1: alu2_in2 = reg_12;
    default: alu2_in2 = 0;
  endcase
end
always @(*) begin
  case (alu3_sel1)
    4'd0: alu3_in1 = i5;
    default: alu3_in1 = 0;
  endcase
end
always @(*) begin
  case (alu3_sel2)
    4'd0: alu3_in2 = i6;
    default: alu3_in2 = 0;
  endcase
end
always @(*) begin
  case (alu4_sel1)
    4'd0: alu4_in1 = i7;
    default: alu4_in1 = 0;
  endcase
end
always @(*) begin
  case (alu4_sel2)
    4'd0: alu4_in2 = i8;
    default: alu4_in2 = 0;
  endcase
end


// ALU Unit 1
assign alu1_out = (alu1_op == 1'b0) ? (alu1_in1 + alu1_in2) : (alu1_in1 - alu1_in2);
// ALU Unit 2
assign alu2_out = (alu2_op == 1'b0) ? (alu2_in1 + alu2_in2) : (alu2_in1 - alu2_in2);
// ALU Unit 3
assign alu3_out = (alu3_op == 1'b0) ? (alu3_in1 + alu3_in2) : (alu3_in1 - alu3_in2);
// ALU Unit 4
assign alu4_out = (alu4_op == 1'b0) ? (alu4_in1 + alu4_in2) : (alu4_in1 - alu4_in2);


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
    if (reg_12_en) reg_12 <= alu4_out;
    if (reg_13_en) reg_13 <= alu2_out;
    if (reg_14_en) reg_14 <= alu1_out;
    if (reg_2_en) reg_2 <= alu1_out;
    if (reg_5_en) reg_5 <= alu2_out;
    if (reg_6_en) reg_6 <= alu1_out;
    if (reg_9_en) reg_9 <= alu3_out;
    if (result_en) result <= alu1_out;
  end
end
endmodule