`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/29/2022 12:31:05 AM
// Design Name: 
// Module Name: fifo_ram_syn
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


module fifo_ram_syn
    #(
        parameter DATA_WIDTH = 8, 
        parameter ADDR_WIDTH = 3
    )
    (
        input   clk, reset, 
        input   rd, wr, 
        input   [DATA_WIDTH - 1: 0] w_data, 
        output  empty, full, 
        output  [DATA_WIDTH - 1: 0] r_data
    ); 
 
    wire [ADDR_WIDTH - 1: 0] w_addr, r_addr_next;
    wire wr_en, full_temp;   
    
    assign wr_en = wr & ~full_temp; 
    assign full  = full_temp; 
    
    fifo_ctrl       #(.ADDR_WIDTH(ADDR_WIDTH)
                    )
    fifo_ctrl_unit  (.clk(clk),
                    .reset(reset), 
                    .rd(rd), 
                    .wr(wr), 
                    .empty(empty), 
                    .full(full_temp), 
                    .w_addr(w_addr), 
                    .r_addr(r_addr_next),
                    .r_addr_next()
                    ); 
                    
    dual_port_ram_simple        #(.DATA_WIDTH(DATA_WIDTH),
                                .ADDR_WIDTH(ADDR_WIDTH)
                                )
    dual_port_ram_simple_unit   (.clk(clk), 
                                .we(wr_en), 
                                .w_addr(w_addr), 
                                .r_addr(r_addr_next), 
                                .d(w_data), 
                                .q(r_data)
                                ); 
endmodule
