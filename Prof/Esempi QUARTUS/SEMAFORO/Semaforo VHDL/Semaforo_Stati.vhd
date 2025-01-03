
entity Semaforo_Stati is
	port
	(
		clk								: in  bit;
		reset							: in  bit := '0';
		timeout 						: in  bit;

		red_a, yellow_a, green_a 		: out bit;
		red_b, yellow_b, green_b 		: out bit;
		time_to_wait					: out integer range 0 to 255
	);
end Semaforo_Stati;

architecture Semaforo_Stati of Semaforo_Stati is

	type StatiMacchina is (red,	yel_a, yel_b, green);
	SIGNAL Macchina : StatiMacchina;

begin

	--- Gestione transizione stati
	process (clk, reset)
	begin
		
		if (reset = '1') then

			Macchina <= red;

		elsif (clk'event and clk = '1') then

			case Macchina is
				when red =>
					if timeout = '1' then
						Macchina <= yel_b;
					end if;
				when yel_a =>
					if timeout = '1' then
						Macchina <= red;
					end if;
				when yel_b =>
					if timeout = '1' then
						Macchina <= green;
					end if;
				when green =>
					if timeout = '1' then
						Macchina <= yel_a;
					end if;
			end case;

		end if;
	
	end process;

	--- Gestione delle uscite
	process (clk, reset)
	begin
		
		if (clk'event and clk = '1') then

			case Macchina is
				when red =>
					red_a <= '1';
					yellow_a <= '0';
					green_a <= '0';
					red_b <= '0';
					yellow_b <= '0';
					green_b <= '1';
					time_to_wait <= 7;

				when yel_a =>
					red_a <= '0';
					yellow_a <= '1';
					green_a <= '1';
					red_b <= '1';
					yellow_b <= '0';
					green_b <= '0';
					time_to_wait <= 3;

				when yel_b =>
					red_a <= '1';
					yellow_a <= '0';
					green_a <= '0';
					red_b <= '0';
					yellow_b <= '1';
					green_b <= '1';
					time_to_wait <= 3;

				when green =>
					red_a <= '0';
					yellow_a <= '0';
					green_a <= '1';
					red_b <= '1';
					yellow_b <= '0';
					green_b <= '0';
					time_to_wait <= 7;

			end case;

		end if;
	
	end process;

end Semaforo_Stati;

