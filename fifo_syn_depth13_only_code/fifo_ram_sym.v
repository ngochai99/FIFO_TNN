`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/05/2022 04:39:35 AM
// Design Name: 
// Module Name: fifo_ram_sym
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


module fifo_ram_sym
    #(
        parameter DATA_WIDTH = 8, 
        parameter ADDR_WIDTH = 4,
        parameter ADDR_AVALABLE = 13 
    )
    (
        input   clk, reset, 
        input   r_en, w_en, 
        input   [DATA_WIDTH - 1: 0] w_data, 
        output  empty, full, 
        output  [DATA_WIDTH - 1: 0] r_data
    ); 
 
    wire [ADDR_WIDTH - 1: 0] w_addr, r_addr;
    wire w_en_temp, full_temp;   
    
    assign w_en_temp = w_en & ~full_temp; 
    assign full  = full_temp; 
    
    fifo_controller  #(ADDR_WIDTH, 
                      ADDR_AVALABLE)
    fifo_ctrl_unit   (.clk(clk),
                      .reset(reset), 
                      .r_en(r_en), 
                      .w_en(w_en), 
                      .empty(empty), 
                      .full(full_temp), 
                      .w_addr(w_addr), 
                      .r_addr(r_addr)); 
    dual_port_ram   #(.DATA_WIDTH(DATA_WIDTH),
                      .ADDR_WIDTH(ADDR_WIDTH))
    dual_port_ram_simple_unit   
                      (.clk(clk), 
                       .we(w_en_temp), 
                       .w_addr(w_addr), 
                       .r_addr(r_addr), 
                       .w_data(w_data), 
                       .r_data(r_data)); 
endmodule
