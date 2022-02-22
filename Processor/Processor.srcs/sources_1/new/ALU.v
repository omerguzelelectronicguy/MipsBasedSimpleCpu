`timescale 1ns / 1ps
module ALU(A,B,sel_in,res,flags);
input [15:0]A;
input [15:0]B;
input [3:0]sel_in;
wire [3:0]sel;
adjust_selection sel_adjustment(sel_in,sel);
output [15:0]res;
output [15:0]flags; // Processor Status Register
/*15 - 12 (reserved)    11 I(0)     10 P(0)             9 E(0)  8 hardwire_0(0)     
7 Negative  6 Zero      5 overflow  4-3 hardwire_0(0)   2 Low   1 Trace(0)  0 Carry         */
wire N,Z,F,L,C;
assign flags[0] = C;
assign flags[2] = L;
assign flags[5] = F;
assign flags[6] = Z;
assign flags[7] = N;
assign flags[11:8] = 0;
assign flags[4:3] = 0;
assign flags[1] = 0;
wire [15:0]cout;
    repeating_pattern rp1       (A[0],      B[0],       sel,    sel[0],     cout[0],    res[0]);
    repeating_pattern rp2[14:0] (A[15:1],   B[15:1],    sel,    cout[14:0], cout[15:1], res[15:1]);
    
assign C = (sel == 4'b0101) ?  ~cout[15] : cout[15];
assign F = cout[15] ^ cout[14];
assign L = ~C;
assign N = F ^ res[15];
assign Z = (res == 16'd0) ? 1 : 0;
endmodule
module adjust_selection(selin,selout);
input [3:0]selin;
output [3:0]selout;
assign selout =     (selin == 4'b0011) ?    4'b0000://xor
                    (selin == 4'b0001) ?    4'b1000://and
                    (selin == 4'b0010) ?    4'b1010://or
                    (selin == 4'b0101) ?    4'b0100://sum
                    (selin == 4'b1001) ?    4'b0101://sub
                                            4'b0101;
endmodule
module repeating_pattern(a,b,sel,sel0,cout,s);

input a,b,sel0;
input[3:0]sel;
output cout;
output s;
wire sum , co;
wire bin , cin;

mux_1to2 mux1(b,~b,sel[0],bin);
wire [3:0]muxin;
assign muxin[1:0] = 2'b10;
assign muxin[2] = sel0;
assign muxin[3] = b;

mux_2to4 mux2(muxin,sel[2:1],cin);

full_adder fa1 (a,bin,cin,sum,co);
mux_1to2 mux3(sum,co,sel[3],s);
assign cout = co;


endmodule

module full_adder(a,b,ci,sum,co);
input a,b,ci;
output sum,co;
wire t;
assign t = a ^ b ;
assign sum = t ^ ci;
assign co = (t && ci) || (a && b);
endmodule

module mux_2to4(x,sel,out);
input [3:0]x;
input [1:0]sel;
output [3:0]out;
assign out =    (sel ==2'b11) ? x[3]:
                (sel ==2'b10) ? x[2]:
                (sel ==2'b01) ? x[1]:
                (sel ==2'b00) ? x[0]:
                                1'bx;
endmodule

module mux_1to2(x,y,sel,out);// x && ~sel , y && sel
input x,y,sel;
output out;

assign out = (sel && y) || (~sel && x);
endmodule