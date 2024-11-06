`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/04/2024 01:31:23 PM
// Design Name: 
// Module Name: clock_dividerTB
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


module clock_dividerTB;

    wire input_clk = 100_000_000;
    wire output_clk;
    
    clock_divider clk_test(
        .master_clk(input_clk),
        .two_clk(output_clk)
    );
    
    initial
    begin
    
    end
    
endmodule
