`timescale 1ns / 1ps
module Shifter(inp,dir,shamt,out);
    parameter n = 16;
    input [4:0]shamt;
    input dir;
    input [n-1:0]inp;
    //parameter LSR = 2'b11, LSL =2'b10, ASR = 2'b01, Stay = 2'b00;
    output reg[n-1:0]out;
    
    always @(inp,dir,shamt)
    begin
    case (dir)
        1'b1:   begin
                case (shamt)
                    4'd0: out = inp;
                    4'd1: out = {1'd0,inp[n-1:1]};
                    4'd2: out = {2'd0,inp[n-1:2]};
                    4'd3: out = {3'd0,inp[n-1:3]};
                    4'd4: out = {4'd0,inp[n-1:4]};
                    4'd5: out = {5'd0,inp[n-1:5]};
                    4'd6: out = {6'd0,inp[n-1:6]};
                    4'd7: out = {7'd0,inp[n-1:7]};
                    4'd8: out = {8'd0,inp[n-1:8]};
                    4'd9: out = {9'd0,inp[n-1:9]};
                    4'd10: out = {10'd0,inp[n-1:10]};
                    4'd11: out = {11'd0,inp[n-1:11]};
                    4'd12: out = {12'd0,inp[n-1:12]};
                    4'd13: out = {13'd0,inp[n-1:13]};
                    4'd14: out = {14'd0,inp[n-1:14]};
                    4'd15: out = {15'd0,inp[15]};
                endcase
                end
        1'b0:   begin   //left
                    case (shamt)
                    4'd0: out = inp;
                    4'd1: out = {inp[n-2:0],1'd0 };
                    4'd2: out = {inp[n-3:0],2'd0 };
                    4'd3: out = {inp[n-4:0],3'd0 };
                    4'd4: out = {inp[n-5:0],4'd0 };
                    4'd5: out = {inp[n-6:0],5'd0 };
                    4'd6: out = {inp[n-7:0],6'd0 };
                    4'd7: out = {inp[n-8:0],7'd0 };
                    4'd8: out = {inp[n-9:0],8'd0 };
                    4'd9: out = {inp[n-10:0],9'd0 };
                    4'd10: out = {inp[n-11:0],10'd0 };
                    4'd11: out = {inp[n-12:0],11'd0 };
                    4'd12: out = {inp[n-13:0],12'd0 };
                    4'd13: out = {inp[n-14:0],13'd0 };
                    4'd14: out = {inp[n-15:0],14'd0 };
                    4'd15: out = {inp[0],15'd0 };
                    endcase
                end 
    endcase              
    end
    
endmodule