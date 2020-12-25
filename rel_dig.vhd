LIBRARY ieee;                  -- HABILITA AS FUNCOES DA BIBLIOTECA IEEE
USE ieee.std_logic_1164.all;

ENTITY rel_dig IS
	GENERIC(SEG:INTEGER := 49999999); -- P/ O RELÓGIO CONTAR EM SEGUNDOS 
	PORT( HEX0 :OUT STD_LOGIC_VECTOR (6 downto 0); -- 1º DISPLAY
			HEX1 :OUT STD_LOGIC_VECTOR (6 downto 0); -- 2º DISPLAY
			HEX2 :OUT STD_LOGIC_VECTOR (6 downto 0); -- 3º DISPLAY
			HEX3 :OUT STD_LOGIC_VECTOR (6 downto 0); -- 4º DISPLAY
			CLOCK_50 :IN STD_LOGIC); -- CLOCK DE 50 MHz 
END rel_dig;

ARCHITECTURE estrutural OF rel_dig IS
	SIGNAL div_freq: INTEGER RANGE 0 TO SEG; -- AJUSTE TEMPORAL DO CLOCK

	SIGNAL segs: INTEGER RANGE 0 TO 59 := 0; -- SEGUNDOS
	SIGNAL hrs1: INTEGER RANGE 0 TO 9 := 0;  -- 1° CARACTERE DA HORA
	SIGNAL hrs2: INTEGER RANGE 0 TO 2 := 0;  -- 2° CARACTERE DA HORA
	SIGNAL min1: INTEGER RANGE 0 TO 9 := 0;  -- 1° CARACTERE DOS MINUTOS
	SIGNAL min2: INTEGER RANGE 0 TO 5 := 0;  -- 2° CARACTERE DOS MINUTOS
	
	FUNCTION conv(dec:INTEGER) RETURN STD_LOGIC_VECTOR IS -- CONV P/ SEGMS
		  VARIABLE bin: STD_LOGIC_VECTOR(6 downto 0);
	BEGIN 
		CASE dec IS
			WHEN 0 => bin := "1000000";
			WHEN 1 => bin := "1111001";
			WHEN 2 => bin := "0100100";
			WHEN 3 => bin := "0110000";
			WHEN 4 => bin := "0011001";
			WHEN 5 => bin := "0010010";
			WHEN 6 => bin := "0000010";
			WHEN 7 => bin := "1011000";
			WHEN 8 => bin := "0000000";
			WHEN 9 => bin := "0010000";
			WHEN OTHERS => bin := (OTHERS=>'0');
		END CASE;
		RETURN bin;
	END conv;
	
BEGIN
   -- ACESSA A FUNÇÃO PARA ALOCAR OS VALORES DOS SINAIS AOS 7 SEGMENTOS
	HEX0 <= conv(min1); 
	HEX1 <= conv(min2);
	HEX2 <= conv(hrs1);
	HEX3 <= conv(hrs2);

	PROCESS(CLOCK_50)
	BEGIN
		IF(CLOCK_50'EVENT AND CLOCK_50 = '1') THEN
			IF (div_freq /= SEG) THEN
				div_freq <= div_freq + 1;
			ELSE
				div_freq <= 0;
				segs <= segs + 1;
				IF (segs = 59) THEN
					segs <= 0;
					min1 <= min1 + 1;
					IF (min1 = 9) THEN
						min1 <= 0;
						min2 <= min2 + 1;
						IF (min2 = 5) THEN
							min2 <= 0;
							hrs1 <= hrs1 + 1;
							IF (hrs1 = 9) THEN
								hrs1 <= 0;
								hrs2 <= hrs2 + 1;
							ELSIF (hrs1 = 3 AND hrs2 = 2) THEN
								min1 <= 0;
								min2 <= 0;
								hrs1 <= 0;
								hrs2 <= 0;
							END IF;
						END IF;
					END IF;
				END IF;
			END IF;
		END IF;
	END PROCESS;
END estrutural;