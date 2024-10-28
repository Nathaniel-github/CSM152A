`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/23/2024 12:44:54 PM
// Design Name: 
// Module Name: FPCVT
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

// V = (-1)^S * F * 2^E
module FPCVT(
    D, S, E, F
    );
    
    // D is the input data in two's complement: [???? ???? ????]
    input wire [11:0] D;
    
    // S is the signed bit (1 = negative, 0 = positive): [0]-[1]
    // E is the exponent, three bits ranging from 0-7: [000]-[111]
    // F is the significand, four bits ranging from 0-15: [0000]-[1111]
    output wire S;
    output wire [2:0] E;
    output wire [3:0] F;
    
    // temp_mag will be assigned the 12-bit signed magnitude representation of D
    wire [11:0] temp_mag;
    
    // input is 12-bit D, 1-bit S, 12-bit temp_mag
    // convert D from two's complement to signed magnitude -> assign to temp_mag wire
    // get the signed bit D[11] -> assign to S
    sign_magnitude_converter get_magnitude(
        .complement_num(D),
        .signed_bit(S),
        .signed_num(temp_mag)
    );
    
    // exp will be assigned the 3-bit exponent corresponding to the num of leading zeros
    wire [2:0] exp;
    
    // input is temp_mag, exp
    // check 8 possible cases of leading zeros -> assign [000]-[111] to exp
    count_leading_zeros get_leading_zeros(
        .signed_num(temp_mag),
        .exp(exp)
    );
    
    // sig will be assigned the 4-bit significand from the 12-bit signed magnitude representation temp_mag
    wire [3:0] sig;
    // f will be assigned the 5th bit from temp_mag
    wire f;
    
    extract_leading_bits get_leading_bits(
        .signed_num(temp_mag),
        .exp(exp),
        .sig(sig),
        .fifth(f)
    );
    
    rounding get_rounded_value(
        .sig(sig), 
        .exp(exp), 
        .fifth(f), 
        .round_sig(F), 
        .round_exp(E)
    );
    
endmodule
