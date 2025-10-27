module demux(input SerIn, input [2:0]sel, output reg [7:0] out);

    always @(SerIn, sel) begin

        P = 8'b00000000;
        case(sel)
            3'b000:
                out[0]=SerIn;
            3'b001:
                out[1]=SerIn;
            3'b010:
                out[2]=SerIn;
            3'b011:
                out[3]=SerIn;
            3'b100:
                out[4]=SerIn;
            3'b101:
                out[5]=SerIn;
            3'b110:
                out[6]=SerIn;
            3'b111:
                out[7]=SerIn;
        endcase
        
    end
endmodule