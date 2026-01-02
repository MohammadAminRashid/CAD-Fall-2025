module controller(
  input clk, rst, start,
  output reg op_ready,
  output reg [3:0] alu1_sel1, alu1_sel2,
  output reg alu1_op,
  output reg [3:0] mul1_sel1, mul1_sel2,
  output reg mul1_op,
  output reg [3:0] log1_sel1, log1_sel2,
  output reg log1_op,
  output reg done, result_en,
  output reg reg_12_en, reg_13_en, reg_14_en, reg_2_en, reg_5_en, reg_6_en, reg_9_en );

reg [3:0] state, next_state;
localparam S_IDLE = 0, S_DONE = 5;
localparam S_CYCLE_1 = 1;
localparam S_CYCLE_2 = 2;
localparam S_CYCLE_3 = 3;
localparam S_CYCLE_4 = 4;

always @(posedge clk or posedge rst) begin
  if (rst) state <= S_IDLE;
  else state <= next_state;
end

always @(*) begin
  op_ready = 0; next_state = state; result_en = 0; done = 0;
  alu1_sel1 = 0; alu1_sel2 = 0; alu1_op = 0;
  mul1_sel1 = 0; mul1_sel2 = 0; mul1_op = 0;
  log1_sel1 = 0; log1_sel2 = 0; log1_op = 0;
  reg_2_en = 0;
  reg_5_en = 0;
  reg_6_en = 0;
  reg_9_en = 0;
  reg_12_en = 0;
  reg_13_en = 0;
  reg_14_en = 0;

  case (state)
    S_IDLE: begin
      op_ready = 1'b1;
      if (start) next_state = S_CYCLE_1;
    end
    S_CYCLE_1: begin
      alu1_op = 1'b0;
      alu1_sel1 = 0;
      alu1_sel2 = 0;
      reg_2_en = 1'b1;
      mul1_op = 1'b0;
      mul1_sel1 = 1;
      mul1_sel2 = 1;
      reg_9_en = 1'b1;
      log1_op = 1'b0;
      log1_sel1 = 0;
      log1_sel2 = 0;
      reg_12_en = 1'b1;
      next_state = S_CYCLE_2;
    end
    S_CYCLE_2: begin
      alu1_op = 1'b1;
      alu1_sel1 = 1;
      alu1_sel2 = 1;
      reg_5_en = 1'b1;
      next_state = S_CYCLE_3;
    end
    S_CYCLE_3: begin
      mul1_op = 1'b0;
      mul1_sel1 = 0;
      mul1_sel2 = 0;
      reg_6_en = 1'b1;
      alu1_op = 1'b0;
      alu1_sel1 = 2;
      alu1_sel2 = 2;
      reg_13_en = 1'b1;
      next_state = S_CYCLE_4;
    end
    S_CYCLE_4: begin
      log1_op = 1'b1;
      log1_sel1 = 1;
      log1_sel2 = 1;
      reg_14_en = 1'b1;
      result_en = 1'b1;
      next_state = S_DONE;
    end
    S_DONE: begin
      done = 1'b1;
      next_state = S_IDLE;
    end
  endcase
end
endmodule