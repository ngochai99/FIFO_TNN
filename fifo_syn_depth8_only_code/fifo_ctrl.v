`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/29/2022 02:16:26 AM
// Design Name: 
// Module Name: fifo_ctrl
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


module fifo_ctrl
    #(
        parameter ADDR_WIDTH = 3
    )
    (
        input   clk, reset, 
        input   rd, wr, 
        output  empty, full,
        output  [ADDR_WIDTH - 1: 0] w_addr, 
        output  [ADDR_WIDTH - 1: 0] r_addr, r_addr_next
    );
    
    reg [ADDR_WIDTH - 1: 0] w_ptr_reg, w_ptr_next, w_ptr_succ; 
    reg [ADDR_WIDTH - 1: 0] r_ptr_reg, r_ptr_next, r_ptr_succ; 
    reg                     empty_reg, full_reg, full_next, empty_next;  
    
    //fifo control logic
    //register for status and read and write pointer
    always @(posedge clk, posedge reset) begin 
        if (reset) begin 
            w_ptr_reg <= 8'd0; 
            r_ptr_reg <= 8'd0;
            full_reg  <= 8'd0; 
            empty_reg <= 8'd1;  
        end else begin 
            w_ptr_reg <= w_ptr_next; 
            r_ptr_reg <= r_addr_next; 
            full_reg  <= full_next;
            empty_reg <= empty_next;  
        end
    end
    
    //next sate logic for read and write pointer
    always @* begin
        //succesive pointer values 
        w_ptr_succ = w_ptr_reg + 1; 
        r_ptr_succ = r_ptr_reg + 1; 
        // default: keep old values 
        w_ptr_next = w_ptr_reg; 
        r_ptr_next = r_ptr_reg; 
        full_next  = full_reg; 
        empty_next = empty_reg;
        case ({wr, rd})
            //2'b00: no operation 
            2'b01: //read 
                if(~empty_reg) begin //not empty 
                    r_ptr_next = r_ptr_succ;
                    full_next  = 1'b0;
                    if(r_ptr_succ == w_ptr_reg)
                        empty_next = 1'b1;
                end    
            2'b10: //write 
                if(~full_reg) begin //not full
                    w_ptr_next = w_ptr_succ; 
                    empty_next = 1'b0; 
                    if(w_ptr_succ == r_ptr_reg)
                        full_next = 1'b1; 
                end
            2'b11: //both read and write
                begin 
                    w_ptr_next = w_ptr_succ; 
                    r_ptr_next = r_ptr_succ; 
                end 
        endcase 
    end
    //output
    assign w_addr = w_ptr_reg; 
    assign r_addr = r_ptr_reg; 
    assign r_addr_next = r_ptr_next; 
    assign full = full_reg; 
    assign empty = empty_reg; 
endmodule
