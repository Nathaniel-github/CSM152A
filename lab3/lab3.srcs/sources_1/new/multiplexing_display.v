`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/15/2024 07:36:43 PM
// Design Name: 
// Module Name: multiplexing_display
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


module multiplexing_display(
    input wire faster_clk,      // faster clock
    input wire adj_clk,         // adjustment mode clock
    //input wire sel,             // select
    //input wire adj,             // adjust
    input wire[6:0] disp_minL,      // seven segement display encoding for left minute X0:00
    input wire[6:0] disp_minR,      // seven segement display encoding for right minute 0X:00
    input wire[6:0] disp_secL,      // seven segement display encoding for left second 00:X0
    input wire[6:0] disp_secR,      // seven segement display encoding for right second 00:0X
    output reg[3:0] anode,
    output reg[6:0] display
    );
    
    // LED_counter values:
    // 0 - activate LED1 (leftmost LED = left minute)
    // 1 - activate LED2 (right minute)
    // 2 - activate LED3 (left second)
    // 3 - activate LED4 (rightmost LED = right second)
    reg[1:0] LED_counter = 2'b00;
    
    // cycle thru all 4 LEDs, propogating the value for the next LED at each clock edge
    always @ (posedge (faster_clk))
    begin 
        case (LED_counter)
            2'b00:
            begin
                anode = 4'b0111;
                display <= disp_minL;
                LED_counter <= 2'b01;
            end
            2'b01:
            begin
                anode = 4'b1011;
                display <= disp_minR;
                LED_counter <= 2'b10;
            end
            2'b10:
            begin
                anode = 4'b1101;
                display <= disp_secL;
                LED_counter <= 2'b11;
            end
            2'b11:
            begin
                anode = 4'b1110;
                display <= disp_secR;
                LED_counter <= 2'b00;
            end
       endcase
    end
endmodule
