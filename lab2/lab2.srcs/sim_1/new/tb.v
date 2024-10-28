`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/23/2024 12:45:39 PM
// Design Name: 
// Module Name: tb
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


module tb;
    reg [11:0] D;
    wire S;
    wire [2:0] E;
    wire [3:0] F;
    
    FPCVT tester(
        .D(D),
        .S(S),
        .E(E),
        .F(F)
    );
    
    initial begin
        D = 12'b000000000000;
        #100
        D = 12'b111111111111;
    
    end
    
endmodule
