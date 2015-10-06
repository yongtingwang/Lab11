`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:02:08 05/30/2012 
// Design Name: 
// Module Name:    lcd_display 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module lcd_display(
  clk, // system clock
  rst_n, // active low reset
  data_request,
  data_ack,
  lcd_rst, // LCD reset
  lcd_cs, // LCD frame selection
  lcd_rw, // LCD read/write control
  lcd_di, // LCD data/instruction
  lcd_d, // LCD data
  lcd_e // LCD enable
);

input clk; 
input rst_n; 
output lcd_rst; 
output [1:0] lcd_cs; 
output lcd_rw; 
output lcd_di; 
output [7:0] lcd_d;
output lcd_e; 

wire clk_50k; 
output data_ack; 
wire [7:0] data;
wire [6:0] addr; 

output data_request; 

wire clk_out;
freq_div(
	.clk_out(clk_out), // divided clock output
	.clk_ctl(), // divided clock output for scan freq
	.clk(clk), // global clock input
	.rst_n(rst_n) // active low reset
	); 
	
	
lcd_ctrl U_LCDctrl(
  .clk_cnt(clk_out),
  .clk(clk_50k), 
  .rst_n(rst_n), 
  .data_ack(data_ack),  
  .data(data), 
  .lcd_di(lcd_di), 
  .lcd_rw(lcd_rw), 
  .lcd_en(lcd_e), 
  .lcd_rst(lcd_rst), 
  .lcd_cs(lcd_cs), 
  .lcd_data(lcd_d), 
  .addr(addr), 
  .data_request(data_request) 
);

rom_ctrl U_romctrl(
  .clk(clk_50k), 
  .rst_n(rst_n), 
  .en(lcd_e),
  .data_request(data_request), 
  .address(addr), 
  .data_ack(data_ack), 
  .data(data) 
);

clock_divider #(
    .half_cycle(400),
    .counter_width(9)
  ) 

clk50k (
    .rst_n(rst_n),
    .clk(clk),
    .clk_div(clk_50k)
  );

endmodule
