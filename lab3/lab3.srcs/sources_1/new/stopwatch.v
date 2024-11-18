`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/15/2024 08:59:47 PM
// Design Name: 
// Module Name: stopwatch
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


module stopwatch(
    input wire clk,             // master clock
    input wire rst,             // reset button user input
    input wire pau,             // pause button user input
    input wire sel,             // select switch user input
    input wire ajt,             // adjust swtich user input
    output wire[3:0] anode,
    output wire[6:0] display
    );
    
    // counts for each digit
    wire[3:0] minL;
    wire[3:0] minR;
    wire[3:0] secL;
    wire[3:0] secR;
    
    // seven segment display encodings for each digit
    wire[6:0] disp_minL;
    wire[6:0] disp_minR;
    wire[6:0] disp_secL;
    wire[6:0] disp_secR;
    
    // four clocks
    wire two, one, faster, adj;
    
    // debounced push buttons
    wire reset, pause;
    
    // debounced switches
    wire select, adjust;
    
    // debounce the reset push button
    debouncer reset_debounce(
        .clk(clk),
        .button(rst),
        .button_debounced(reset)
    );
    
    // debounce the pause push button
    debouncer pause_debounce(
        .clk(clk),
        .button(pau),
        .button_debounced(pause)
    );
    
    // debounce the select switch
    debouncer select_debounce(
        .clk(clk),
        .button(sel),
        .button_debounced(select)
    );
    
    // debounce the adjust switch
    debouncer adjust_debounce(
        .clk(clk),
        .button(ajt),
        .button_debounced(adjust)
    );
    
    // divide the master clock
    clock_divider divide(
        .clk(clk),
        .rst(reset),
        .two_clk(two),
        .one_clk(one),
        .faster_clk(faster),
        .adj_clk(adj)
    );
    
    // feed the 1 Hz and 2 Hz clocks to the counter
    counter count(
        .master_clk(clk),
        .one_clk(one),
        .two_clk(two),
        .rst(reset),
        .pause(pause),
        .select(select),
        .adjust(adjust),
        .minL(minL),
        .minR(minR),
        .secL(secL),
        .secR(secR)
    );
    
    // obtain the seven segment display encodings for each digit
    seven_seg_disp minuteL(
        .digit(minL),
        .disp(disp_minL)
    );
    
    seven_seg_disp minuteR(
        .digit(minR),
        .disp(disp_minR)
    );
    
    seven_seg_disp secondL(
        .digit(secL),
        .disp(disp_secL)
    );
    
    seven_seg_disp secondR(
        .digit(secR),
        .disp(disp_secR)
    );
    
    multiplexing_display multiplexer(
        .faster_clk(faster),
        .adj_clk(adj),
        .select(select),
        .adjust(adjust),
        .disp_minL(disp_minL),
        .disp_minR(disp_minR),
        .disp_secL(disp_secL),
        .disp_secR(disp_secR),    
        .anode(anode),
        .display(display)
    );
endmodule
