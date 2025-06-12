library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;


entity VGA_Sync_gen is
port(	clk, ce : in std_logic;
			pixel_col_out : out std_logic_vector(3 downto 0);
			pixel_line_out : out std_logic_vector(4 downto 0);
			VGA_VSYNC, VGA_HSYNC, VGA_OUT_enable : out std_logic;
			VGA_VBLANK, VGA_HBLANK, DOTCLK : out std_logic;
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
	
	-- VGA, clk 25MHz,
	constant lines_h : integer := 521;
	constant lines_v : integer := 798;
	constant lines_vblank : integer := 143;
	constant sync_h : integer := 96;
	constant sync_v : integer := 2;
	
	-- PAL, clk 21MHz
--	constant lines_h : integer := 312;
--	constant lines_v : integer := 340;
--	constant lines_vblank : integer := 143;
--	constant sync_h : integer := 96;
--	constant sync_v : integer := 2;

begin

	--Horloge ligne et colonne
	process(clk)				
	begin
		if (clk'event and clk = '1') then
			if ce = '1' then
				if line_counter >= lines_h then			-- 441 pour 400 lignes
					line_counter <= 0;
					row_counter <= row_counter + 1;
				elsif row_counter <= lines_v then		-- 441 pour 400 lignes
					row_counter <= row_counter + 1;
					line_counter <= line_counter;
				else
					row_counter <= 0;
					line_counter <= line_counter + 1;
				end if;
			end if;
		end if;
	end process;
	
	
	--Horloge ligne sortie pixel colonne charactère affiché
	process(clk)
	begin
		if (clk'event and clk = '1') then
			if ce = '1' then
				if row_counter <= lines_vblank then				--Compte l'affichage des pixels d'un caractère
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
		end if;
		pixel_col_out <= conv_std_logic_vector(pixel_col,4);
	end process;

	
	--Horloge ligne sortie pixel ligne
	process(clk)
	begin
		if (clk'event and clk = '1') then
			if ce = '1' then
				line_counter_cmp <= line_counter;
				if (line_counter = line_counter_cmp) then 
					pixel_line <= pixel_line;
				elsif (interligne='0' and ((line_counter <= (35+40)) or (line_counter >= ((lines_h-6)-40)))) or (interligne='1' and ((line_counter <= (35+40-24)) or (line_counter >= ((lines_h-6)-40+24)))) then	-- 435 pour 480 lignes
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
		end if;
		pixel_line_out <= conv_std_logic_vector(pixel_line,5);
	end process;
	

	--Génération des signal VGA_VSYNC, VGA_HSYNC et VGA_OUT_enable
	process(clk)
	begin
		if (clk'event and clk = '1') then
			if ce = '1' then
				if	(line_counter < sync_v) then
					VGA_VSYNC_tmp <= '0';
				else
					VGA_VSYNC_tmp <= '1';
				end if;
				if (row_counter < sync_h) then
					VGA_HSYNC_tmp <= '0';
				else
					VGA_HSYNC_tmp <= '1';
				end if;
				if ((row_counter >= (lines_vblank-1)) and (row_counter < (lines_v-15)) and ((interligne='0' and (line_counter >= (35+40)) and (line_counter < ((lines_h-6)-40))) or (interligne='1' and (line_counter >= (35+40-24)) and (line_counter < ((lines_h-6)-40+24))))) then	-- 435 pour 480 lignes
					VGA_OUT_enable <= '1';
				else
					VGA_OUT_enable <= '0';
				end if;
				if (row_counter >= (lines_vblank-1)) and (row_counter < (lines_v-15)) then
					VGA_HBLANK <= '0';
				else
					VGA_HBLANK <= '1';
				end if;
				if (line_counter >= (35+40-24)) and (line_counter < ((lines_h-6)-40+24)) then
					VGA_VBLANK <= '0';
				else
					VGA_VBLANK <= '1';
				end if;
			end if;
		end if;
		VGA_HSYNC <= VGA_HSYNC_tmp;
		VGA_VSYNC <= VGA_VSYNC_tmp;	
	end process;
	Col_out <= std_logic_vector(to_unsigned(address_displayed_character_col, Col_out'length));
	Line_out <= std_logic_vector(to_unsigned(Line_r, Line_out'length));

--DOTCLK <= ce when clk'event and clk = '1';
DOTCLK <= clk;

end Behavioral;
