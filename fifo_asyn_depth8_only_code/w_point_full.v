`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/30/2022 02:48:22 PM
// Design Name: 
// Module Name: w_point_full
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


module w_point_full
    #(
        parameter ADDR_WIDTH = 3
    )
    (
        input   w_clk, w_rstn, 
        input   w_en, 
        input   [ADDR_WIDTH   :0] wq2_rptr,
        output  [ADDR_WIDTH   :0] w_point,
        output  [ADDR_WIDTH -1:0] w_addr,
        output  w_full
    );
    
    reg  [ADDR_WIDTH: 0] w_binary_reg, w_gray_reg; 
    wire [ADDR_WIDTH: 0] w_binary_next, w_gray_next;
    wire w_full_next; 
    reg  w_full_reg; 
    
    always @(posedge w_clk or negedge w_rstn) begin 
        if(!w_rstn) begin 
            w_binary_reg <= 0; 
            w_gray_reg   <= 0; 
            w_full_reg   <= 0;
        end else begin 
            w_binary_reg <= w_binary_next; 
            w_gray_reg   <= w_gray_next; 
            w_full_reg   <= w_full_next;     
        end 
    end
     
    assign w_addr  = w_binary_reg[ADDR_WIDTH - 1: 0]; 
    assign w_point = w_gray_reg; 
    assign w_full  = w_full_reg;
    
    assign w_binary_next = w_binary_reg + (w_en & ~w_full_reg);
    assign w_gray_next   = (w_binary_next >> 1) ^ w_binary_next; 
    assign w_full_next   = (w_gray_next == {~wq2_rptr[ADDR_WIDTH: ADDR_WIDTH -1], wq2_rptr[ADDR_WIDTH-2: 0]});
endmodule
