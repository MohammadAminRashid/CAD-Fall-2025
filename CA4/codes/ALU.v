`define First_Quarter 2'b00            
`define Second_Quarter 2'b01            
`define Third_Quarter  2'b10   
`define Fourth_Quarter 2'b11                 
                  
module ALU #(parameter N=32)(
input [N-1:0] A,B,C,D,
input [1:0] opc,

output reg [N-1:0] out
);

 always @(A,B,C,D,opc) begin 

    case(opc)

    `First_Quarter: out= (B & C) | ((~B) & D) ;
    `Second_Quarter: out= (D & B) | ((~D) & C);
    `Third_Quarter: out= B ^ C ^ D;
    `Fourth_Quarter : out= C ^ (B |(~D) ) ;
    default:out=0;

    endcase

  end
endmodule


