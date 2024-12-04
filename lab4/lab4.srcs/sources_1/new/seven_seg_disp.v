`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/03/2024 04:22:32 PM
// Design Name: 
// Module Name: seven_seg_disp
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module seven_seg_disp(
    input wire [7:0] tone_switch,   // user input from the 8 switches
    output wire [6:0] disp          // 7-seg display encoding
    );
    
    reg [6:0] display = 0;
    
    always @ (*)
    begin
    case(tone_switch)
        8'b00000000: display = 7'b1111111;  // "Blank"
        8'b00000001: display = 7'b0110001;  // "C"  
        8'b00000010: display = 7'b1000010;  // "D" 
        8'b00000100: display = 7'b0110000;  // "E" 
        8'b00001000: display = 7'b0111000;  // "F" 
        8'b00010000: display = 7'b0000100;  // "G" 
        8'b00100000: display = 7'b0001000;  // "A" 
        8'b01000000: display = 7'b1100000;  // "B" 
        8'b10000000: display = 7'b1110010;  // "C" (lowercase)
        default: display = 7'b0110001;      // "C"
    endcase
    end
    
    assign disp = display;
    
endmodule
