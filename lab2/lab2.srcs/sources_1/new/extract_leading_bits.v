`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/23/2024 01:18:05 PM
// Design Name: 
// Module Name: extract_leading_bits
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


module extract_leading_bits(
    signed_num, exp, sig, fifth
    );
    
    input wire [11:0] signed_num;
    input wire [2:0] exp;
    output wire [3:0] sig;
    output wire fifth;
    
    reg [11:0] last_bit_extractor;
    
    always @(*) begin
        last_bit_extractor = signed_num;
        last_bit_extractor = last_bit_extractor >> (exp-1);
    end
    
    assign fifth = last_bit_extractor[0];
    assign sig = (signed_num >> exp);
    
endmodule
