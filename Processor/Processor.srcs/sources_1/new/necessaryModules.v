`timescale 1ns / 1ps
module necessaryModules(    );
endmodule

module counter (Clock, Reset_n, Q);
    input Clock, Reset_n;  
    parameter n = 26;
    output reg[n-1:0] Q; 
    always@(posedge Clock or negedge Reset_n) begin 
         if(Reset_n) 
            Q <= 0; 
         else 
            Q <= Q + 1; 
         end  
 endmodule
 
module segment_choser4digit(num_arr_2,num_arr_1, sel, AN, SEG);
    input [7:0]num_arr_1;
    input [7:0]num_arr_2;
    input [1:0]sel;
    output [3:0]AN;
    output [7:0]SEG;
    assign SEG[7]=1'b0;
    wire  [3:0]num;
    seven_seg sg0(num,SEG);
    assign AN[3:0] = (sel == 2'b00) ? 4'b1110:
                     (sel == 2'b01) ? 4'b1101:
                     (sel == 2'b10) ? 4'b1011:
                     (sel == 2'b11) ? 4'b0111:
                                      4'b1111;
    assign num =     (sel == 2'b00) ? num_arr_1[3:0]:
                     (sel == 2'b01) ? num_arr_1[7:4]:
                     (sel == 2'b10) ? num_arr_2[3:0]:
                     (sel == 2'b11) ? num_arr_2[7:4]:
                                    4'bxx1x;
    
endmodule

module seven_seg(num,SEG_out);
    input [3:0]num;
    output [6:0]SEG_out;
    
    assign SEG_out=
        (num==4'b0000) ? 7'b1000000: //0
        (num==4'b0001) ? 7'b1111001: //1
        (num==4'b0010) ? 7'b0100100: //2
        (num==4'b0011) ? 7'b0110000: //3
        (num==4'b0100) ? 7'b0011001: //4
        (num==4'b0101) ? 7'b0010010: //5
        (num==4'b0110) ? 7'b0000010: //6
        (num==4'b0111) ? 7'b1111000: //7
        (num==4'b1000) ? 7'b0000000: //8
        (num==4'b1001) ? 7'b0010000: //9
        (num==4'b1010) ? 7'b0001000: //a
        (num==4'b1011) ? 7'b0000011: //b
        (num==4'b1100) ? 7'b0100111: //c
        (num==4'b1101) ? 7'b0100001: //d
        (num==4'b1110) ? 7'b0000110: //e
        (num==4'b1111) ? 7'b0001110: //f
                      7'b1111110; //^
                      
endmodule