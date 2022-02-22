`timescale 1ns / 1ps
module ProgramCounter();
endmodule

module PC(btn,clkin,din,dout,numPC);
parameter bits = 16;

input  [5 : 0]          btn;
input  [bits/2-1 : 0]   din;
output [bits-1 : 0]     dout;
input clkin;
output [15:0]numPC;

wire [bits-1:0] din_extended = {(din[bits/2-1]) ? 8'hff : 8'h00 , din};

wire brench,jump, jump_load , return , start, reset;

assign {brench, jump, jump_load , return , start, reset} = btn[5:0];
reg [bits-1:0 ] PCval;
initial PCval=0;
reg [bits-1:0] RF;
instruction_mem ROM0(PCval,dout);//ROM(adr,icode)
assign numPC = PCval;
always@(posedge clkin ) begin
    if (reset)
        PCval <= 0;
    else if (jump)
        PCval <= din_extended;
    else if(jump_load)
        begin
        RF <= PCval + 1;
        PCval <= din_extended;
        end
    else if(return)
        PCval <= RF;
    else if(brench)//~brench for FPGA
        PCval <= PCval + din_extended;
    else if(~start)// ~start for FPGA
        PCval <= PCval + 1; 
end


endmodule
