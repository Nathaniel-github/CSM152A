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
    input wire clk,                 // 100 MHz clock
    input wire reset,               // reset button
    input wire send,                // send button
    input wire play,                // play button
    input wire [7:0] tone_switch,   // tone switches (e.g., C4, D4, E4)
    output wire tx                  // UART transmit line
);
    parameter CLK_FREQ = 100_000_000;  // clock frequency
    parameter BAUD_RATE = 115200;     // UART baud rate
    
    // UART serial transmitter variables
    reg [7:0] tx_data;       // data sent via UART (1 byte at a time)
    reg send_sample;         // trigger signal for UART transmission
    wire tx_ready;           // UART transmitter ready signal
    
    // tone frequencies (constants)
    parameter C4 = 261, D4 = 293, E4 = 329, F4 = 349, G4 = 392, A4 = 440, B4 = 493, C5 = 523, D5 = 587,
            Dflat4 = 277, Dsharp4 = 311, Eflat4 = 311, Fsharp4 = 369, Gflat4 = 369, Gsharp4 = 415, Asharp4 = 466, Bflat4 = 466;     

    // "play" mode variables
    reg [31:0] song_notes [0:64];
    reg [6:0] song_index = 0;                    // index for song_notes array
    reg play_flag = 0;                    // play_flag is set when "play" is pressed
    
    // counters and flags for "play" mode, where a predefined song plays
    reg [31:0] wave_counter = 0;          // counter for square wave toggling
    reg [31:0] note_duration = 0;         // note duration counter
    reg square_wave = 0;             // square wave
    wire [31:0] note_period;              // half-period of the current note
    
    // build the period of the current note in the song_notes array
    // (ensure that the note is not 0 so we don't divide by zero)
    assign note_period = (song_notes[song_index] == 0) ? 32'hFFFFFFFF : CLK_FREQ / (2 * song_notes[song_index]);
    
    // fill the song_notes array w/ constant frequencies
    /*initial begin
        song_notes[0] = E4; song_notes[1] = G4; song_notes[2] = A4; song_notes[3] = G4;
        song_notes[4] = E4; song_notes[5] = F4; song_notes[6] = A4; song_notes[7] = B4;
        song_notes[8] = A4; song_notes[9] = F4; song_notes[10] = C4; song_notes[11] = E4;
        song_notes[12] = F4; song_notes[13] = E4; song_notes[14] = C4; song_notes[15] = G4;
        song_notes[16] = B4; song_notes[17] = C4; song_notes[18] = B4; song_notes[19] = G4;
    end */
    
    // this rendition sounds better
    initial begin
        song_notes[0] = E4; song_notes[1] = G4; song_notes[2] = A4; song_notes[3] = G4;
        song_notes[4] = E4; song_notes[5] = F4; song_notes[6] = A4; song_notes[7] = B4;
        song_notes[8] = A4; song_notes[9] = F4; song_notes[10] = D4; song_notes[11] = E4;
        song_notes[12] = F4; song_notes[13] = E4; song_notes[14] = D4; song_notes[15] = G4;
        song_notes[16] = B4; song_notes[17] = C5; song_notes[18] = B4; song_notes[19] = G4;
        song_notes[20] = F4; song_notes[21] = E4; song_notes[22] = D4; song_notes[23] = E4;
        song_notes[24] = F4; song_notes[25] = Fsharp4; song_notes[26] = G4; song_notes[27] = Gsharp4;
        song_notes[28] = A4; song_notes[29] = Asharp4; song_notes[30] = B4; song_notes[31] = C5;
    end
    
    // Great Fairy Fountain theme song (notes from https://youtube.com/shorts/yeE6A6O2_gg?si=obyjGdGM2FQFaW90)
    /*initial begin
        song_notes[0]  = A4;  song_notes[1]  = D4;  song_notes[2]  = Bflat4; song_notes[3]  = G4;
        song_notes[4]  = 0;   song_notes[5]  = G4;  song_notes[6]  = D4;  song_notes[7]  = Bflat4;
        song_notes[8]  = G4;  song_notes[9]  = 0;   song_notes[10] = Gflat4; song_notes[11] = D4;
        song_notes[12] = Bflat4; song_notes[13] = G4; song_notes[14] = 0;   song_notes[15] = G4;
        
        song_notes[16] = D4;  song_notes[17] = Bflat4; song_notes[18] = G4; song_notes[19] = E4;
        song_notes[20] = 0;   song_notes[21] = E4;  song_notes[22] = Bflat4; song_notes[23] = G4;
        song_notes[24] = E4;  song_notes[25] = 0;   song_notes[26] = Eflat4; song_notes[27] = Bflat4;
        song_notes[28] = G4;  song_notes[29] = E4;  song_notes[30] = 0;   song_notes[31] = E4;
        
        song_notes[32] = Bflat4; song_notes[33] = G4; song_notes[34] = E4; song_notes[35] = A4;
        song_notes[36] = 0;   song_notes[37] = F4;  song_notes[38] = D4; song_notes[39] = D4;
        song_notes[40] = 0;   song_notes[41] = A4;  song_notes[42] = F4; song_notes[43] = D4;
        song_notes[44] = Dflat4; song_notes[45] = A4; song_notes[46] = F4; song_notes[47] = D4;
        
        song_notes[48] = 0;   song_notes[49] = A4;  song_notes[50] = F4; song_notes[51] = D4;
        song_notes[52] = D4;  song_notes[53] = 0;   song_notes[54] = A4; song_notes[55] = F4;
        song_notes[56] = D4;  song_notes[57] = Dflat4; song_notes[58] = A4; song_notes[59] = F4;
        song_notes[60] = D4;  song_notes[61] = 0;   song_notes[62] = A4; song_notes[63] = F4;
    end*/

    // Create wires that will contain the frequency of each tone.
    wire tone_C4, tone_D4, tone_E4, tone_F4, tone_G4, tone_A4, tone_B4, tone_C5;
    
    // generate tone frequencies using system clock (for real-time user input playing)
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
    
    // tone wave will hold the square wave signal of the tone selected by the user
    wire tone_wave;         // square wave signal (0 or 1)
    
    // dynamically change the tone_wave signal according to user input from tone switches
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

    // check user input at each clock edge or reset toggle and adjust play_flag accordingly
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            play_flag <= 0;
        end else if (play) begin
            play_flag <= 1;
        end else if (song_index >= 20) begin
            play_flag <= 0;
        end
    end

    // main logic
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            wave_counter <= 0;
            note_duration <= 0;
            song_index <= 0;
            square_wave <= 0;
        end else if (play_flag) begin
            if (song_index < 20) begin
                // generate square wave for the current note in the array
                if (wave_counter >= note_period) begin
                    square_wave <= ~square_wave;
                    wave_counter <= 0;
                end else begin
                    wave_counter <= wave_counter + 1;
                end

                // move on to the next note in the array after 0.5 seconds
                if (note_duration >= (CLK_FREQ / 2)) begin
                    note_duration <= 0;
                    song_index <= song_index + 1;
                end else begin
                    note_duration <= note_duration + 1;
                end
            end
        end
    end
    
    // state machine states
    reg state = 2'b00;

    // state machine for "play" or normal mode
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= 2'b00;
            send_sample <= 0;
            tx_data <= 0;
        end else begin
            case (state)
                2'b00: begin    // 0 - idle state
                    if (play_flag && tx_ready) begin
                        // tone input from predefined sequence (play -> song_notes -> square_wave)
                        tx_data <= square_wave ? 8'hFF : 8'h00;
                        send_sample <= 1;
                        state <= 2'b01;
                    end else if (send && tx_ready) begin
                        // tone input from switches (tone_switch -> tone_wave)
                        tx_data <= tone_wave ? 8'hFF : 8'h00;
                        send_sample <= 1;
                        state <= 2'b01;
                    end
                end
                2'b01: begin    // 1 - send state
                    send_sample <= 0;
                    state <= 2'b10;
                end
                2'b10: begin    // 2 - wait state
                    if (tx_ready) begin
                        state <= 2'b00;
                    end
                end
            endcase
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