`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/29/2022 04:34:28 AM
// Design Name: 
// Module Name: sync_r2w
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


module sync_r2w
    #(
        parameter ADDR_WIDTH = 3
    )
    (
        input   w_clk, w_rstn, 
        input   [ADDR_WIDTH : 0] r_point, 
        output  [ADDR_WIDTH : 0] w_point
    );
    
    reg  [ADDR_WIDTH -1: 0] q1_reg, q2_reg; 
    
    always @(posedge w_clk or negedge w_rstn) begin 
        if(!w_rstn) begin
            q1_reg <= 1'b0; 
            q2_reg <= 1'b0; 
        end else begin
            q1_reg  <= r_point;
            q2_reg  <= q1_reg;  
        end
    end
    assign w_point = q2_reg; 
    
endmodule

