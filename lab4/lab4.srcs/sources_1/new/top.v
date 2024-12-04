module top_module (
    input clk,              // 100 MHz clock
    input rst,              // reset button
    input snd,              // send button
    input ply,              // play button
    input [7:0] tone_switch,// tone switches
    output tx,
    output [7:0] led,
    output [3:0] anode,
    output [6:0] display
);
    // debounce each input
    wire [7:0] tone_switches;
    wire reset, send, play;
    
    debouncer_wrapper debounce_all (
        .clk(clk),
        .tone_switch(tone_switch),
        .reset(rst),
        .send(snd),
        .play(ply),
        .tone_switch_debounced(tone_switches),
        .reset_debounced(reset),
        .send_debounced(send),
        .play_debounced(play)
    );
    
    uart_audio uart_audio_inst (
        .clk(clk),
        .reset(reset),
        .send(send),
        .play(play),
        .tone_switch(tone_switches),
        .tx(tx)
    );
    
    seven_seg_disp display_encoder (
        .tone_switch(tone_switches),
        .disp(display)
    ); 
    
    multiplexing_display display_controller (
        .clk(clk),
        .tone_switch(tone_switches),
        .anode(anode)
    );
    
    multiplexing_LED LED_controller (
        .tone_switch(tone_switches),
        .led(led)
    );
        
endmodule