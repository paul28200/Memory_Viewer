----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Paul Prudhomme
-- 
-- Create Date: 03/20/2021 12:19:48 PM
-- Design Name: 
-- Module Name: Memory_Viewer - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Memory_Viewer_Top is
  Port (clk_50MHz : in std_logic;
  
			--VGA output
			VGA_VSYNC, VGA_HSYNC : out std_logic;
			VGA_RED, VGA_GREEN, VGA_BLUE : out std_logic_vector(4 downto 0);
			
			--PS2 Keyboard
			PS2_CLK : in std_logic;
			PS2_DATA : in std_logic);
end Memory_Viewer_Top;

architecture Behavioral of Memory_Viewer_Top is

	COMPONENT Test_RAM_64k
	  PORT (
		clka : IN STD_LOGIC;
		wea : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
		addra : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		dina : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		douta : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
	  );
	END COMPONENT;

	COMPONENT  Memory_Viewer
	  PORT (
	  		clk_50MHz : in std_logic;
			VGA_VSYNC, VGA_HSYNC : out std_logic;
			VGA_RED, VGA_GREEN, VGA_BLUE : out std_logic_vector(4 downto 0);
			Addr : out std_logic_vector(23 downto 0);
			Din : in std_logic_vector(7 downto 0);
			PS2_CLK : in std_logic;
			PS2_DATA : in std_logic
	  );
	END COMPONENT;

	signal Addr : std_logic_vector(23 downto 0);
	signal Din : std_logic_vector(7 downto 0);

begin

	Inst_MV : Memory_Viewer port map (
	  		clk_50MHz => clk_50MHz,
			VGA_VSYNC => VGA_VSYNC,
			VGA_HSYNC => VGA_HSYNC,
			VGA_RED => VGA_RED,
			VGA_GREEN => VGA_GREEN,
			VGA_BLUE => VGA_BLUE,
			Addr => Addr,
			Din => Din,
			PS2_CLK => PS2_CLK,
			PS2_DATA => PS2_DATA);

	Test_RAM : Test_RAM_64k
	  PORT MAP (
		clka => clk_50MHz,
		wea(0) => '0',
		addra => Addr(15 downto 0),
		dina => x"00",
		douta => Din
	  );

end Behavioral;
