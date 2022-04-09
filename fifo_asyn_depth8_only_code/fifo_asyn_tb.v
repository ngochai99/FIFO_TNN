`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/02/2022 06:27:27 PM
// Design Name: 
// Module Name: fifo_asyn_tb
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


module fifo_asyn_tb();

        parameter DATA_WIDTH = 8;  
        parameter ADDR_WIDTH = 3;  
        
        reg  w_clk,  r_clk; 
        reg  w_rstn, r_rstn; 
        reg  w_en,   r_en;
        wire                     full,   empty;
        wire[DATA_WIDTH -1: 0]  r_data;
        reg [DATA_WIDTH - 1: 0]  w_data;
        
        integer i; 
        
        fifo_asyn   #(DATA_WIDTH,
                      ADDR_WIDTH)
        fifo_asyn_tb (.w_clk    (w_clk), 
                      .r_clk    (r_clk),
                      .w_rstn   (w_rstn),
                      .r_rstn   (r_rstn),
                      .w_en     (w_en),
                      .r_en     (r_en),
                      .full     (full), 
                      .empty    (empty),
                      .w_data   (w_data),
                      .r_data   (r_data)
                      );
        
        initial begin 
            w_clk   = 1'b0; 
            r_clk   = 1'b0; 
            w_rstn  = 1'b1; 
            r_rstn  = 1'b1; 
            w_en    = 1'b0; 
            r_en    = 1'b0;
        end
        // write 350MHz
        always begin 
            #1.429 w_clk = 1'b1; 
            #1.429 w_clk = 1'b0; 
        end
        //Read 300MHz
        always begin 
            #1.667 r_clk = 1'b1; 
            #1.667 r_clk = 1'b0; 
        end 
        
        initial begin 
            #7 r_rstn = 0; 
                w_rstn = 0; 
            
            #7 r_rstn = 1; 
                w_rstn = 1; 
            
            //#10 w_en = 1; 

            for (i = 0; i < 2**ADDR_WIDTH ; i = i + 1) begin  
                @(negedge w_clk) w_data = $random;
                w_en = 1;  
            end 
            #7 w_en = 0; 
            #7 r_en = 1; 
            #500 r_en = 0; 
            #7
            $finish; 
         end
        
endmodule
