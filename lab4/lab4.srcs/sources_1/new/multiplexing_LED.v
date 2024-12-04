`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/04/2024 12:53:09 AM
// Design Name: 
// Module Name: multiplexing_LED
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


module multiplexing_LED(
    input wire [7:0] tone_switch,   // user input from the 8 switches
    output wire [7:0] led           // 7-seg display encoding
    );
    
    assign led[7:0] = tone_switch[7:0];
    
endmodule