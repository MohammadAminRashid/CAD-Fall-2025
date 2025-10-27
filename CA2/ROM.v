module ROM #(parameter BW = 32, parameter N = 64) ( clk,addrBus, write_data, write_en, outBus);

  function integer log2;
    input integer value;
    integer i;
    begin
      log2 = 0;
      for (i = value - 1; i > 0; i = i >> 1)
        log2 = log2 + 1;
    end
  endfunction

  localparam ADDR_WIDTH = log2(N);
  input clk;
  input   [ADDR_WIDTH-1:0] addrBus;
  input   [BW-1:0] write_data;
  input   write_en;
  output  [BW-1:0] outBus;

  reg [BW-1:0] ROMData [0:N-1];

  initial begin
    $readmemh("constant.mem", ROMData, 0, N-1);
  end

  always @(posedge clk) begin
    if (write_en)
      ROMData[addrBus] = write_data;
  end

  assign outBus = ROMData[addrBus];

endmodule

