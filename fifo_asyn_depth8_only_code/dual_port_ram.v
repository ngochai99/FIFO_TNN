`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/29/2022 04:31:05 AM
// Design Name: 
// Module Name: dual_port_ram
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


//module dual_port_ram
//#(
//    parameter DATA_WIDTH = 8, 
//              ADDR_WIDTH = 3
//    )
//    (
//    input                       clk, 
//    input                       we, 
//    input   [ADDR_WIDTH - 1: 0] w_addr, r_addr,
//    input   [DATA_WIDTH - 1: 0] d, 
//    output  [DATA_WIDTH -1 :0]  q
//    );
    
//    //signal declaration 
//    reg     [DATA_WIDTH - 1: 0] ram [2**ADDR_WIDTH - 1: 0]; 
//    reg     [ADDR_WIDTH - 1: 0] addr_reg; 
    
//    //write operaion      
//     always @(posedge clk)
//     begin 
//        if(we)
//            ram[w_addr] <= d; 
//        addr_reg <= r_addr; 
//    end
     
//    //read operation
//    assign q = ram[addr_reg]; 
//endmodule

//////////////////////////////////////////////////////////////////////////////////

module dual_port_ram
#(
  parameter DATA_WIDTH = 8, // Memory data word width
  parameter ADDR_WIDTH = 3  // Number of mem address bits
)
(
  input   we, clk,
  input   [ADDR_WIDTH-1:0] w_addr, r_addr,
  input   [DATA_WIDTH-1:0] d,
  output  [DATA_WIDTH-1:0] q
);

  // RTL Verilog memory model

  reg [DATA_WIDTH-1:0] mem [0:2**ADDR_WIDTH-1];

  assign q = mem[r_addr];

  always @(posedge clk)
    if (we)
      mem[w_addr] <= d;

endmodule