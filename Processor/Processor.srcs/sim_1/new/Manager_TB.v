`timescale 1ns / 1ps
module Manager_TB;
reg CLK;
//reg [15:0]ICode; // 15:12 opcode      11:8 Rdest      7:4 opcode2     3:0 Rsrc //
Manager DUT(CLK);
initial CLK =1;
always #5 CLK = ~CLK;
initial begin
#400;                   // change if you add different instuctions.
$finish;
end
endmodule
