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
// 2 Hz, 1 Hz, ?? Hz, and adjusment mode clock
module clock_divider(
    input wire master_clk,
    output wire two_clk,
    output wire one_clk,
    output wire faster_clk,
    output wire adj_mode_clk
    );
    
    reg[25:0] two_counter;
    reg[25:0] one_counter;
    reg[17:0] faster_counter;
    reg[24:0] adj_counter;
    
    reg two_temp;
    reg one_temp;
    reg faster_temp;
    reg adj_temp;
    
    initial begin
        two_counter = 0;
        one_counter = 0;
        faster_counter = 0;
        adj_counter = 0;
        
        two_temp = 0;
        one_temp = 0;
        faster_temp = 0;
        adj_temp = 0;
    end
    
    always @(posedge master_clk)
    begin
        // 100 MHz = 100,000,000 Hz; 50_000_000 is one cycle
        if (two_counter == 25_000_000 - 1) begin
            two_counter <= 0;
            two_temp <= ~two_temp;
        end
        else begin
            two_temp <= two_temp;
            two_counter <= two_counter + 1;
        end 
        
        if (one_counter == 50_000_000 - 1) begin
            one_counter <= 0;
            one_temp <= ~one_temp;
        end
        else begin
            one_temp <= one_temp;
            one_counter <= one_counter + 1;
        end 
        
        if (faster_counter == 250_000 - 1) begin
            faster_counter <= 0;
            faster_temp <= ~faster_temp;
        end
        else begin
            faster_temp <= faster_temp;
            faster_counter <= faster_counter + 1;
        end 
        
        if (adj_counter == 25_000_000 - 1) begin
            adj_counter <= 0;
            adj_temp <= ~adj_temp;
        end
        else begin
            adj_temp <= adj_temp;
            adj_counter <= adj_counter + 1;
        end 
        
    end
    
    assign two_clk = two_temp;
    assign one_clk = one_temp;
    assign faster_clk = faster_temp;
    assign adj_clk = adj_temp;
    
endmodule
