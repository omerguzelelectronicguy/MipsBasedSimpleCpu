`timescale 1ns / 1ps
module Manager(CLK,SEG,BTN,AN);
input CLK;
input BTN;
output [7:0]SEG;
output [7:0]AN;
assign AN[7:4] = 4'b1111;
wire [25:0]tim;
counter count(CLK,BTN,tim);
wire oneHz = tim[25];

wire [15:0]ICode; // 15:12 opcode      11:8 Rdest      7:4 opcode2     3:0 Rsrc //
wire immediate , register, special, shift, bcond; //
wire [15:0]operation0;
decoder4to16 dec1(ICode[15:12], operation0);
//assign {register, special, shift, bcond} = operation0[0,4,8,12];
assign  {register,          special,            shift,          bcond} = 
        {operation0[0],     operation0[4],      operation0[8],  operation0[12]};
assign immediate = ICode[13] || ICode[12] || (~ICode[7] && ~ICode[6] && shift);
wire Mov_state = operation0[13] ? 1 : register ? (ICode[7:4] == 4'b1101) ? 1: 0:0;

wire [15:0]src;
wire [15:0]mem_src;
wire [15:0]mem_dest;
wire sign_extended , zero_extended;
assign  {sign_extended , zero_extended} = {(ICode[14] ^ ICode[15]) , ((ICode[14] ^ ICode[15]) && (ICode[12] || ICode[13])) };

assign src =    immediate ? (ICode[7] == 0) ? {8'h00, ICode[7:0]}   :
                            sign_extended ? {8'hff, ICode[7:0]}:
                                            {8'h00, ICode[7:0]}:
                mem_src;
wire [3:0]opcodeofALU = (register) ? ICode[7:4] : (ICode[12] || ICode[13]) ? ICode[15:12] : 4'b1001; 
wire writeEnable;
assign writeEnable = register ? (ICode[7] && ICode[5] && ICode[4]) ? 0 : 1 :
                                special ? (ICode[7] && ~ICode[5] && ~ICode[4]) ? 0 :1:
                                (ICode[15:12] == 4'b1011) ? 0:(ICode[15:12] == 4'b1100) ? 0:1;
wire [15:0]ALU_dataout;
wire [15:0]Shifter_dataout;
wire [15:0]MEM0_data_out;
wire [15:0]MEM0_data_in;
wire [15:0]data_to_move;
wire [15:0]flags;
wire LOAD = (special &&  (ICode[7:4] ==4'b0000 )) ? 1:0;
wire STORE =(special &&  (ICode[7:4] ==4'b0100 )) ? 1:0;
wire [15:0]num0;
wire [15:0]numPC;
assign data_to_move = shift ? Shifter_dataout : LOAD ? MEM0_data_out:   Mov_state ? immediate ? {8'd0, ICode[7:0]} : mem_src : ALU_dataout; //will change
Register_File_nbitx16bit data_mem16 (oneHz, ICode[11:8],ICode[3:0],writeEnable,ICode[11:8],data_to_move,mem_dest,mem_src, num0);//(clkin,Rsrc,Rdest,writeEnable,Rw,Wdata,Asrc,Bdest);
wire compare = register ? (ICode[7:4]==4'b1011)? 1 : 0 :(ICode[15:12]==4'b1011)? 1 : 0;
ALU ALU0(mem_dest,src,opcodeofALU,ALU_dataout,flags);

Shifter shifter0(mem_dest,ICode[4],immediate ? ICode[3:0] : src[3:0],Shifter_dataout);//Shifter(inp,dir,shamt,out);

wire condition_res;
wire JAL = (ICode[15:12] == 4'b0100) && (ICode[7:4] == 4'b1000); 
wire Jcond , return; 
assign return = 1'b0;
assign Jcond = (special  && (ICode[7:4] == 4'b1100)) ? 1:0;
wire [7:0]Rtarget = bcond ? ICode[7:0] : {4'd0, ICode[3:0]};

PC PC0({(bcond && condition_res) , (Jcond && condition_res) , JAL ,return, 2'b00},oneHz, Rtarget,ICode,numPC);//PC(btn,clkin,din,dout);//wire brench,jump, jump_load , return , start, reset;
flag_organizer_4to16 flag_organize(ICode[7:4] ,flags,oneHz,condition_res);//flag_organizer_4to16(inp,flag,out);
assign MEM0_data_in = mem_dest;
main_memory MEM0(ICode[3:0], oneHz && STORE ,MEM0_data_out,MEM0_data_in);//(    input [3:0] adr,    input clkin,    output [15:0] dataout,    input [15:0] datain);//


segment_choser4digit  sg(numPC[7:0],num0[7:0], tim[19:18], AN[3:0], SEG);//(num_arr_2,num_arr_1, sel, AN, SEG);
endmodule


module decoder4to16(inp,out);
input [3:0]inp;
output [15:0]out;
assign out =    (inp == 4'd0) ?   16'd1:
                (inp == 4'd1) ?   16'd2:
                (inp == 4'd2) ?   16'd4:
                (inp == 4'd3) ?   16'd8:
                (inp == 4'd4) ?   16'd16:
                (inp == 4'd5) ?   16'd32:
                (inp == 4'd6) ?   16'd64:
                (inp == 4'd7) ?   16'd128:
                (inp == 4'd8) ?   16'd256:
                (inp == 4'd9) ?   16'd512:
                (inp == 4'd10)?   16'd1024:
                (inp == 4'd11)?   16'd2048:
                (inp == 4'd12)?   16'd4096:
                (inp == 4'd13)?   16'd8192:
                (inp == 4'd14)?   16'd16384:
                (inp == 4'd15)?   16'd32768:
                                  16'dx;
        
endmodule

module flag_organizer_4to16(inp,flag,CLK,out);
input [15:0]flag;
input [3:0]inp;
input CLK;
output out;

reg N,Z,F,L,C;
always@(posedge CLK)begin

 {N,Z,F,L,C} <= {flag[7], flag[6], flag[5], flag[2], flag[0]};
end
assign out =    (inp == 4'd0) ?   Z:
		        (inp == 4'd1) ?  ~Z:
                (inp == 4'd2) ?   C:
                (inp == 4'd3) ?  ~C:
                (inp == 4'd4) ?   L:
                (inp == 4'd5) ?  ~L:
                (inp == 4'd6) ?   N:
                (inp == 4'd7) ?  ~N:
                (inp == 4'd8) ?   F:
                (inp == 4'd9) ?  ~F:
                (inp == 4'd10) ? ~(L||Z):
                (inp == 4'd11) ?  (L||Z):
                (inp == 4'd12) ? ~(N||Z):
                (inp == 4'd13) ?  (N||Z):
                (inp == 4'd14) ? 1'dx:
                (inp == 4'd15) ? 1'dx:
                              1'dx;
        
endmodule

