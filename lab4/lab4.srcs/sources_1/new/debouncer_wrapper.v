`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/04/2024 01:36:21 AM
// Design Name: 
// Module Name: debouncer_wrapper
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

// debounce all buttons/switches
module debouncer_wrapper(
    input wire clk,
    input wire [7:0] tone_switch,
    input wire reset,
    input wire send,
    input wire play,
    output wire [7:0] tone_switch_debounced,
    output wire reset_debounced,
    output wire send_debounced,
    output wire play_debounced
    );
    
    debouncer tone_0 (
        .clk(clk),
        .button(tone_switch[0]),
        .button_debounced(tone_switch_debounced[0])
    );
    
    debouncer tone_1 (
        .clk(clk),
        .button(tone_switch[1]),
        .button_debounced(tone_switch_debounced[1])
    );
        
    debouncer tone_2 (
        .clk(clk),
        .button(tone_switch[2]),
        .button_debounced(tone_switch_debounced[2])
    );
    
    debouncer tone_3 (
        .clk(clk),
        .button(tone_switch[3]),
        .button_debounced(tone_switch_debounced[3])
    );
        
    debouncer tone_4 (
        .clk(clk),
        .button(tone_switch[4]),
        .button_debounced(tone_switch_debounced[4])
    );     
            
    debouncer tone_5 (
        .clk(clk),
        .button(tone_switch[5]),
        .button_debounced(tone_switch_debounced[5])
    );
                
    debouncer tone_6 (
        .clk(clk),
        .button(tone_switch[6]),
        .button_debounced(tone_switch_debounced[6])
    );
    
    debouncer tone_7 (
        .clk(clk),
        .button(tone_switch[7]),
        .button_debounced(tone_switch_debounced[7])
    );
        
    debouncer tone_8 (
        .clk(clk),
        .button(tone_switch[8]),
        .button_debounced(tone_switch_debounced[8])
    );
    
    debouncer reset_button (
        .clk(clk),
        .button(reset),
        .button_debounced(reset_debounced)
    );
    
    debouncer send_button (
        .clk(clk),
        .button(send),
        .button_debounced(send_debounced)
    );
        
    debouncer play_button (
        .clk(clk),
        .button(play),
        .button_debounced(play_debounced)
    );
endmodule
