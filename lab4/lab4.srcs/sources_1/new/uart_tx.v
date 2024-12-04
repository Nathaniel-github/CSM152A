
// This module comes from https://github.com/matt-alencar/fpga-uart-tx-rx/tree/master.
module uart_tx #(
    parameter CLK_FREQ = 100_000_000,  // System clock frequency
    parameter BAUD_RATE = 115200       // UART baud rate
)(
    input clk,               // System clock
    input reset,             // Reset signal
    input [7:0] tx_data,     // Byte to transmit
    input send,              // Trigger to send the byte
    output reg tx,           // UART transmit signal
    output reg ready         // Ready to accept next byte
);

    // Baud Rate Timing
    localparam TICKS_PER_BIT = CLK_FREQ / BAUD_RATE;

    // State Machine
    localparam IDLE = 0, START = 1, DATA = 2, STOP = 3;
    reg [1:0] state = IDLE;
    reg [15:0] baud_counter = 0;
    reg [3:0] bit_index = 0;
    reg [7:0] shift_reg = 0;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            tx <= 1;
            ready <= 1;
            baud_counter <= 0;
            bit_index <= 0;
        end else begin
            case (state)
                IDLE: begin
                    tx <= 1;
                    ready <= 1;
                    if (send) begin
                        state <= START;
                        ready <= 0;
                        shift_reg <= tx_data;
                        baud_counter <= 0;
                        bit_index <= 0;
                    end
                end
                START: begin
                    tx <= 0; // Start bit
                    if (baud_counter == TICKS_PER_BIT - 1) begin
                        state <= DATA;
                        baud_counter <= 0;
                    end else begin
                        baud_counter <= baud_counter + 1;
                    end
                end
                DATA: begin
                    tx <= shift_reg[bit_index];
                    if (baud_counter == TICKS_PER_BIT - 1) begin
                        baud_counter <= 0;
                        if (bit_index == 7) begin
                            state <= STOP;
                        end else begin
                            bit_index <= bit_index + 1;
                        end
                    end else begin
                        baud_counter <= baud_counter + 1;
                    end
                end
                STOP: begin
                    tx <= 1; // Stop bit
                    if (baud_counter == TICKS_PER_BIT - 1) begin
                        state <= IDLE;
                        baud_counter <= 0;
                    end else begin
                        baud_counter <= baud_counter + 1;
                    end
                end
            endcase
        end
    end
endmodule