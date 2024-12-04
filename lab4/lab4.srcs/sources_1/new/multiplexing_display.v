`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/03/2024 05:05:34 PM
// Design Name: 
// Module Name: multiplexing_display
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


module multiplexing_display(
    input wire clk,
    input wire [7:0] tone_switch,
    output reg [3:0] anode
    );
    
    // segment_counter: 
    // 0 = leftmost segment, ..., 3 = rightmost segment
    reg [1:0] segment_counter;
    
    always @ (posedge clk) begin
        case (segment_counter)
            2'b00:
            begin
                anode = 4'b0111;
                segment_counter <= 2'b01;
            end
            2'b01:
            begin
                anode = 4'b1011;
                segment_counter <= 2'b10;
            end
            2'b10:
            begin
                anode = 4'b1101;
                segment_counter <= 2'b11;
            end
            2'b11:
            begin
                anode = 4'b1110;
                segment_counter <= 2'b00;
            end
        endcase
    end
endmodule
