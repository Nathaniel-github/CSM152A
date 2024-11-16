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
    input clk,
    input rst,
    output wire[3:0] minL,
    output wire[3:0] minR,
    output wire[3:0] secL,
    output wire[3:0] secR
    );
    
    // 00:00
    reg[5:0] mins = 0;
    reg[5:0] secs = 0;
    
    always @ (posedge (clk) or posedge (rst))
    begin
        if (rst) begin
            mins <= 0;
            secs <= 0;
        end
        else if ((secs >= 59) && (mins >= 59)) begin
            mins <= 0;
            secs <= 0;
        end
        else if (secs == 59) begin
            mins <= mins + 1;
            secs <= 0;
        end
        else begin
            secs <= secs + 1;
        end
    end
    
    assign minL = mins/10;
    assign minR = mins%10;
    assign secL = secs/10;
    assign secR = secs%10;
endmodule
