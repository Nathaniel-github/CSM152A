`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/29/2024 05:23:10 PM
// Design Name: 
// Module Name: tone_switcher
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


module tone_switcher(
    input wire [7:0] tone_switch,       // switches (user input)
    input wire tone_C4,                 // C4 tone
    input wire tone_D4,                 // D4 tone
    input wire tone_E4,                 // E4 tone
    input wire tone_F4,                 // F4 tone
    input wire tone_G4,                 // G4 tone
    input wire tone_A4,                 // A4 tone
    input wire tone_B4,                 // B4 tone
    input wire tone_C5,                 // C5 tone
    output wire tone                    // tone (default is C4)
    );
    
    reg temp = 1'b0;
    
    always @ (*) begin
        // each switch corresponds to a tone so check if only one is active at a time
        // no active tones = silence
        // several active tone = default to C4
        case(tone_switch)
            8'b00000000: temp = 1'b0;       // no switch is active
            8'b00000001: temp = tone_C4;
            8'b00000010: temp = tone_D4;
            8'b00000100: temp = tone_E4;
            8'b00001000: temp = tone_F4;
            8'b00010000: temp = tone_G4;
            8'b00100000: temp = tone_A4;
            8'b01000000: temp = tone_B4;
            8'b10000000: temp = tone_C5;
            default: temp = tone_C4;        // more than 1 switch is active
        endcase
    end
    
    assign tone = temp;
endmodule
