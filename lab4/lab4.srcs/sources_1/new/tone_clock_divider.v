`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/29/2024 03:56:51 PM
// Design Name: 
// Module Name: tone_clock_divider
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

// Input is a 100 MHz clock (100,000,000 cycles per second).
// To find a C4 tone (261 Hz), we use: 100,000,000 / (2 * 261) = ~191,571 cycles.
// To find a D4 tone (294 Hz), we use: 100,000,000 / (2 * 294) = ~170,068 cycles.
// To find a E4 tone (329 Hz), we use: 100,000,000 / (2 * 329) = ~151,976 cycles.
// To find a F4 tone (349 Hz), we use: 100,000,000 / (2 * 349) = ~143,267 cycles.
// To find a G4 tone (392 Hz), we use: 100,000,000 / (2 * 392) = ~127,551 cycles.
// To find a A4 tone (440 Hz), we use: 100,000,000 / (2 * 440) = ~113,636 cycles.
// To find a B4 tone (494 Hz), we use: 100,000,000 / (2 * 494) = ~101,215 cycles.
// To find a C5 tone (523 Hz), we use: 100,000,000 / (2 * 523) = ~95,602 cycles.
module tone_clock_divider(
    input wire clk,
    output wire tone_C4,
    output wire tone_D4,
    output wire tone_E4,
    output wire tone_F4,
    output wire tone_G4,
    output wire tone_A4,
    output wire tone_B4,
    output wire tone_C5
    );
    
    reg temp_C4, temp_D4, temp_E4, temp_F4, temp_G4, temp_A4, temp_B4, temp_C5;
    reg [31:0] counter_C4 = 0;
    reg [31:0] counter_D4 = 0;
    reg [31:0] counter_E4 = 0;
    reg [31:0] counter_F4 = 0;
    reg [31:0] counter_G4 = 0;
    reg [31:0] counter_A4 = 0;
    reg [31:0] counter_B4 = 0;
    reg [31:0] counter_C5 = 0;
    
    // For a C4 tone, toggle the clock at ~191,573 clock cycles.
    always @ (posedge (clk))
    begin
        if (counter_C4 == 191_571 - 1) begin
            counter_C4 <= 0;
            temp_C4 <= ~temp_C4;
        end
        else begin
            counter_C4 <= counter_C4 + 1;
            temp_C4 <= temp_C4;
        end
    end
    
    // For a D4 tone, toggle the clock at ~170,068 clock cycles.
    always @ (posedge (clk))
    begin
        if (counter_D4 == 170_068 - 1) begin
            counter_D4 <= 0;
            temp_D4 <= ~temp_D4;
        end
        else begin
            counter_D4 <= counter_D4 + 1;
            temp_D4 <= temp_D4;
        end
    end
    
    // For a E4 tone, toggle the clock at ~151,976 clock cycles.
    always @ (posedge (clk))
    begin
        if (counter_E4 == 151_976 - 1) begin
            counter_E4 <= 0;
            temp_E4 <= ~temp_E4;
        end
        else begin
            counter_E4 <= counter_E4 + 1;
            temp_E4 <= temp_E4;
        end
    end
    
    // For a F4 tone, toggle the clock at ~143,267 clock cycles.
    always @ (posedge (clk))
    begin
        if (counter_F4 == 143_267 - 1) begin
            counter_F4 <= 0;
            temp_F4 <= ~temp_F4;
        end
        else begin
            counter_F4 <= counter_F4 + 1;
            temp_F4 <= temp_F4;
        end
    end
    
    // For a G4 tone, toggle the clock at ~127,551 clock cycles.
    always @ (posedge (clk))
    begin
        if (counter_G4 == 127_551 - 1) begin
            counter_G4 <= 0;
            temp_G4 <= ~temp_G4;
        end
        else begin
            counter_G4 <= counter_G4 + 1;
            temp_G4 <= temp_G4;
        end
    end
        
    // For a A4 tone, toggle the clock at ~113,636 clock cycles.
    always @ (posedge (clk))
    begin
        if (counter_A4 == 113_636 - 1) begin
            counter_A4 <= 0;
            temp_A4 <= ~temp_A4;
        end
        else begin
            counter_A4 <= counter_A4 + 1;
            temp_A4 <= temp_A4;
        end
    end
    
    // For a B4 tone, toggle the clock at ~101,215 clock cycles.
    always @ (posedge (clk))
    begin
        if (counter_B4 == 101_215 - 1) begin
            counter_B4 <= 0;
            temp_B4 <= ~temp_B4;
        end
        else begin
            counter_B4 <= counter_B4 + 1;
            temp_B4 <= temp_B4;
        end
    end
    
    // For a B4 tone, toggle the clock at ~101,215 clock cycles.
    always @ (posedge (clk))
    begin
        if (counter_C5 == 95_602 - 1) begin
            counter_C5 <= 0;
            temp_C5 <= ~temp_C5;
        end
        else begin
            counter_C5 <= counter_C5 + 1;
            temp_C5 <= temp_C5;
        end
    end
    
    assign tone_C4 = temp_C4;
    assign tone_D4 = temp_D4;
    assign tone_E4 = temp_E4;
    assign tone_F4 = temp_F4;
    assign tone_G4 = temp_G4;
    assign tone_A4 = temp_A4;
    assign tone_B4 = temp_B4;
    assign tone_C5 = temp_C5;
endmodule
