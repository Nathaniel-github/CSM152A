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
    input wire clk,
    input wire rst,
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
    
    wire two, one, faster, adj;
    
    // divide the master clock
    clock_divider divide(
        .clk(clk),
        .rst(rst),
        .two_clk(two),
        .one_clk(one),
        .faster_clk(faster),
        .adj_clk(adj)
    );
    
    counter count(
        .clk(one),
        .rst(rst),
        .minL(minL),
        .minR(minR),
        .secL(secL),
        .secR(secR)
    );
    
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
        .disp_minL(disp_minL),
        .disp_minR(disp_minR),
        .disp_secL(disp_secL),
        .disp_secR(disp_secR),    
        .anode(anode),
        .display(display)
    );
endmodule
