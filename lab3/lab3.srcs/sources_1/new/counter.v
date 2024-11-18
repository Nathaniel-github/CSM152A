`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/13/2024 12:06:38 PM
// Design Name: 
// Module Name: counter
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


module counter(
    input wire master_clk,
    input wire one_clk,
    input wire two_clk,
    input wire rst,
    input wire pause,
    input wire select,
    input wire adjust,
    output wire[3:0] minL,
    output wire[3:0] minR,
    output wire[3:0] secL,
    output wire[3:0] secR
    );
    
    wire clk;
    
    // create a temporary clock variable for adjustment mode
    reg temp_clk;
    
    // initialize the minute and second counters to zero
    reg[5:0] mins = 0;
    reg[5:0] secs = 0;
    
    // create a variable for holding pause button input
    reg pause_flag = 0;
    
    // pick the correct clock depending on adjustment mode input
    // use blocking assignment (=) since clock values are obtained instantaneuosly
    always @ (*) begin
        // if adjustment mode switch is set to high, use the 2 Hz clock
        if (adjust) begin
            temp_clk = two_clk;
        end
        // otherwise, use the 1 Hz clock
        else begin
            temp_clk = one_clk;
        end
    end
    assign clk = temp_clk;
    
    // check if the pause button is pressed at every 1 Hz clock edge
    always @ (posedge (master_clk) or posedge (pause))
    begin
        if (pause) begin
            pause_flag <= ~pause_flag;
        end
    end
    
    always @ (posedge (clk) or posedge (rst))
    begin
        if (rst) begin
            mins <= 0;
            secs <= 0;
        end
        // only count if pause_flag isn't set (i.e. when pause button isn't toggled)
        else if (pause_flag == 0) begin
            // increment minutes or seconds at a rate of 2 Hz in adjustment mode
            if (adjust) begin
                // if select is 1, increment seconds
                if (select) begin
                    if (secs >= 59) begin
                        secs <= 0;
                    end
                    else begin
                        secs <= secs + 1;
                    end
                end
                // otherwise, select is 0 so increment minutes
                else begin
                    if (mins >= 59) begin
                        mins <= 0;
                    end
                    else begin
                        mins <= mins + 1;
                    end
                end
            end
            // increment normally if not in adjustment mode
            else begin
                if ((secs >= 59) && (mins >= 59)) begin
                    mins <= 0;
                    secs <= 0;
                end
                else if (secs >= 59) begin
                    mins <= mins + 1;
                    secs <= 0;
                end
                else begin
                    secs <= secs + 1;
                end
            end
        end
        /*else if ((secs >= 59) && (mins >= 59)) begin
            mins <= 0;
            secs <= 0;
        end
        else if (secs == 59) begin
            mins <= mins + 1;
            secs <= 0;
        end
        else begin
            secs <= secs + 1;
        end*/
    end
    
    assign minL = mins/10;
    assign minR = mins%10;
    assign secL = secs/10;
    assign secR = secs%10;
endmodule
