`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/02/2022 05:52:54 PM
// Design Name: 
// Module Name: fifo_asyn
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


module fifo_asyn
   #(
        parameter DATA_WIDTH = 3,
        parameter ADDR_WIDTH = 8
    )
    (
        input  w_clk,   r_clk, 
        input  w_rstn,  r_rstn, 
        input  w_en,    r_en,
        output full,    empty,
        output [DATA_WIDTH - 1: 0] r_data, 
        input  [DATA_WIDTH - 1: 0] w_data
    );
    
    wire [ADDR_WIDTH    : 0] w_point,   r_point;
    wire [ADDR_WIDTH    : 0] wq2_rptr,  rq2_wptr; 
    wire [ADDR_WIDTH - 1: 0] w_addr,    r_addr; 
    wire                     full_temp, we_temp;
    
    assign full    = full_temp; 
    assign we_temp = w_en & ~full_temp; 
    
    sync_r2w                 #(ADDR_WIDTH) 
    sync_r2w_instance        (.w_clk    (w_clk), 
                              .w_rstn   (w_rstn), 
                              .r_point  (r_point), 
                              .w_point  (wq2_rptr));
                       
    sync_w2r                #(ADDR_WIDTH) 
    sync_w2r_instance        (.r_clk    (r_clk), 
                              .r_rstn   (r_rstn), 
                              .r_point  (rq2_wptr), 
                              .w_point  (w_point));
                       
    r_point_empty           #(ADDR_WIDTH)
    r_point_empty_instance   (.r_clk    (r_clk), 
                              .r_rstn   (r_rstn), 
                              .r_en     (r_en), 
                              .rq2_wptr (rq2_wptr),
                              .r_point  (r_point),
                              .r_addr   (r_addr),
                              .r_empty  (empty));
    
    w_point_full            #(ADDR_WIDTH)
    w_point_full_instance    (.w_clk    (w_clk),
                              .w_rstn   (w_rstn),
                              .w_en     (w_en),
                              .wq2_rptr (wq2_rptr),
                              .w_point  (w_point),
                              .w_addr   (w_addr),
                              .w_full   (full_temp));
     
    dual_port_ram           #(DATA_WIDTH,
                              ADDR_WIDTH)
    dual_port_ram_instance   (.clk      (w_clk), 
                              .we       (we_temp),
                              .w_addr   (w_addr), 
                              .r_addr   (r_addr), 
                              .d        (w_data), 
                              .q        (r_data)); 
endmodule
