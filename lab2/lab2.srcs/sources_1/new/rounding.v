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
    sig, exp, fifth, round_sig, round_exp
    );
    
    input wire [3:0] sig;
    input wire [2:0] exp;
    input wire fifth;
    output wire [3:0] round_sig;
    output wire [2:0] round_exp;
    
    reg [2:0] temp_re;
    reg [3:0] temp_rs;
    
    always @(*) begin
        if (fifth == 0) begin
            temp_rs = sig;
            temp_re = exp;
        end
        else begin
            if (sig == 4'b1111) begin
                if (exp == 3'b111) begin
                    temp_re = exp;
                    temp_rs = sig;
                end
                else begin
                    temp_re = exp + 1;
                    temp_rs = 4'b1000;
                end
            end
            else begin
                temp_rs = sig + 1;
                temp_re = exp;
            end
        end
    end
    
    assign round_sig = temp_rs;
    assign round_exp = temp_re; 
    
endmodule
