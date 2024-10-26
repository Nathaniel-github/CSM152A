`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/23/2024 01:33:03 PM
// Design Name: 
// Module Name: rounding
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


module rounding(
    sig, signed_num, exp, fifth, round_sig, round_exp
    );
    
    input wire [3:0] sig;
    input wire [11:0] signed_num;
    input wire [2:0] exp;
    input wire fifth;
    output reg [3:0] round_sig;
    output reg [2:0] round_exp;
    
    reg round;
    
    always @(*) begin
        if (fifth == 0) begin
            round_sig = sig;
            round_exp = exp;
        end
        else begin
        // add edge cases here next time
            round_sig = sig + 1;
            round_exp = exp;
        end
    end
        
    
endmodule
