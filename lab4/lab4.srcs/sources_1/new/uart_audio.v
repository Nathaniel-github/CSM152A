`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/21/2024 03:46:28 PM
// Design Name: 
// Module Name: uart_audio
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

module uart_audio (
    input wire clk,          // 100 MHz system clock
    input wire reset,        // Reset signal
    input wire send,         // Send enable signal
    input wire play,
    input wire [7:0] tone_switch, // Note selector (e.g., C4, D4, E4)
    output wire tx          // UART transmit line
);
    parameter CLK_FREQ = 100_000_000;  // System clock frequency
    parameter BAUD_RATE = 115200;     // UART baud rate
    
    // UART Serial Transmitter Variables
    reg [7:0] tx_data;       // Data to send via UART (1 byte)
    reg send_sample;         // Trigger signal for UART transmission
    wire tx_ready;           // UART transmitter ready signal
    
    // Create wires that will contain the frequency of each tone.
    wire tone_C4, tone_D4, tone_E4, tone_F4, tone_G4, tone_A4, tone_B4, tone_C5;
    
    // Generate tone frequencies.
    tone_clock_divider tones(
        .clk(clk),
        .tone_C4(tone_C4),
        .tone_D4(tone_D4),
        .tone_E4(tone_E4),
        .tone_F4(tone_F4),
        .tone_G4(tone_G4),
        .tone_A4(tone_A4),
        .tone_B4(tone_B4),
        .tone_C5(tone_C5)
    );

    // Tone Selection
    wire tone_wave;         // Square wave signal (0 or 1)
    
    tone_switcher switcher(
        .tone_switch(tone_switch),
        .tone_C4(tone_C4),
        .tone_D4(tone_D4),
        .tone_E4(tone_E4),
        .tone_F4(tone_F4),
        .tone_G4(tone_G4),
        .tone_A4(tone_A4),
        .tone_B4(tone_B4),
        .tone_C5(tone_C5),
        .tone(tone_wave)
    );
    
    // Song
    reg song_index = 0;
    reg song_notes [19:0];
    
    always @ (*) begin
        song_notes[0] = tone_E4;
        song_notes[1] = tone_G4;
        song_notes[2] = tone_A4;
        song_notes[3] = tone_G4;
        song_notes[4] = tone_E4;
        song_notes[5] = tone_F4;
        song_notes[6] = tone_A4;
        song_notes[7] = tone_B4;
        song_notes[8] = tone_A4;
        song_notes[9] = tone_F4;
        song_notes[10] = tone_C4;
        song_notes[11] = tone_E4;
        song_notes[12] = tone_F4;
        song_notes[13] = tone_E4;
        song_notes[14] = tone_C4;
        song_notes[15] = tone_G4;
        song_notes[16] = tone_B4;
        song_notes[17] = tone_C4;
        song_notes[18] = tone_B4;
        song_notes[19] = tone_G4;
    end
    
    reg play_flag = 0;
    reg [31:0] uart_counter = 0;       // Counter for square wave toggling
    reg [31:0] note_duration_counter = 0; // Counter for note duration
    reg uart_square_wave = 0;          // UART-compatible square wave
    wire [31:0] note_period;           // Half-period of the current note
    
    assign note_period = CLK_FREQ / (2 * song_notes[song_index]);
    
    always @ (posedge play) begin
        play_flag <= 1;
    end
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            send_sample <= 0;
            tx_data <= 0;
            play_flag <= 0;
            song_index <= 0;
            uart_counter <= 0;
            note_duration_counter <= 0;
            uart_square_wave <= 0;
        end else if (play_flag) begin
            if (song_index < 20) begin
                // Generate square wave
                if (uart_counter >= note_period) begin
                    uart_square_wave <= ~uart_square_wave;  // Toggle square wave
                    uart_counter <= 0;
                end else begin
                    uart_counter <= uart_counter + 1;
                end
    
                // Transmit square wave via UART
                if (tx_ready) begin
                    tx_data <= uart_square_wave ? 8'hFF : 8'h00;
                end
    
                // Track note duration
                if (note_duration_counter >= CLK_FREQ * 2) begin // Example: play each note for 1/8 second
                    note_duration_counter <= 0;
                    song_index <= song_index + 1; // Move to the next note
                end else begin
                    note_duration_counter <= note_duration_counter + 1;
                end
                
                send_sample <= 1;
            end else begin
                // End of song
                song_index <= 0;
                play_flag <= 0;
                send_sample <= 0;
            end
        end else if (!play_flag && send && tx_ready) begin
            tx_data <= tone_wave ? 8'hFF : 8'h00; // Send 255 (high) or 0 (low)
            send_sample <= 1;                      // Trigger UART transmission
        end else begin
            send_sample <= 0; // Clear send signal
        end
    end
    
    // UART Serial Transmitter
    uart_tx #(
        .CLK_FREQ(CLK_FREQ),
        .BAUD_RATE(BAUD_RATE)
    ) uart_transmitter (
        .clk(clk),
        .reset(reset),
        .tx_data(tx_data),
        .send(send_sample),
        .tx(tx),
        .ready(tx_ready)
    );
endmodule

// Transmit square wave values via UART
/*always @(posedge clk or posedge reset) begin
    if (reset) begin
        send_sample <= 0;
        ready <= 1;
    end else if (send && tx_ready) begin
        tx_data <= square_wave ? 8'hFF : 8'h00; // Send 255 (high) or 0 (low)
        send_sample <= 1;                      // Trigger UART transmission
    end else begin
        send_sample <= 0; // Clear send signal
    end
end*/

/*always @(posedge clk or posedge reset) begin
        if (reset) begin
            send_sample <= 0;
            tx_data <= 0;
            play_flag <= 0;
            ready <= 1;
        end
        else if (play_flag) begin
            // if uart is ready to receive next byte
            if (tx_ready && song_index <= 19) begin
                tx_data <= song_notes[song_index];
                send_sample <= 1;
                if (send_sample) begin
                    send_sample <= 0;
                end
                song_index <= song_index + 1;
            end
            else if (song_index >= 20) begin
                song_index <= 0;
                play_flag <= 0;
                ready <= 1;
            end
        end
        else if (!play_flag && send && tx_ready) begin
            tx_data <= tone_wave ? 8'hFF : 8'h00; // Send 255 (high) or 0 (low)
            send_sample <= 1;                      // Trigger UART transmission
        end else begin
            send_sample <= 0; // Clear send signal
        end
    end*/