`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/30/2022 01:50:35 PM
// Design Name: 
// Module Name: r_point_empty
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


module r_point_empty
    #(
        parameter ADDR_WIDTH =3
    )
    (
        input   r_clk, r_rstn, 
        input   r_en, 
        input   [ADDR_WIDTH   :0] rq2_wptr,
        output  [ADDR_WIDTH   :0] r_point,
        output  [ADDR_WIDTH -1:0] r_addr,
        output  r_empty
    );
    
    reg  [ADDR_WIDTH :0] r_binary_reg, r_gray_reg; 
    wire [ADDR_WIDTH :0] r_binary_next, r_gray_next;  
    wire  r_empty_next;
    reg   r_empty_reg;  
    
 //-------------------
 // GRAYSTYLE2 pointer
 //-------------------
    
    always @(posedge r_clk or negedge r_rstn) begin
        if(!r_rstn) begin 
            r_binary_reg <= 0; 
            r_gray_reg   <= 0;
            r_empty_reg  <= 1;
        end else begin 
            r_binary_reg <= r_binary_next; 
            r_gray_reg   <= r_gray_next;
            r_empty_reg  <= r_empty_next;  
        end            
    end 
    // Memory read-address pointer (okay to use binary to address memory)
    assign r_addr        = r_binary_reg[ADDR_WIDTH -1: 0]; 
    assign r_point       = r_gray_reg;
    assign r_empty       = r_empty_reg; 
    
    assign r_binary_next = r_binary_reg + (r_en & ~r_empty_reg);   
    assign r_gray_next   = (r_binary_next >> 1) ^ r_binary_next; 
    assign r_empty_next  = (r_gray_next == rq2_wptr); 
     
endmodule
