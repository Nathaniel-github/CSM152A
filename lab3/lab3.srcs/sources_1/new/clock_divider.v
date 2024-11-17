`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/04/2024 12:27:12 PM
// Design Name: 
// Module Name: clock_divider
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

// Clock Module that takes the 100 MHz master clock and outputs 4 clocks:
// 2 Hz, 1 Hz, 60 Hz, and adjusment mode clock
module clock_divider(
    input wire clk,
    input wire rst,
    output wire two_clk,
    output wire one_clk,
    output wire faster_clk,
    output wire adj_clk
    );
    
    reg[25:0] two_counter = 0;
    reg[25:0] one_counter = 0;
    reg[25:0] faster_counter = 0;
    reg[25:0] adj_counter = 0;
    
    reg two_temp = 0;
    reg one_temp = 0;
    reg faster_temp = 0;
    reg adj_temp = 0;
    
    always @ (posedge (clk) or posedge (rst))
    begin
        // 2 Hz clock
        // To get 2 Hz (2 cps) from 100 MHz, divide the total cycles in 100 MHz by 2: 100,000,000/2 = 50,000,000.
        // Every 50,000,000 cycles in a 100 MHz signal produces 1 cycle in a 2 Hz signal.
        // Each cycle takes 0.5 seconds [T = 1/f = 1/2 Hz = 0.5 seconds]. 
        // When two_counter reaches 25,000,000, toggle two_temp as we've reached half of one cycle (period).
        // Since there are 100_000_000 cycles, there are 4 toggles in total.
        if (rst == 1) begin
            two_counter <= 0;
            two_temp <= 0;
        end
        else if (two_counter == 25_000_000 - 1) begin
            two_counter <= 0;
            two_temp <= ~two_temp;
        end
        else begin
            two_counter <= two_counter + 1;
            two_temp <= two_temp;
        end
    end
      
    always @ (posedge (clk) or posedge (rst))
    begin
        if (rst == 1) begin
            one_counter <= 0;
            one_temp <= 0;
        end
        else if (one_counter == 50_000_000 - 1) begin
            one_counter <= 0;
            one_temp <= ~one_temp;
        end
        else begin
            one_counter <= one_counter + 1;
            one_temp <= one_temp;
        end 
    end
     
    always @ (posedge (clk) or posedge (rst))
    begin
        if (rst == 1) begin
            faster_counter <= 0;
            faster_temp <= 0;
        end
        else if (faster_counter == 55_000 - 1) begin
            faster_counter <= 0;
            faster_temp <= ~faster_temp;
        end
        else begin
            faster_counter <= faster_counter + 1;
            faster_temp <= faster_temp;
        end
    end
     
    always @ (posedge (clk) or posedge (rst))
    begin
        if (rst == 1) begin
            adj_counter <= 0;
            adj_temp <= 0;
        end
        else if (adj_counter == 12_500_000 - 1) begin
            adj_counter <= 0;
            adj_temp <= ~adj_temp;
        end
        else begin
            adj_counter <= adj_counter + 1;
            adj_temp <= adj_temp;
        end
    end
    
    assign two_clk = two_temp; 
    assign one_clk = one_temp;
    assign faster_clk = faster_temp;
    assign adj_clk = adj_temp;
    
endmodule
