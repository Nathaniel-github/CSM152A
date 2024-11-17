`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/15/2024 07:36:43 PM
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
    input wire faster_clk,      // faster clock
    input wire adj_clk,         // adjustment mode clock
    input wire select,             // select
    input wire adjust,             // adjust
    input wire[6:0] disp_minL,      // seven segement display encoding for left minute X0:00
    input wire[6:0] disp_minR,      // seven segement display encoding for right minute 0X:00
    input wire[6:0] disp_secL,      // seven segement display encoding for left second 00:X0
    input wire[6:0] disp_secR,      // seven segement display encoding for right second 00:0X
    output reg[3:0] anode,
    output reg[6:0] display
    );
    
    // LED_counter values:
    // 0 - activate LED1 (leftmost LED = left minute)
    // 1 - activate LED2 (right minute)
    // 2 - activate LED3 (left second)
    // 3 - activate LED4 (rightmost LED = right second)
    reg[1:0] LED_counter = 2'b00;
    
    // cycle thru all 4 LEDs, propogating the value for the next LED at each clock edge
    always @ (posedge (faster_clk))
    begin
        // check if adjust mode is set to high (i.e. adjust == 1)
        if (adjust) begin
            // select is set to high (i.e. select == 1); blink seconds
            if (select) begin
                case (LED_counter)
                    2'b00:
                    begin
                        anode = 4'b0111;
                        display <= disp_minL;
                        LED_counter <= 2'b01;
                    end
                    2'b01:
                    begin
                        anode = 4'b1011;
                        display <= disp_minR;
                        LED_counter <= 2'b10;
                    end
                    2'b10:
                    begin
                        anode = 4'b1101;
                        // display left second when adjustment clock signal is high, or 
                        // display a blank digit when the adjustment clock signal is low
                        if (adj_clk) begin
                            display <= disp_secL;
                        end
                        else begin
                            display <= 7'b1111111;
                        end
                        //display <= disp_secL;
                        LED_counter <= 2'b11;
                    end
                    2'b11:
                    begin
                        anode = 4'b1110;
                        // display right second when adjustment clock signal is high
                        if (adj_clk) begin
                            display <= disp_secR;
                        end
                        else begin
                            display <= 7'b1111111;
                        end
                        //display <= disp_secR;
                        LED_counter <= 2'b00;
                    end
               endcase
            end
            else begin // select is set to low (i.e. select == 0); blink minutes
                case (LED_counter)
                    2'b00:
                    begin
                        anode = 4'b0111;
                        // display left minute when adjustment clock signal is high
                        if (adj_clk) begin
                            display <= disp_minL;
                        end
                        else begin
                            display <= 7'b1111111;
                        end
                        //display <= disp_minL;
                        LED_counter <= 2'b01;
                    end
                    2'b01:
                    begin
                        anode = 4'b1011;
                        // display right minute when adjustment clock signal is high
                        if (adj_clk) begin
                            display <= disp_minR;
                        end
                        else begin
                            display <= 7'b1111111;
                        end
                        //display <= disp_minR;
                        LED_counter <= 2'b10;
                    end
                    2'b10:
                    begin
                        anode = 4'b1101;
                        display <= disp_secL;
                        LED_counter <= 2'b11;
                    end
                    2'b11:
                    begin
                        anode = 4'b1110;
                        display <= disp_secR;
                        LED_counter <= 2'b00;
                    end
               endcase
            end
        end
        else begin // regular mode (i.e. adjust == 0); display everything normally
            case (LED_counter)
                2'b00:
                begin
                    anode = 4'b0111;
                    display <= disp_minL;
                    LED_counter <= 2'b01;
                end
                2'b01:
                begin
                    anode = 4'b1011;
                    display <= disp_minR;
                    LED_counter <= 2'b10;
                end
                2'b10:
                begin
                    anode = 4'b1101;
                    display <= disp_secL;
                    LED_counter <= 2'b11;
                end
                2'b11:
                begin
                    anode = 4'b1110;
                    display <= disp_secR;
                    LED_counter <= 2'b00;
                end
           endcase
        end
    end
    /*always @ (posedge (faster_clk))
    begin 
        case (LED_counter)
            2'b00:
            begin
                anode = 4'b0111;
                display <= disp_minL;
                LED_counter <= 2'b01;
            end
            2'b01:
            begin
                anode = 4'b1011;
                display <= disp_minR;
                LED_counter <= 2'b10;
            end
            2'b10:
            begin
                anode = 4'b1101;
                display <= disp_secL;
                LED_counter <= 2'b11;
            end
            2'b11:
            begin
                anode = 4'b1110;
                display <= disp_secR;
                LED_counter <= 2'b00;
            end
       endcase
    end*/
endmodule
