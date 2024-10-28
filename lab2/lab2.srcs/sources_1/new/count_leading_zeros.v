`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/23/2024 01:06:29 PM
// Design Name: 
// Module Name: count_leading_zeros
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


module count_leading_zeros(
    signed_num, exp
    );
    
    input wire [11:0] signed_num;
    output wire [2:0] exp;
    
    reg[2:0] temp_exp;
    
    always @(*) begin
        if (signed_num[10]) begin
            temp_exp = 3'b111;
        end
        else if (signed_num[9]) begin
            temp_exp = 3'b110;
        end
        else if (signed_num[8]) begin
            temp_exp = 3'b101;
        end
        else if (signed_num[7]) begin
            temp_exp = 3'b100;
        end
        else if (signed_num[6]) begin
            temp_exp = 3'b011;
        end
        else if (signed_num[5]) begin
            temp_exp = 3'b010;
        end
        else if (signed_num[4]) begin
            temp_exp = 3'b001;
        end
        else begin
            temp_exp = 3'b000;
        end
    end
    
    assign exp = temp_exp;
    
endmodule
