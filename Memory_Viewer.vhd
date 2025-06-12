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

entity Memory_Viewer is
  Port (clk_50MHz : in std_logic;
  
			--VGA output
			VGA_VSYNC, VGA_HSYNC : out std_logic;
			VGA_RED, VGA_GREEN, VGA_BLUE : out std_logic_vector(4 downto 0);
			VGA_VBLANK, VGA_HBLANK, DOTCLK : out std_logic;
			
			--Read Memory
			Addr : out std_logic_vector(23 downto 0);
			Din : in std_logic_vector(7 downto 0);
			
			--PS2 Keyboard
			PS2_CLK : in std_logic;
			PS2_DATA : in std_logic);
end Memory_Viewer;

architecture Behavioral of Memory_Viewer is

	component Gen_Video_MV port(
					clk_50Mhz : in std_logic;
					VGA_VSYNC, VGA_HSYNC : out std_logic;
					VGA_VBLANK, VGA_HBLANK, DOTCLK : out std_logic;
					VGA_GREEN : out std_logic;
					Data_Char_in : in std_logic_vector(7 downto 0);
					Col_out : out std_logic_vector(6 downto 0);
					Line_out : out std_logic_vector(5 downto 0);
					graphic : in std_logic);
								end component;

	COMPONENT keyboard
	  PORT (
			CLK			:	in	std_logic;
			nRESET		:	in	std_logic;
		
			-- PS/2 interface
			PS2_CLK		:	in	std_logic;
			PS2_DATA	:	in	std_logic;
			
			-- CPU address bus (row)
			A			:	in	std_logic_vector(3 downto 0);
			-- Column outputs to ULA
			KEYB		:	out	std_logic_vector(7 downto 0)
	  );
	END COMPONENT;

	signal Video : std_logic;
	signal Video_5 : std_logic_vector(4 downto 0);
	signal Data_Char_in : std_logic_vector(7 downto 0);
	signal Col_out : std_logic_vector(6 downto 0);
	signal Line_out : std_logic_vector(5 downto 0);
	
	signal sel_nibble, clear, reverse : std_logic;
	signal Disp_byte : std_logic_vector(7 downto 0);
	
	signal Disp_addr : std_logic_vector(23 downto 0) := x"000000";
	signal Cur_Col : integer range 0 to 31 := 0;
	signal Cur_Line : integer range 0 to 25 := 0;
	
	signal kbd_a : std_logic_vector(3 downto 0);
	signal kbd_k : std_logic_vector(7 downto 0);
	
	signal rst_n, V_Sync_t, Cursor_on : std_logic;

	type buffer_400 is array(0 to 399) of std_logic_vector(7 downto 0);
	signal RAM_buffer : buffer_400;

	type disp_format_type is array(0 to 59) of std_logic_vector(8 downto 0);	-- (data_byte(3 downto 0), add(1 downto 0), data_on, add_on, nibble)
	constant disp_format :  disp_format_type := (
			"000000000",
			"000000000",
			"000010010",
			"000010011",
			"000001010",
			"000001011",			
			"000000010",
			"000000011",
			"000000000",
			"000000000",
			"000000100",
			"000000101",
			"000000000",
			"000100100",
			"000100101",
			"000000000",
			"001000100",
			"001000101",
			"000000000",
			"001100100",
			"001100101",
			"000000000",
			"010000100",
			"010000101",
			"000000000",
			"010100100",
			"010100101",
			"000000000",
			"011000100",
			"011000101",
			"000000000",
			"011100100",
			"011100101",
			"000000000",
			"100000100",
			"100000101",
			"000000000",
			"100100100",
			"100100101",
			"000000000",
			"101000100",
			"101000101",
			"000000000",
			"101100100",
			"101100101",
			"000000000",
			"110000100",
			"110000101",
			"000000000",
			"110100100",
			"110100101",
			"000000000",
			"111000100",
			"111000101",
			"000000000",
			"111100100",
			"111100101",
			"000000000",
			"000000000",
			"000000000");


begin

Disp_addr(3 downto 0) <= "0000";

	Gen_Video : Gen_Video_MV port map(
					clk_50Mhz => clk_50Mhz,
					VGA_VSYNC => V_Sync_t,
					VGA_HSYNC => VGA_HSYNC,
					VGA_VBLANK => VGA_VBLANK,
					VGA_HBLANK => VGA_HBLANK,
					DOTCLK => DOTCLK,
					VGA_GREEN => Video,
					Data_Char_in => Data_Char_in,
					Col_out => Col_out,
					Line_out => Line_out,
					graphic => '1');
	VGA_VSYNC <= V_Sync_t;
	Video_5 <= Video & Video & Video & Video & Video;
	VGA_RED <= Video_5(4 downto 1) & '0';
	VGA_GREEN <= Video_5(4 downto 3) & "000";
	VGA_BLUE <= Video_5 and "00000";


--Data_Char_in <= "00" & Col_out(6 downto 1);

--Disp_byte <= x"5A";
--sel_nibble <= Col_out(1);

-- Byte to char conversion
process(sel_nibble, Disp_byte, clear, reverse)
	variable nibble : std_logic_vector(3 downto 0); 
begin
	if clear = '1' then 
		Data_Char_in <= x"20";	-- Default : space
	else
		if sel_nibble = '0' then
			nibble := Disp_byte(3 downto 0);
		else
			nibble := Disp_byte(7 downto 4);
		end if;
		if unsigned(nibble) < 10 then
			Data_Char_in <= std_logic_vector(to_unsigned(to_integer(unsigned(nibble)) + 48, Data_Char_in'length));
		else
			Data_Char_in <= std_logic_vector(to_unsigned(to_integer(unsigned(nibble)) + 55, Data_Char_in'length));
		end if;
	end if;
	Data_Char_in(7) <= reverse;
end process;

-- Screen char generation
process(Col_out, Line_out)
	variable line_addr : std_logic_vector(23 downto 0);
	variable buffer_addr : integer range 0 to 399;
begin
	clear <= '1';
	reverse <= '0';
	Disp_byte <= x"00";
	buffer_addr := to_integer(unsigned(Line_out) - 1)  * 16;
	line_addr := std_logic_vector(to_unsigned(to_integer(unsigned(Disp_addr)) + buffer_addr, line_addr'length));
	if unsigned(Col_out) < 60 then
		sel_nibble <= not disp_format(to_integer(unsigned(Col_out)))(0);
		-- Titles
		if unsigned(Line_out) = 0 then
			if disp_format(to_integer(unsigned(Col_out)))(2) = '1' then
				Disp_byte <= x"0" & disp_format(to_integer(unsigned(Col_out)))(8 downto 5);
				clear <= '0';
			end if;
		else
			if disp_format(to_integer(unsigned(Col_out)))(1) = '1' then
				case disp_format(to_integer(unsigned(Col_out)))(4 downto 3) is
					when "10" => Disp_byte <= line_addr(23 downto 16);
					when "01" => Disp_byte <= line_addr(15 downto 8);
					when "00" => Disp_byte <= line_addr(7 downto 0);
					when others =>
				end case;
				clear <= '0';
			elsif disp_format(to_integer(unsigned(Col_out)))(2) = '1' then
				Disp_byte <= RAM_buffer(buffer_addr + to_integer(unsigned(disp_format(to_integer(unsigned(Col_out)))(8 downto 5))));
				clear <= '0';
				if Cursor_on = '1' then
					if Cur_line + 1 = to_integer(unsigned(Line_out)) then
						if Cur_Col = to_integer(unsigned(disp_format(to_integer(unsigned(Col_out)))(8 downto 5) & disp_format(to_integer(unsigned(Col_out)))(0))) then
						reverse <= '1';
						end if;
					end if;
				end if;
			end if;
		end if;
	end if;
end process;

	PS2_KBD : keyboard port map (
			CLK => clk_50MHz,
			nRESET => rst_n,
			PS2_CLK => PS2_CLK,
			PS2_DATA => PS2_DATA,
			A => kbd_a,
			KEYB => kbd_k
	  );

-- Reset and Cursor
process(V_Sync_t)
	variable cnt : integer range 0 to 15 := 0;
	variable cnt2 : integer range 0 to 31;
	variable V_Sync_r : std_logic;
begin
if clk_50MHz'event and clk_50MHz = '1' then
	if V_Sync_r = '0' and V_Sync_t = '1' then
		if cnt < 15 then
			cnt := cnt + 1;
			rst_n <= '0';
		else
			rst_n <= '1';
		end if;
		cnt2 := (cnt2 + 1) mod 32;
		if cnt2 = 0 then
			Cursor_on <= not Cursor_on;
		end if;
	end if;
	V_Sync_r := V_Sync_t;
end if;
end process;

process(clk_50MHz)
	variable cnt : integer range 0 to 15;
	variable state : integer range 0 to 15;
	variable load_addr : integer range 0 to 399;
	variable fetch_step : std_logic;
begin
if clk_50MHz'event and clk_50MHz = '1' then
	cnt := (cnt + 1) mod 16;
	if cnt = 0 then
		if state = 15 then
			if V_Sync_t = '1' then	state := 0; end if;
			kbd_a <= (others => '0');
		elsif state < 11 then
			case kbd_a is
				when x"0" =>
					if kbd_k(7) = '0' and Cur_Col < 31 then	-- Right arrow
						Cur_Col <= Cur_Col + 1;
					end if;
					if kbd_k(6) = '0' then	-- Home
						Cur_Col <= 0;
						Cur_Line <= 0;
					end if;
				when x"1" =>
					if kbd_k(6) = '0' then	-- Bottom arrow
						if Cur_Line < 23 then
							Cur_Line <= Cur_Line + 1;
						elsif Disp_addr(23 downto 4) /= "11111111111111111111" then
							Disp_addr(23 downto 4) <= std_logic_vector(unsigned(Disp_addr(23 downto 4)) + 1);
						end if;
					end if;
					if kbd_k(7) = '0' then	-- Top arrow
						if Cur_Line > 0 then
							Cur_Line <= Cur_Line - 1;
						elsif Disp_addr(23 downto 4) /= "00000000000000000000" then
							Disp_addr(23 downto 4) <= std_logic_vector(unsigned(Disp_addr(23 downto 4)) - 1);
						end if;
					end if;
				when x"3" =>
					if kbd_k(5) = '0' and Cur_Col > 0 then	-- Right arrow
						Cur_Col <= Cur_Col - 1;
					end if;
				when x"4" =>
					if kbd_k(5) = '0' then	-- Page up
						if Disp_addr(23 downto 8) /= "0000000000000000" then
							Disp_addr(23 downto 8) <= std_logic_vector(unsigned(Disp_addr(23 downto 8)) - 1);
						end if;
					end if;
				when x"5" =>
					if kbd_k(5) = '0' then	-- Page up
						if Disp_addr(23 downto 8) /= "1111111111111111" then
							Disp_addr(23 downto 8) <= std_logic_vector(unsigned(Disp_addr(23 downto 8)) + 1);
						end if;
					end if;
				when others => null;
			end case;
			state := state + 1;
			kbd_a <= std_logic_vector(to_unsigned(state, kbd_a'length));
		else
			if V_Sync_t = '0' then	state :=  15; end if;
		end if;
	end if;
	
	-- Loads the data in buffer RAM
	if cnt = 0 then
		fetch_step := not fetch_step;
		if fetch_step = '0' then
			Addr <= std_logic_vector(to_unsigned(load_addr + to_integer(unsigned(Disp_addr)), Addr'length));
		else
			RAM_buffer(load_addr) <= Din;
			load_addr := load_addr + 1;
			if load_addr > 399 then load_addr := 0; end if;
		end if;
	end if;
end if;
end process;

end Behavioral;
