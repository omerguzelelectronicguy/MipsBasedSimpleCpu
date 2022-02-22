`timescale 1ns / 1ps
module main_memory(    input [3:0] adr,    input clkin,    output [15:0] dataout,    input [15:0] datain);
    
reg [15:0]data[15:0];
assign dataout = data[adr];
always@ (posedge clkin) begin
    data[adr] <= datain;
end

endmodule
