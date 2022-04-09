`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/05/2022 01:27:50 AM
// Design Name: 
// Module Name: fifo_controller
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


module fifo_controller
    #(
        parameter ADDR_WIDTH = 4, 
        parameter ADDR_AVAILABLE = 13
    )
    (   
        input clk, reset,
        input w_en, r_en, 
        output full, empty, 
        output [ADDR_WIDTH -1: 0] w_addr, 
        output [ADDR_WIDTH -1: 0] r_addr  
    );
    
    reg [ADDR_WIDTH -1: 0] w_ptr_reg;
    reg [ADDR_WIDTH -1: 0] r_ptr_reg;
    reg [ADDR_WIDTH -1: 0] w_ptr_next; 
    reg [ADDR_WIDTH -1: 0] r_ptr_next; 
    reg                    full_reg;  
    reg                    full_next; 
    reg                    empty_reg;  
    reg                    empty_next;
    reg [ADDR_WIDTH -1: 0] count_reg; 
    
    always @(posedge clk or posedge reset) begin 
        if(reset) begin 
           w_ptr_reg <= 0; 
           r_ptr_reg <= 0; 
           full_reg  <= 0; 
           empty_reg <= 1; 
           count_reg <= 0;          
        end else begin 
            w_ptr_reg <= w_ptr_next; 
            r_ptr_reg <= r_ptr_next; 
            full_reg  <= full_next; 
            empty_reg <= empty_next; 
            if(w_en & !full_reg) begin 
                count_reg <= count_reg + 1; 
            end else begin
                if(r_en & !empty_reg) count_reg <= count_reg - 1;   
            end 
        end
    end
    
    always @* begin 
        w_ptr_next = w_ptr_reg; 
        r_ptr_next = r_ptr_reg;
         
        full_next  = full_reg; 
        empty_next = empty_reg; 
        
        case ({w_en, r_en})
        //  2'b00: 
            2'b01:  if (~empty_reg) begin  //not empty
                        r_ptr_next = r_ptr_reg + 1; 
                        full_next  = 1'b0; 
                        if (count_reg == 1) begin 
                            empty_next = 1'b1;
                            w_ptr_next = 1'b0; 
                            r_ptr_next = 1'b0; 
                        end
                    end
            2'b10:  if(~full_reg) begin  //not full
                        w_ptr_next = w_ptr_reg + 1;
                        empty_next = 1'b0; 
                        if (count_reg == ADDR_AVAILABLE - 1) begin 
                            full_next = 1'b1;
                            w_ptr_next = 1'b0;       
                        end
                    end   
            2'b11:  begin
                        w_ptr_next = w_ptr_reg + 1; 
                        r_ptr_next = r_ptr_reg + 1; 
                    end
        endcase 
    end
    
    assign w_addr = w_ptr_reg; 
    assign r_addr = r_ptr_reg;  
    assign full = full_reg; 
    assign empty = empty_reg; 
    
endmodule
