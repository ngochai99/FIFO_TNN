`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/30/2022 04:11:26 PM
// Design Name: 
// Module Name: fifo_without_mem
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


module fifo_without_mem
    #(
        parameter ADDR_WIDTH = 3
    )
    (
        input  w_clk, r_clk, 
        input  w_rstn, r_rstn, 
        input  w_en, r_en,
    
        output                     w_full, r_empty,
        output [ADDR_WIDTH - 1: 0] w_addr, r_addr 
    );
    
    wire [ADDR_WIDTH    : 0] w_point, r_point;
    wire [ADDR_WIDTH    : 0] wq2_rptr, rq2_wptr; 
    
    sync_r2w #(ADDR_WIDTH) 
    sync_r2w_instance      (.w_clk(w_clk), 
                            .w_rstn(w_rstn), 
                            .r_point(r_point), 
                            .w_point(wq2_rptr));
                       
    sync_w2r #(ADDR_WIDTH) 
    sync_w2r_instance      (.r_clk(r_clk), 
                            .r_rstn(r_rstn), 
                            .r_point(rq2_wptr), 
                            .w_point(w_point));
                       
    r_point_empty #(ADDR_WIDTH)
    r_point_empty_instance (.r_clk(r_clk), 
                            .r_rstn(r_rstn), 
                            .r_en(r_en), 
                            .rq2_wptr(rq2_wptr),
                            .r_point(r_point),
                            .r_addr(r_addr),
                            .r_empty(r_empty));
    
    w_point_full #(ADDR_WIDTH)
    w_point_full_instance  (.w_clk(w_clk),
                            .w_rstn(w_rstn),
                            .w_en(w_en),
                            .wq2_rptr(wq2_rptr),
                            .w_point(w_point),
                            .w_addr(w_addr),
                            .w_full(w_full));
endmodule
