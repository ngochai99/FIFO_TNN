`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/30/2022 01:07:33 PM
// Design Name: 
// Module Name: sync_w2r
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


module sync_w2r
    #(
        parameter ADDR_WIDTH = 3
    )
    (
        input   r_clk, r_rstn,
        input   [ADDR_WIDTH : 0] w_point, 
        output  [ADDR_WIDTH : 0] r_point 
    );
    
    reg [ADDR_WIDTH :0] q1_reg, q2_reg; 
    
    always @(posedge r_clk or negedge r_rstn) begin 
        if(!r_rstn) begin 
            q1_reg <= 0; 
            q2_reg <= 0; 
        end else begin 
            q1_reg <= w_point; 
            q2_reg <= q1_reg; 
        end
    end
    assign r_point = q2_reg; 
endmodule
