library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;


entity Gen_Video_MV is
			port(	clk_50Mhz : in std_logic;
					VGA_VSYNC, VGA_HSYNC : out std_logic;
					VGA_VBLANK, VGA_HBLANK, DOTCLK : out std_logic;
					VGA_GREEN : out std_logic;
					Data_Char_in : in std_logic_vector(7 downto 0);
					Col_out : out std_logic_vector(6 downto 0);
					Line_out : out std_logic_vector(5 downto 0);
					graphic : in std_logic);	-- graphic = 0 pour jeu de caractères graphiques
					
end Gen_Video_MV;

architecture Behavioral of Gen_Video_MV is
					signal ce_int : std_logic;
					signal VGA_OUT_enable : std_logic;
					signal address_displayed_character, address_displayed_character_tmp : STD_LOGIC_VECTOR (10 downto 0);
					signal we_tmp : std_logic;
					signal pixel_col : std_logic_vector(3 downto 0);
					signal pixel_col_tmp : std_logic_vector(2 downto 0);
					signal pixel_line : std_logic_vector(4 downto 0);
					signal select_mode : std_logic;
					signal address_displayed_character_col : integer range 0 to 80:=0;
					signal address_displayed_character_line : integer range 0 to 2000:=0;
		
					--test
					signal displayed_character_tmp : std_logic_vector(7 downto 0);
				
	component VGA_Sync_gen port (clk, ce : in std_logic;
								pixel_col_out : out std_logic_vector(3 downto 0);
								pixel_line_out : out std_logic_vector(4 downto 0);
								VGA_VSYNC, VGA_HSYNC, VGA_OUT_enable : out std_logic;
								VGA_VBLANK, VGA_HBLANK, DOTCLK : out std_logic;
								address_displayed_character_col : buffer integer range 0 to 80:=0;
								address_displayed_character_line : buffer integer range 0 to 2000:=0;
								Col_out : out std_logic_vector(6 downto 0);
								Line_out : out std_logic_vector(5 downto 0);
								interligne : in std_logic);
								end component;
	
		component TV_Sync_gen port (CLK, ce : in std_logic;
								pixel_col_out : out std_logic_vector(3 downto 0);
								pixel_line_out : out std_logic_vector(4 downto 0);
								VSYNC, HSYNC, OUT_enable : out std_logic;
								VBLANK, HBLANK, DOTCLK : out std_logic;
								address_displayed_character_col : buffer integer range 0 to 80:=0;
								address_displayed_character_line : buffer integer range 0 to 2000:=0;
								Col_out : out std_logic_vector(6 downto 0);
								Line_out : out std_logic_vector(5 downto 0);
								interligne : in std_logic);
								end component;
								
	component Chargen port (clk, ce : in  STD_LOGIC;
								pixel_col : in  STD_LOGIC_VECTOR (2 downto 0);
								pixel_line : in  STD_LOGIC_VECTOR (4 downto 0);
								graphic : in  STD_LOGIC;
								displayed_character : in  STD_LOGIC_VECTOR (7 downto 0);
								VGA_OUT_enable : in STD_LOGIC;
								VGA_OUT : out  STD_LOGIC);
								end component;

begin
--	Clock 25MHz
	process(clk_50MHz)
	begin
		if clk_50MHz = '1' and clk_50MHz'event then
			ce_int <= not ce_int;
		end if;
	end process;

	Inst_VGA_Sync_gen : VGA_Sync_gen port map (
								clk => clk_50MHz,
								ce => ce_int,
								pixel_col_out => pixel_col,
								pixel_line_out => pixel_line,
								VGA_VSYNC => VGA_VSYNC,
								VGA_HSYNC => VGA_HSYNC,
								VGA_VBLANK => VGA_VBLANK,
								VGA_HBLANK => VGA_HBLANK,
								DOTCLK => DOTCLK,
								VGA_OUT_enable => VGA_OUT_enable,
								address_displayed_character_col => address_displayed_character_col,
								address_displayed_character_line => address_displayed_character_line,
								Col_out => Col_out,
								Line_out => Line_out,
								interligne => '1');

	Inst_Chargen : Chargen port map( 
								clk => clk_50MHz,
								ce => ce_int,
								pixel_col => pixel_col_tmp,
								pixel_line => pixel_line,
								graphic => graphic,
								displayed_character => Data_Char_in,
								VGA_OUT_enable => VGA_OUT_enable,
								VGA_OUT => VGA_GREEN);

	-- Select screen mode : 40 char display when select_mode = 0, else 80 char
	select_mode <= '1';
	pixel_col_tmp <= pixel_col(3 downto 1) when select_mode = '0'
							else pixel_col(2 downto 0);
	address_displayed_character_tmp <= '0' & address_displayed_character (10 downto 1) when select_mode = '0'
							else address_displayed_character (10 downto 0);
	
	address_displayed_character (10 downto 0) <= std_logic_vector(to_unsigned((address_displayed_character_col + address_displayed_character_line),11));


end Behavioral;
