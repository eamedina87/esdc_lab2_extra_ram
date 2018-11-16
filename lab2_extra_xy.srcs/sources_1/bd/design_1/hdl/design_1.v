//Copyright 1986-2014 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2014.3.1 (win64) Build 1056140 Thu Oct 30 17:03:40 MDT 2014
//Date        : Fri Nov 16 15:04:41 2018
//Host        : c4d9 running 64-bit Service Pack 1  (build 7601)
//Command     : generate_target design_1.bd
//Design      : design_1
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CORE_GENERATION_INFO = "design_1,IP_Integrator,{x_ipVendor=xilinx.com,x_ipLanguage=VERILOG,numBlks=5,numReposBlks=5,numNonXlnxBlks=0,numHierBlks=0,maxHierDepth=0,da_board_cnt=2}" *) 
module design_1
   (btn,
    led,
    sw,
    sys_clock,
    vga_b,
    vga_g,
    vga_hs,
    vga_r,
    vga_vs);
  input [3:0]btn;
  output [3:0]led;
  input [3:0]sw;
  input sys_clock;
  output [4:0]vga_b;
  output [5:0]vga_g;
  output vga_hs;
  output [4:0]vga_r;
  output vga_vs;

  wire GND_1;
  wire [9:0]VGA_SYNC_0_pixel_column;
  wire [9:0]VGA_SYNC_0_pixel_row;
  wire [4:0]VGA_SYNC_0_vga_b;
  wire [5:0]VGA_SYNC_0_vga_g;
  wire VGA_SYNC_0_vga_hs;
  wire [4:0]VGA_SYNC_0_vga_r;
  wire VGA_SYNC_0_vga_vs;
  wire [16:0]add_generator_0_adr_memo;
  wire [2:0]blk_mem_gen_0_doutb;
  wire [3:0]btn_1;
  wire f_div5_0_clkout;
  wire [16:0]session4_0_adr_memo;
  wire [2:0]session4_0_data;
  wire [3:0]session4_0_led;
  wire session4_0_wr_memo;
  wire [3:0]sw_1;
  wire sys_clock_1;

  assign btn_1 = btn[3:0];
  assign led[3:0] = session4_0_led;
  assign sw_1 = sw[3:0];
  assign sys_clock_1 = sys_clock;
  assign vga_b[4:0] = VGA_SYNC_0_vga_b;
  assign vga_g[5:0] = VGA_SYNC_0_vga_g;
  assign vga_hs = VGA_SYNC_0_vga_hs;
  assign vga_r[4:0] = VGA_SYNC_0_vga_r;
  assign vga_vs = VGA_SYNC_0_vga_vs;
GND GND
       (.G(GND_1));
design_1_VGA_SYNC_0_0 VGA_SYNC_0
       (.clock_25Mhz(f_div5_0_clkout),
        .color_in(blk_mem_gen_0_doutb),
        .pixel_column(VGA_SYNC_0_pixel_column),
        .pixel_row(VGA_SYNC_0_pixel_row),
        .vga_b(VGA_SYNC_0_vga_b),
        .vga_g(VGA_SYNC_0_vga_g),
        .vga_hs(VGA_SYNC_0_vga_hs),
        .vga_r(VGA_SYNC_0_vga_r),
        .vga_vs(VGA_SYNC_0_vga_vs));
design_1_add_generator_0_0 add_generator_0
       (.adr_memo(add_generator_0_adr_memo),
        .pixel_column(VGA_SYNC_0_pixel_column),
        .pixel_row(VGA_SYNC_0_pixel_row));
design_1_blk_mem_gen_0_0 blk_mem_gen_0
       (.addra(session4_0_adr_memo),
        .addrb(add_generator_0_adr_memo),
        .clka(f_div5_0_clkout),
        .clkb(f_div5_0_clkout),
        .dina(session4_0_data),
        .doutb(blk_mem_gen_0_doutb),
        .wea(session4_0_wr_memo));
design_1_clk_wiz_0_0 clk_wiz_0
       (.clk_in1(sys_clock_1),
        .clk_out1(f_div5_0_clkout),
        .reset(GND_1));
design_1_session4_0_0 session4_0
       (.adr_memo(session4_0_adr_memo),
        .btn(btn_1),
        .clk_25(f_div5_0_clkout),
        .data(session4_0_data),
        .led(session4_0_led),
        .sw(sw_1),
        .vga_vs(VGA_SYNC_0_vga_vs),
        .wr_memo(session4_0_wr_memo));
endmodule
