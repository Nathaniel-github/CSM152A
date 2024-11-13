`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/04/2024 01:31:23 PM
// Design Name: 
// Module Name: clock_dividerTB
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


module clock_dividerTB;
    // Inputs
    reg master;     // master clock
    reg reset;      // reset
    
    // Outputs
    wire two;       // 2 Hz clock
    wire one;       // 1 Hz clock
    wire faster;    // 200 Hz clock
    wire adj;       // ?? Hz clock
    
    clock_divider clk_test(
        .clk(master),
        .rst(reset),
        .two_clk(two),
        .one_clk(one),
        .faster_clk(faster),
        .adj_clk(adj)
    );
    
    // Initialize the master clock.
    // Since the clock operates at 100 MHz, each clock cycle is 10 ns as T (period) = 1/f (frequency).
    // [T = 1/f = 1/100 Mhz = 1/(100_000_000 cycle/sec)= 10 ns]
    // (i.e. at 100 MHz, there are 100 million periods in one sec & each period is 10 ns)
    initial begin
        // set the master clock to 0
        master = 0;
        reset = 1;
        #100;

        reset = 0;
        #100;
    end
    
    // toggle master clock b/w 0 and 1 to simulate a continous clock signal
    // delay the forever loop by 5 ns each iteration [as (10 ns)/2 = 5 ns per half cycle]
    always #5 master = ~master;
endmodule
