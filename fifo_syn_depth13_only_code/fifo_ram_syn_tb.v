`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/05/2022 04:48:10 AM
// Design Name: 
// Module Name: fifo_ram_syn_tb
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


module fifo_ram_syn_tb(); 
    parameter DATA_WIDTH = 8; 
    parameter ADDR_WIDTH = 4;
    parameter ADDR_AVALABLE = 13; 
    
    reg   clk, reset; 
    reg   rd, wr; 
    reg   [DATA_WIDTH - 1: 0] w_data; 
    wire  [DATA_WIDTH - 1: 0] r_data;
    wire  empty, full;
    
    integer j; 
    fifo_ram_sym    #(.DATA_WIDTH(DATA_WIDTH), 
                      .ADDR_WIDTH(ADDR_WIDTH),
                      .ADDR_AVALABLE(ADDR_AVALABLE)
                    )
    fifo_ram_syn_tb (.clk(clk), 
                     .reset(reset), 
                     .r_en(rd), 
                     .w_en(wr), 
                     .w_data(w_data), 
                     .r_data(r_data), 
                     .empty(empty), 
                     .full(full)
                     );
     initial begin
        clk = 1'b0;
        w_data = 8'd0;
        wr = 1'b0;
        rd = 1'b0;
        reset = 1'b0;  
    end 
    
    always begin 
        #1.429 clk = 1'b1; 
        #1.429 clk = 1'b0; 
    end   
    
    always begin
        #10 reset = 1'b1; 
        #5  reset = 1'b0;
        
        #50 wr = 1'b0; 
            rd = 1'b0;
        // case 2: write full before read 
        #50 wr = 1'b1;   
        for (j = 0; j < 20; j = j + 1) begin 
            @(negedge clk) w_data = $random;
        end
        #5 wr = 1'b0;
           rd = 1'b1; 
        #1000;
    end
endmodule
