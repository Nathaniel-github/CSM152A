module top_module (
    input clk,
    input reset,
    input send,
    input play,
    input [7:0] tone_switch,
    output tx,
    output ready
);
    uart_audio uart_audio_inst (
        .clk(clk),
        .reset(reset),
        .send(send),
        .play(play),
        .tone_switch(tone_switch),
        .tx(tx),
        .ready(ready)
    );
endmodule