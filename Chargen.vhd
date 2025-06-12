library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity Chargen is
    Port ( clk, ce : in  STD_LOGIC;	-- 25MHz
           pixel_col : in  STD_LOGIC_VECTOR (2 downto 0);
           pixel_line : in  STD_LOGIC_VECTOR (4 downto 0);
           graphic : in  STD_LOGIC;
           displayed_character : in  STD_LOGIC_VECTOR (7 downto 0);
			  VGA_OUT_enable : in STD_LOGIC;
           VGA_OUT : out  STD_LOGIC);
end Chargen;

architecture Behavioral of Chargen is

	signal displayed_8_pixels : std_logic_vector(7 downto 0);
	signal addr_rom_chargen : std_logic_vector(10 downto 0);
	signal add_line_on_character : std_logic_vector(2 downto 0);
	signal reverse : std_logic;
								
	COMPONENT ROM_Char
	  PORT (
		 clka : IN STD_LOGIC;
		 ena : IN STD_LOGIC;
		 addra : IN STD_LOGIC_VECTOR(10 DOWNTO 0);
		 douta : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
	  );
	END COMPONENT;								
								
begin

Inst_Rom_Chargen : Rom_Char port map (
    clka => clk,
    ena => ce,
    addra(10) => graphic,
	 addra(9 downto 3) => displayed_character(6 downto 0),
	 addra(2 downto 0) => pixel_line (3 downto 1),
    douta => displayed_8_pixels
  );


process(clk)		--Process pour synchro du signal VGA
begin
	if (clk'event and clk = '1') then
		if ce = '1' then
			reverse <= displayed_character(7);	--Place dans reverse pour tre synchrone avec la lecture de ROM Chargen
			if VGA_OUT_enable = '0' or pixel_line(4)= '1' then
				VGA_OUT <= '0';
			else
				VGA_OUT <= displayed_8_pixels(to_integer(unsigned(not pixel_col(2 downto 0)))) xor reverse;
			end if;
		end if;
	end if;
end process;

end Behavioral;
