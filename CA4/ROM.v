module ROM #(parameter BW = 32, parameter N = 64) (addrBus , outBus);

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

  input  [ADDR_WIDTH-1:0] addrBus;
  output [BW-1:0]         outBus;

  reg [BW-1:0] ROMData [0:N-1];

  initial begin
    $readmemh("k.mem", ROMData, 0, N-1);
  end

  assign outBus = ROMData[addrBus];

endmodule
