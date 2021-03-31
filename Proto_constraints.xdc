#set_property IOSTANDARD LVCMOS33 [get_ports {led_1}]
#set_property PACKAGE_PIN J19 [get_ports {led_1}]
#set_property IOSTANDARD LVCMOS33 [get_ports clk_50MHz]
#set_property IOSTANDARD LVCMOS33 [get_ports Rst_sw]
#set_property PACKAGE_PIN U22 [get_ports clk_50MHz]
#set_property PACKAGE_PIN H19 [get_ports Rst_sw]

set_property BITSTREAM.CONFIG.SPI_BUSWIDTH 4 [current_design]

#Solve combinatorial loops problems
#set_property ALLOW_COMBINATORIAL_LOOPS true [get_nets -of_objects [Inst_Emb_CBM/Inst_CBM_4032/Inst_R6502/U_0/U_4/mw_U_5reg_cval[0]_i_11_n_0]]

set_property SEVERITY {Warning}  [get_drc_checks LUTLP-1]

set_property SEVERITY {Warning} [get_drc_checks NSTD-1]

# Clock signal 50 MHz
set_property -dict { PACKAGE_PIN U22   IOSTANDARD LVCMOS33 } [get_ports { clk_50MHz }];

# Buttons
#set_property -dict { PACKAGE_PIN H19   IOSTANDARD LVCMOS33 } [get_ports { Rst_sw }];

# LEDs
set_property -dict { PACKAGE_PIN J19   IOSTANDARD LVCMOS33 } [get_ports { led_1 }];


#--------------------------------------------------------------
# Test board

# VGA output 15 bits
set_property -dict { PACKAGE_PIN E2    IOSTANDARD LVCMOS33 } [get_ports { VGA_VSYNC }];
set_property -dict { PACKAGE_PIN F4    IOSTANDARD LVCMOS33 } [get_ports { VGA_HSYNC }];
set_property -dict { PACKAGE_PIN G1    IOSTANDARD LVCMOS33 } [get_ports { VGA_BLUE[4] }];
set_property -dict { PACKAGE_PIN H4    IOSTANDARD LVCMOS33 } [get_ports { VGA_BLUE[3] }];
set_property -dict { PACKAGE_PIN H1    IOSTANDARD LVCMOS33 } [get_ports { VGA_BLUE[2] }];
set_property -dict { PACKAGE_PIN G9    IOSTANDARD LVCMOS33 } [get_ports { VGA_BLUE[1] }];
set_property -dict { PACKAGE_PIN L2    IOSTANDARD LVCMOS33 } [get_ports { VGA_BLUE[0] }];
set_property -dict { PACKAGE_PIN N3    IOSTANDARD LVCMOS33 } [get_ports { VGA_GREEN[4] }];
set_property -dict { PACKAGE_PIN K5    IOSTANDARD LVCMOS33 } [get_ports { VGA_GREEN[3] }];
set_property -dict { PACKAGE_PIN L4    IOSTANDARD LVCMOS33 } [get_ports { VGA_GREEN[2] }];
set_property -dict { PACKAGE_PIN P3    IOSTANDARD LVCMOS33 } [get_ports { VGA_GREEN[1] }];
set_property -dict { PACKAGE_PIN J1    IOSTANDARD LVCMOS33 } [get_ports { VGA_GREEN[0] }];
set_property -dict { PACKAGE_PIN M5    IOSTANDARD LVCMOS33 } [get_ports { VGA_RED[4] }];
set_property -dict { PACKAGE_PIN T3    IOSTANDARD LVCMOS33 } [get_ports { VGA_RED[3] }];
set_property -dict { PACKAGE_PIN P5    IOSTANDARD LVCMOS33 } [get_ports { VGA_RED[2] }];
set_property -dict { PACKAGE_PIN M1    IOSTANDARD LVCMOS33 } [get_ports { VGA_RED[1] }];
set_property -dict { PACKAGE_PIN P1    IOSTANDARD LVCMOS33 } [get_ports { VGA_RED[0] }];

#PS2 Keyboard
set_property -dict { PACKAGE_PIN F22    IOSTANDARD LVCMOS33 } [get_ports { PS2_CLK }];
set_property -dict { PACKAGE_PIN E23    IOSTANDARD LVCMOS33 } [get_ports { PS2_DATA }];

# Controller ports
#set_property -dict { PACKAGE_PIN D5   IOSTANDARD LVCMOS33 } [get_ports { Ctrl_D1 }];
#set_property -dict { PACKAGE_PIN D1   IOSTANDARD LVCMOS33 } [get_ports { Ctrl_D2 }];
#set_property -dict { PACKAGE_PIN D4   IOSTANDARD LVCMOS33 } [get_ports { Ctrl_Clk1 }];
#set_property -dict { PACKAGE_PIN B1   IOSTANDARD LVCMOS33 } [get_ports { Ctrl_Clk2 }];
#set_property -dict { PACKAGE_PIN U1  IOSTANDARD LVCMOS33 } [get_ports { Ctrl_Rst }];

# I²S audio output
#set_property -dict { PACKAGE_PIN AC24 IOSTANDARD LVCMOS33 } [get_ports { BCK }];
#set_property -dict { PACKAGE_PIN Y21   IOSTANDARD LVCMOS33 } [get_ports { LRCK }];
#set_property -dict { PACKAGE_PIN AA25 IOSTANDARD LVCMOS33 } [get_ports { SDAT }];

# SPI Flash
#set_property -dict { PACKAGE_PIN W25  IOSTANDARD LVCMOS33 } [get_ports { spi_clk }];
#set_property -dict { PACKAGE_PIN Y25  IOSTANDARD LVCMOS33 } [get_ports { spi_cs }];
#set_property -dict { PACKAGE_PIN AB24  IOSTANDARD LVCMOS33 } [get_ports { spi_din }];
#set_property -dict { PACKAGE_PIN W21  IOSTANDARD LVCMOS33 } [get_ports { spi_dout }];

# SDRAM K4S280832D
set_property INTERNAL_VREF 0.9 [get_iobanks 13]
#	Address
#set_property -dict { PACKAGE_PIN P26 IOSTANDARD LVCMOS33 } [get_ports { dram_addr[11] }];
#set_property -dict { PACKAGE_PIN M2  IOSTANDARD LVCMOS33 } [get_ports { dram_addr[10] }];
#set_property -dict { PACKAGE_PIN M25 IOSTANDARD LVCMOS33 } [get_ports { dram_addr[9] }];
#set_property -dict { PACKAGE_PIN N22 IOSTANDARD LVCMOS33 } [get_ports { dram_addr[8] }];
#set_property -dict { PACKAGE_PIN P24 IOSTANDARD LVCMOS33 } [get_ports { dram_addr[7] }];
#set_property -dict { PACKAGE_PIN P25 IOSTANDARD LVCMOS33 } [get_ports { dram_addr[6] }];
#set_property -dict { PACKAGE_PIN T25 IOSTANDARD LVCMOS33 } [get_ports { dram_addr[5] }];
#set_property -dict { PACKAGE_PIN V21 IOSTANDARD LVCMOS33 } [get_ports { dram_addr[4] }];
#set_property -dict { PACKAGE_PIN R3  IOSTANDARD LVCMOS33 } [get_ports { dram_addr[3] }];
#set_property -dict { PACKAGE_PIN M4  IOSTANDARD LVCMOS33 } [get_ports { dram_addr[2] }];
#set_property -dict { PACKAGE_PIN L5  IOSTANDARD LVCMOS33 } [get_ports { dram_addr[1] }];
#set_property -dict { PACKAGE_PIN N2  IOSTANDARD LVCMOS33 } [get_ports { dram_addr[0] }];
## Data
#set_property -dict { PACKAGE_PIN J26 IOSTANDARD LVCMOS33 } [get_ports { dram_dq[7] }];
#set_property -dict { PACKAGE_PIN G21 IOSTANDARD LVCMOS33 } [get_ports { dram_dq[6] }];
#set_property -dict { PACKAGE_PIN H22 IOSTANDARD LVCMOS33 } [get_ports { dram_dq[5] }];
#set_property -dict { PACKAGE_PIN J21 IOSTANDARD LVCMOS33 } [get_ports { dram_dq[4] }];
#set_property -dict { PACKAGE_PIN E1  IOSTANDARD LVCMOS33 } [get_ports { dram_dq[3] }];
#set_property -dict { PACKAGE_PIN C1  IOSTANDARD LVCMOS33 } [get_ports { dram_dq[2] }];
#set_property -dict { PACKAGE_PIN E5  IOSTANDARD LVCMOS33 } [get_ports { dram_dq[1] }];
#set_property -dict { PACKAGE_PIN C4  IOSTANDARD LVCMOS33 } [get_ports { dram_dq[0] }];
## Control pins
#set_property -dict { PACKAGE_PIN H2  IOSTANDARD LVCMOS33 } [get_ports { dram_ba[0] }];
#set_property -dict { PACKAGE_PIN H9  IOSTANDARD LVCMOS33 } [get_ports { dram_ba[1] }];
#set_property -dict { PACKAGE_PIN F2  IOSTANDARD LVCMOS33 } [get_ports { dram_we }];
#set_property -dict { PACKAGE_PIN G4  IOSTANDARD LVCMOS33 } [get_ports { dram_cas }];
#set_property -dict { PACKAGE_PIN G2  IOSTANDARD LVCMOS33 } [get_ports { dram_ras }];
#set_property -dict { PACKAGE_PIN M26 IOSTANDARD LVCMOS33 } [get_ports { dram_clk }];
#set_property -dict { PACKAGE_PIN L23 IOSTANDARD LVCMOS33 } [get_ports { dram_cke }];
#set_property -dict { PACKAGE_PIN J4  IOSTANDARD LVCMOS33 } [get_ports { dram_cs }];
#set_property -dict { PACKAGE_PIN K23 IOSTANDARD LVCMOS33 } [get_ports { dram_dqm }];

# External test connector
#set_property -dict { PACKAGE_PIN K1  IOSTANDARD LVCMOS33 } [get_ports { Extb[7] }];
#set_property -dict { PACKAGE_PIN M6  IOSTANDARD LVCMOS33 } [get_ports { Extb[6] }];
#set_property -dict { PACKAGE_PIN T4  IOSTANDARD LVCMOS33 } [get_ports { Extb[5] }];
#set_property -dict { PACKAGE_PIN P6  IOSTANDARD LVCMOS33 } [get_ports { Extb[4] }];
#set_property -dict { PACKAGE_PIN N1  IOSTANDARD LVCMOS33 } [get_ports { Extb[3] }];
#set_property -dict { PACKAGE_PIN R1  IOSTANDARD LVCMOS33 } [get_ports { Extb[2] }];
#set_property -dict { PACKAGE_PIN T2  IOSTANDARD LVCMOS33 } [get_ports { Extb[1] }];
#set_property -dict { PACKAGE_PIN U2  IOSTANDARD LVCMOS33 } [get_ports { Extb[0] }];

# LCD 2*16 SPI
#set_property -dict { PACKAGE_PIN A2  IOSTANDARD LVCMOS33 } [get_ports { lcd2_clk }];
#set_property -dict { PACKAGE_PIN A4  IOSTANDARD LVCMOS33 } [get_ports { lcd2_rst }];
#set_property -dict { PACKAGE_PIN A5  IOSTANDARD LVCMOS33 } [get_ports { lcd2_data }];