----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    10:46:05 06/04/2013 
-- Design Name: 
-- Module Name:    VGA_Sync_gen - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
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
use ieee.std_logic_arith.all;
  use ieee.std_logic_unsigned.all;
    use ieee.numeric_std.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity VGA_Sync_gen is
port(	clk_25MHz : in std_logic;
			pixel_col_out : out std_logic_vector(3 downto 0);
			pixel_line_out : out std_logic_vector(4 downto 0);
			VGA_VSYNC, VGA_HSYNC, VGA_OUT_enable : out std_logic;
			address_displayed_character_col : buffer integer range 0 to 80:=0;
			address_displayed_character_line : buffer integer range 0 to 2000:=0;
			Col_out : out std_logic_vector(6 downto 0);
			Line_out : out std_logic_vector(5 downto 0);
			interligne : in std_logic);

end VGA_Sync_gen;

architecture Behavioral of VGA_Sync_gen is
	signal pixel_col : integer range 0 to 15:= 0;
	signal pixel_line : integer range 0 to 20:= 0;
	signal row_counter : integer range 0 to 800:= 0;
	signal line_counter,line_counter_cmp : integer range 0 to 521:= 0;
	signal video_display_address_line : std_logic_vector (7 downto 0) := (others =>'0');
	signal VGA_HSYNC_tmp, VGA_VSYNC_tmp : std_logic;
	signal Line_r : integer range 0 to 25;
	
begin

	--Horloge ligne et colonne
	process(clk_25MHz)				
	begin
		if (clk_25MHz'event and clk_25MHz='1') then
				if line_counter >= 521 then			-- 441 pour 400 lignes
					line_counter <= 0;
					row_counter <= row_counter + 1;
				elsif row_counter < 799 then		-- 441 pour 400 lignes
					row_counter <= row_counter + 1;
					line_counter <= line_counter;
				else
					row_counter <= 0;
					line_counter <= line_counter + 1;
				end if;
		end if;
	end process;
	
	
	--Horloge ligne sortie pixel colonne charactère affiché
	process(clk_25MHz)
	begin
		if (clk_25MHz'event and clk_25MHz='1') then  
			if row_counter <= 143 then				--Compte l'affichage des pixels d'un caractère
				pixel_col <= 0;
				address_displayed_character_col <= 0;
			else
				if pixel_col < 15 then
					pixel_col <= pixel_col + 1;
				else
					pixel_col <= 0;
				end if;
				if pixel_col = 5 or pixel_col = 13 then		--Pour laisser le temps d'aller chercher le caractère dans la ROM_Chargen
					address_displayed_character_col <= address_displayed_character_col + 1;
				else
					address_displayed_character_col <= address_displayed_character_col;
				end if;
			end if;
		end if;
		pixel_col_out <= conv_std_logic_vector(pixel_col,4);
	end process;

	
	--Horloge ligne sortie pixel ligne
	process(clk_25MHz)
	begin
		if (clk_25MHz'event and clk_25MHz='1') then	
			line_counter_cmp <= line_counter;
			if (line_counter = line_counter_cmp) then 
				pixel_line <= pixel_line;
			elsif (interligne='0' and ((line_counter <= (35+40)) or (line_counter >= (515-40)))) or (interligne='1' and ((line_counter <= (35+40-24)) or (line_counter >= (515-40+24)))) then	-- 435 pour 480 lignes
				pixel_line <= 0;
				address_displayed_character_line <= 0;
				Line_r <= 0;
			elsif (interligne='0' and pixel_line < 15) or (interligne='1' and pixel_line < 17) then
				pixel_line <= pixel_line + 1;
				address_displayed_character_line <= address_displayed_character_line;
			else
				pixel_line <= 0;
				address_displayed_character_line <= address_displayed_character_line + 80;
				Line_r <= Line_r + 1;
			end if;
		end if;
		pixel_line_out <= conv_std_logic_vector(pixel_line,5);
	end process;
	

	--Génération des signal VGA_VSYNC, VGA_HSYNC et VGA_OUT_enable
	process(clk_25MHz)
	begin
		if (clk_25MHz'event and clk_25MHz='1') then
			if	(line_counter <2) then
				VGA_VSYNC_tmp <= '0';
			else
				VGA_VSYNC_tmp <= '1';
			end if;
			if (row_counter < 96) then
				VGA_HSYNC_tmp <= '0';
			else
				VGA_HSYNC_tmp <= '1';
			end if;
			if ((row_counter >= 142) and (row_counter < 784) and ((interligne='0' and (line_counter >= (35+40)) and (line_counter < (515-40))) or (interligne='1' and (line_counter >= (35+40-24)) and (line_counter < (515-40+24))))) then	-- 435 pour 480 lignes
				VGA_OUT_enable <= '1';
			else
				VGA_OUT_enable <= '0';
			end if;
		end if;
		VGA_HSYNC <= VGA_HSYNC_tmp;
		VGA_VSYNC <= VGA_VSYNC_tmp;	
	end process;
	Col_out <= std_logic_vector(to_unsigned(address_displayed_character_col, Col_out'length));
	Line_out <= std_logic_vector(to_unsigned(Line_r, Line_out'length));

end Behavioral;

