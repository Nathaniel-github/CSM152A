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
    output reg [2:0] exp;
    
    always @(*) begin
        case(signed_num)
            12'b01??????????: exp = 3'b111;
            12'b001?????????: exp = 3'b110;
            12'b0001????????: exp = 3'b101;
            12'b00001???????: exp = 3'b100;
            12'b000001??????: exp = 3'b011;
            12'b0000001?????: exp = 3'b010;
            12'b00000001????: exp = 3'b001;
            default: exp = 3'b000;
        endcase
    end
endmodule
