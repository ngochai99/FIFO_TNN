`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/29/2022 12:58:49 AM
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
    parameter ADDR_WIDTH = 3;
    
    reg   clk, reset; 
    reg   rd, wr; 
    reg   [DATA_WIDTH - 1: 0] w_data; 
    wire  [DATA_WIDTH - 1: 0] r_data;
    wire  empty, full;
    
    fifo_ram_syn    #(.DATA_WIDTH(DATA_WIDTH), 
                      .ADDR_WIDTH(ADDR_WIDTH)
                    )
    fifo_ram_syn_tb (.clk(clk), 
                     .reset(reset), 
                     .rd(rd), 
                     .wr(wr), 
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
        #1.428 clk = 1'b0; 
    end   
    
    always begin
        #10 reset = 1'b1; 
        #5  reset = 1'b0;
        
        // case 1: write and read into fifo the same time 
        #5 wr = 1'b1;
           rd = 1'b1;  
        for (integer i = 0; i < 2**ADDR_WIDTH; i = i + 1) begin 
            @(negedge clk) w_data = $random;
        end
        
        #50 wr = 1'b0; 
            rd = 1'b0;
        // case 2: write full before read 
        #50 wr = 1'b1;   
        for (integer j = 0; j < 2**ADDR_WIDTH; j = j + 1) begin 
            @(negedge clk) w_data = $random;
        end
        #5 wr = 1'b0;
           rd = 1'b1;
        #50
        //case 3: ...
        #1000 
        $finish;
     end   
      
     
endmodule
