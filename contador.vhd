library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity contador is
	Port(
		clock : in STD_LOGIC;
		d0 : out STD_LOGIC_VECTOR (6 downto 0) := "0000001";
		selector : out STD_LOGIC_VECTOR(3 downto 0) := "1110"
	);

end contador;

--100Mhz




architecture Behavioral of contador is

	signal contador : integer range 0 to 100e4 := 0;
	signal segundo1 : integer range 0 to 10 := 0;
	signal segundo0 : integer range 0 to 10 := 0;
	signal decimo : integer range 0 to 10 := 0;
	signal centesimo : integer range 0 to 10 := 0;
	signal conta_ate4 : integer range 0 to 4 := 0;
	signal entrada : integer range 0 to 9 := 0;
	signal clk100hz : STD_LOGIC := '0';
	signal cont : integer range 0 to 100e6;



	component display is
		Port(
			e : in integer range 0 to 15;
			d : out STD_LOGIC_VECTOR(6 downto 0)
		);
	end component;

begin

	u1: display port map(entrada, d0);

	process(clock)
	begin
		if rising_edge(clock) then
			if contador=100e4 then
				contador <= 0;

				if centesimo=10 then
					centesimo <= 0;

						if decimo=10 then
							decimo <= 0;

							if segundo0=10 then
								segundo0 <= 0;

								if segundo1=10 then
									segundo1 <= 0;
								else
									segundo1 <= segundo1 +1;
								end if;
							else
								segundo0 <= segundo0 + 1;
							end if;
						else
							decimo <= decimo+1;
						end if;
					else
						centesimo <= centesimo+1;
					end if;
				else
					contador <= contador + 1;
				end if;
			end if;
	end process;


	process(clock)
	begin
		if rising_edge(clock) then
			if cont = 10e5 then
				cont <= 0;
				clk100hz <= not clk100hz;
			else
				cont <= cont +1;
			end if;
		end if;
	end process;

	process(clk100hz)
	begin
		if rising_edge(clk100hz) then
			if conta_ate4=4 then
				conta_ate4 <= 0;
				selector <= "0111";
				entrada <= segundo1;
			else
				if conta_ate4=3 then
					selector <= "1011";
					entrada <= segundo0;
				elsif conta_ate4=2 then
					selector <= "1101";
					entrada <= decimo;
				else
					selector <= "1110";
					entrada <= centesimo;
				end if;

			conta_ate4 <= conta_ate4 + 1;
			end if;
		end if;
	end process;

end Behavioral;


