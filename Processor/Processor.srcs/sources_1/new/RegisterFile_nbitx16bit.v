`timescale 1ns / 1ps
module Register_File_nbitx16bit(clkin,Ra,Rb,writeEnable,Rw,Wdata,Adata,Bdata,num);
parameter n=16;
output [15:0]num;
input clkin,writeEnable;
input [3:0]Ra;
input [3:0]Rb;
input [3:0]Rw;
input [15:0]Wdata;
output [15:0]Adata;
output [15:0]Bdata;
reg[n-1:0]main_data[15:0];
initial begin
main_data[0]=0;
end
assign Adata = main_data[Ra];
assign Bdata = main_data[Rb];

always @(posedge clkin) begin
    if (writeEnable)
        main_data[Rw] <= Wdata;
end
wire [15:0]num = main_data[0];
endmodule
