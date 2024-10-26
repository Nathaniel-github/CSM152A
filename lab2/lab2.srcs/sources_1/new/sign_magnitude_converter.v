`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/23/2024 12:46:18 PM
// Design Name: 
// Module Name: sign_magnitude_converter
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


module sign_magnitude_converter(
    signed_num, signed_bit, complement_num
    );
    
    input wire [11:0] complement_num;
    output wire signed_bit;
    output wire [11:0] signed_num;
    
    assign signed_bit = complement_num[11];
    
    reg [11:0] temp_sign;
    
    always @(*) begin
        temp_sign = signed_num;
        if (complement_num == 12'b100000000000) begin
            temp_sign = 12'b011111111111;
        end else if (signed_bit == 1) begin
            temp_sign = ~complement_num + 1'b1;
        end else begin
            temp_sign = complement_num;
        end
    end
        
    assign signed_num = temp_sign;
    
endmodule
