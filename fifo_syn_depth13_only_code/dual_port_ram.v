`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/05/2022 01:22:36 AM
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


module dual_port_ram
#(
  parameter DATA_WIDTH = 8, // Memory data word width
  parameter ADDR_WIDTH = 4  // Number of mem address bits
)
(
  input   we, clk,
  input   [ADDR_WIDTH-1:0] w_addr, r_addr,
  input   [DATA_WIDTH-1:0] w_data,
  output  [DATA_WIDTH-1:0] r_data
);

  // RTL Verilog memory model

  reg [DATA_WIDTH-1:0] mem [0:2**ADDR_WIDTH-1];

  assign r_data = mem[r_addr];

  always @(posedge clk)
    if (we)
      mem[w_addr] <= w_data;

endmodule
