`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/18/2024 01:30:47 AM
// Design Name: 
// Module Name: debouncer
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

// the debouncer filters out glitches to stabilize the button/switch input
module debouncer(
    input wire clk,                 // 100 MHz
    input wire button,
    output wire button_debounced
    );
    
    reg button_temp = 0;
    
    // since the 100 MHz clock is used (high frequency), a suitable debounce
    // duration is reached when counting 200,000 clock cycles (2 ms)
    // duration = 200,000/100,000,000 = 0.002 s = 2 ms
    reg[17:0] duration = 0;
    
    always @ (posedge (clk)) begin
        // when the button is pressed, begin counting and set button_temp to 1 when duration is reached
        if (button) begin
            duration <= duration + 1;
            if (duration >= 18'd199_999) begin
                button_temp <= 1;
                duration <= 0;
            end
        end
        // button isn't pressed
        else begin
            button_temp <= 0;
            duration <= 0;
        end
    end
    
    assign button_debounced = button_temp;
endmodule
