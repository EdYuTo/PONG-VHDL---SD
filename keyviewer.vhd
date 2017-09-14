library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity keyviewer is
	port(
		clk, reset: in std_logic;
		key: in std_logic_vector(7 downto 0);
		videochar: out std_logic_vector(15 downto 0);
		videopos: out std_logic_vector(15 downto 0);
		videodraw: out std_logic
	);
end keyviewer;

architecture behav of keyviewer is

   --tela
   signal videoe: std_logic_vector(7 downto 0);
	signal enable : std_logic;
	signal restart : std_logic;
	
	--win
	signal win: std_logic_vector(1 downto 0);
	
	--cont de cima
	signal contcimapos: std_logic_vector(15 downto 0);
	signal contcimachar: std_logic_vector(7 downto 0);
	signal contcimacor: std_logic_vector(3 downto 0);
	
	--cont de baixo
	signal contbaixopos: std_logic_vector(15 downto 0);
	signal contbaixochar: std_logic_vector(7 downto 0);
	signal contbaixocor: std_logic_vector(3 downto 0);
	
	--barra baixo (barra 1)
	signal esqdir1: std_logic_vector(1 downto 0);--aux de apagar
	signal esqdir2: std_logic_vector(1 downto 0);--aux de apagar
	
	signal barra1pos1: std_logic_vector(15 downto 0);--pos atual
	signal barra1posa1: std_logic_vector(15 downto 0);--pos anterior
	signal barra1char1: std_logic_vector(7 downto 0);
	signal barra1cor1: std_logic_vector(3 downto 0);

	signal barra1pos5: std_logic_vector(15 downto 0);--pos atual
	signal barra1posa5: std_logic_vector(15 downto 0);--pos anterior
	signal barra1char5: std_logic_vector(7 downto 0);
	signal barra1cor5: std_logic_vector(3 downto 0);
	
	--barra cima (barra 2)
	signal esqdir3: std_logic_vector(1 downto 0);--aux de apagar
	signal esqdir4: std_logic_vector(1 downto 0);--aux de apagar
	
	signal barra2pos1: std_logic_vector(15 downto 0);--pos atual
	signal barra2posa1: std_logic_vector(15 downto 0);--pos anterior
	signal barra2char1: std_logic_vector(7 downto 0);
	signal barra2cor1: std_logic_vector(3 downto 0);
		
	signal barra2pos5: std_logic_vector(15 downto 0);--pos atual
	signal barra2posa5: std_logic_vector(15 downto 0);--pos anterior
	signal barra2char5: std_logic_vector(7 downto 0);
	signal barra2cor5: std_logic_vector(3 downto 0);
	
	--bolinha
	signal bolapos: std_logic_vector(15 downto 0);--pos atual
	signal bolaposa: std_logic_vector(15 downto 0);--pos anterior
	signal bolachar: std_logic_vector(7 downto 0);
	signal bolacor: std_logic_vector(3 downto 0);
	signal incbola: std_logic_vector(7 downto 0);
	signal sinal: std_logic;
		
	--delays
	signal delay00: std_logic_vector(31 downto 0);--barra baixo1
	signal delay01: std_logic_vector(31 downto 0);--barra baixo5
	signal delay10: std_logic_vector(31 downto 0);--barra cima1
	signal delay11: std_logic_vector(31 downto 0);--barra cima5
	signal delay2: std_logic_vector(31 downto 0);--bolinha
	
	--estados
	signal barra1estado1: std_logic_vector(7 downto 0);
	signal barra1estado5: std_logic_vector(7 downto 0);
	signal barra2estado1: std_logic_vector(7 downto 0);
	signal barra2estado5: std_logic_vector(7 downto 0);
	signal bolaestado: std_logic_vector(7 downto 0);
	
begin
   --barra baixo
process (clk, reset)
   begin
	
	if (reset = '1') or (restart = '1') then
	   barra1char1 <= x"2F"; --/
		barra1cor1 <= "1111";
		barra1pos1 <= x"0499";
		
		barra1char5 <= x"2F";--/
		barra1cor5 <= "1111";
		barra1pos5 <= x"049D";
		
		delay00 <= x"00000000";
		delay01 <= x"00000000";
		
		barra1estado1 <= x"00";
		barra1estado5 <= x"00";
		
		esqdir1 <= "00";
		esqdir2 <= "00";
		
	elsif (clk'event) and (clk = '1')  and (enable = '1') then
	   case barra1estado1 is
         	when x"00" =>
				   case key is
					   when x"61" => --esq
						   if (barra1pos1 > 1160) then
							   barra1pos1 <= barra1pos1 - x"01";
								esqdir1 <= "10";
							end if;
						when x"64" => --dir
						   if (barra1pos1 < 1195) then
							   barra1pos1 <= barra1pos1 + x"01";
								esqdir1 <= "01";
							end if;
						when others =>
					end case;
					barra1estado1 <= x"01";
					
				when x"01" =>--delay de impressao
				   if delay00 >= x"00003A90" then
					   delay00 <= x"00000000";
						barra1estado1 <= x"00";
					else
					   delay00 <= delay00 + x"01";
					end if;
					
				when others =>
			end case;
			
		--
		
		case barra1estado5 is
         	when x"00" =>
				   case key is
					   when x"61" => --esq
						   if (barra1pos5 > 1164) then
							   barra1pos5 <= barra1pos5 - x"01";
								esqdir2 <= "10";
							end if;
						when x"64" => --dir
						   if (barra1pos5 < 1199) then
							   barra1pos5 <= barra1pos5 + x"01";
								esqdir2 <= "01";
							end if;
						when others =>
					end case;
					barra1estado5 <= x"01";
					
				when x"01" =>--delay de impressao
				   if delay01 >= x"00003A90" then
					   delay01 <= x"00000000";
						barra1estado5 <= x"00";
					else
					   delay01 <= delay01 + x"01";
					end if;
					
				when others =>
			end case;
		end if;
	end process;
	
   --barra cima
process (clk, reset)
   begin  
	
	if (reset = '1') or (restart = '1') then
	   barra2char1 <= x"2F"; --/
		barra2cor1 <= "1111";
		barra2pos1 <= x"0010";
		
		barra2char5 <= x"2F";--/
		barra2cor5 <= "1111";
		barra2pos5 <= x"0014";
		
		delay10 <= x"00000000";
		delay11 <= x"00000000";
		
		barra2estado1 <= x"00";
		barra2estado5 <= x"00";
		
		esqdir3 <= "00";
		esqdir4 <= "00";
		
	elsif (clk'event) and (clk ='1') and (enable = '1') then
	   case barra2estado1 is 
		   when x"00" => 
			   if ((conv_integer(bolapos) mod 40) < (conv_integer(barra2pos1) mod 40)+2) then --esq
				   if (barra2pos1 > 0) then
					   barra2pos1 <= barra2pos1 - x"01";
						esqdir3 <= "10";
					end if;
					
				elsif((conv_integer(bolapos) mod 40) > (conv_integer(barra2pos5) mod 40)-2) then --dir
				   if (barra2pos1 < 35) then
					   barra2pos1 <= barra2pos1 + x"01";
					   esqdir3 <= "01";
					end if;
				end if;
				barra2estado1 <= x"01";
			
			when x"01" => --delay de impressao
			   if delay10 >= x"00003080" then --1d4c
				   delay10 <= x"00000000";
					barra2estado1 <= x"00";
				else
				   delay10 <= delay10 + x"01";
				end if;
								
			when others =>
			
			end case;
			
			--
			
		case barra2estado5 is 
		   when x"00" =>
			   if ((conv_integer(bolapos) mod 40) < (conv_integer(barra2pos1) mod 40)+2) then --esq
				   if (barra2pos5 > 4) then
					   barra2pos5 <= barra2pos5 - x"01";
						esqdir4 <= "10";
					end if;
					
				elsif((conv_integer(bolapos) mod 40) > (conv_integer(barra2pos5) mod 40)-2) then --dir
				   if (barra2pos5 < 39) then
					   barra2pos5 <= barra2pos5 + x"01";
					   esqdir4 <= "01";
					end if;
				end if;
				barra2estado5 <= x"01";
			
			when x"01" => --delay de impressao
			   if delay11 >= x"00003080" then --1d4c
				   delay11 <= x"00000000";
					barra2estado5 <= x"00";
				else
				   delay11 <= delay11 + x"01";
				end if;
								
			when others =>
			
			end case;
			
		end if;
	end process;
	
	--bolinha
process (clk, reset)
   begin
	
	if (reset = '1') or (restart = '1') then
	   contcimapos <= x"023A";
		contcimachar <= x"30";
		contcimacor <= "1111";
		
		contbaixopos <= x"024D";
		contbaixochar <= x"30";
		contbaixocor <= "1111";
		
		win <= "00";
		
		bolachar <= x"2A";
		bolacor <= "1111";
		bolapos <= x"006E";
		incbola <= x"29";
		sinal <= '0';
		delay2 <= x"00000000";
		bolaestado <= x"00";
	
	elsif (clk'event) and (clk = '1') and (enable = '1') then
	   case bolaestado is
		   when x"00" => --incrementa a pos da bola
			   if (sinal = '0') then
				   bolapos <= bolapos + incbola;
				else
				   bolapos <= bolapos - incbola;
				end if;
				bolaestado <= x"01";
			
			when x"01" => --bola subindo/atingiu o topo
			   if (bolapos < 40) then
				   contbaixochar <= contbaixochar + 1;--marca ponto
					if (contbaixochar = x"39") then--quando da 10, o jogo acaba!
					   contbaixochar <= x"30";
						contcimachar <= x"30";
						win <= "10";
					end if;
				   if (incbola = 41) then
					   incbola <= x"27";
						sinal <= '0';
					end if;
				   if (incbola = 40) then
					   incbola <= x"28";
						sinal <= '0';
					end if;
					if (incbola = 39) then
					   incbola <= x"29";
						sinal <= '0';
					end if;
				end if;
				bolaestado <= x"02";
				
			when x"02" => --bola descendo/atingiu a base
			   if (bolapos > 1159) then
				   contcimachar <= contcimachar + 1;--marca ponto
					if (contcimachar = x"39") then--quando da 10, o jogo acaba!
					   contbaixochar <= x"30";
						contcimachar <= x"30";
						win <= "01";
					end if;
				   if (incbola = 41) then
					   incbola <= x"27";
						sinal <= '1';
					end if;
				   if (incbola = 40) then
					   incbola <= x"28";
						sinal <= '1';
					end if;
					if (incbola = 39) then
					   incbola <= x"29";
						sinal <= '1';
					end if;
				end if;
				bolaestado <= x"03";
				
			when x"03" => --bola indo direita
			   if ((conv_integer(bolapos) mod 40) = 39) then
				   if (incbola = 39) then
					   incbola <= x"29";
						sinal <= '1';
					end if;
					if (incbola = 1) then
					   incbola <= x"01";
						sinal <= '1';
					end if;
					if (incbola = 41) then
					   incbola <= x"27";
						sinal <= '0';
					end if;
				end if;
				bolaestado <= x"04";
			
			when x"04" => --bola indo esquerda
			   if ((conv_integer(bolapos) mod 40) = 0) then
				   if (incbola = 39) then
					   incbola <= x"29";
						sinal <= '0';
					end if;
					if (incbola = 1) then
					   incbola <= x"01";
						sinal <= '0';
					end if;
					if (incbola = 41) then
					   incbola <= x"27";
						sinal <= '1';
					end if;
				end if;
				bolaestado <= x"05";
				
			when x"05" => --bola atinge barra1 (barra de baixo)
			   if (((bolapos + 40) >= barra1pos1 -1) and ((bolapos + 40) <= barra1pos5+1) and (sinal = '0')) then
				   if (incbola = 41) then
					   incbola <= x"27";
						sinal <= '1';
					end if;
				   if (incbola = 40) then
					   incbola <= x"28";
						sinal <= '1';
					end if;
					if (incbola = 39) then
					   incbola <= x"29";
						sinal <= '1';
					end if;
				end if;
				bolaestado <= x"06";
			
			when x"06" => --bola atinge barra2 (barra de cima)
				if (((bolapos - 40) >= barra2pos1 -1) and ((bolapos - 40) <= barra2pos5 +1) and (sinal = '1')) then
				   if (incbola = 41) then
					   incbola <= x"27";
						sinal <= '0';
					end if;
				   if (incbola = 40) then
					   incbola <= x"28";
						sinal <= '0';
					end if;
					if (incbola = 39) then
					   incbola <= x"29";
						sinal <= '0';
					end if;
				end if;
				bolaestado <= x"FF";
				
			when x"FF" => --delay
			   if delay2 >= x"00002BEC" then
				   delay2 <= x"00000000";
					bolaestado <= x"00";
				else
				   delay2 <= delay2 + x"01";
				end if;
				
			when others =>
			   bolaestado <= x"00";
		   end case;
	   end if;
   end process;

   --escrever na tela
process (clk, reset)
   variable count : integer := 0;--contador para desenho da 1 tela
	variable count1 : integer := 0;--contador para desenho da 1 tela
	variable count2 : integer := 0;--contador para desenho da 1 tela
		
   begin
	
	if reset = '1' then
	   videoe <= x"23";
		videodraw <= '0';
		enable <= '0';
		
	   bolaposa <= x"0000";
		
		barra1posa1 <= x"0000";
		barra1posa5 <= x"0000";
		
		barra2posa1 <= x"0000";
		barra2posa5 <= x"0000";
										
		count := 0;--vai "pintar" todos os 1200 pontos da tela
		count1 := 17;--desenha 5 partes da barra de cima
		count2:= 1177;--desenha 5 partes da barra de baixo
		
		restart <= '0';
		
	elsif (clk'event) and (clk = '1') then
	   case videoe is 
		   when x"23" => --tela preta
			   videochar(15 downto 0) <= "0000000000000000";
				videopos(15 downto 0) <= conv_std_logic_vector(count, 16);
				videodraw <= '1';
				videoe <= x"24";
			
			when x"24" =>
			   videodraw <= '0';
				count := count+1;
				if (count < 1200) then
				   videoe <= x"23";
				else 
				   videoe <= x"25";
				end if;
				
			when x"25" => --barrinha cima
			   videochar(15 downto 0) <= "0000111100101111";
				videopos(15 downto 0) <= conv_std_logic_vector(count1, 16);
				videodraw <= '1';
				videoe <= x"26";
				
			when x"26" =>
			   videodraw <= '0';
				count1 := count1+1;
				if (count1 < 22) then
				   videoe <= x"25";
				else 
				   videoe <= x"27";
				end if;
			   
			when x"27" => --barrinha baixo
			   videochar(15 downto 0) <= "0000111100101111";
				videopos(15 downto 0) <= conv_std_logic_vector(count2, 16);
				videodraw <= '1';
				videoe <= x"28";
				
			when x"28" =>
			   videodraw <= '0';
				count2 := count2+1;
				if (count2 < 1182) then
				   videoe <= x"27";
				else
				   count := 11;
					count1 := 254;
					videoe <= x"29";
				end if;
							
			when x"29" =>
			   if (key = 32) then --space
				   enable <= '1';
					restart <= '0';
					videoe <= x"30";
				else
				   videoe <= x"29";
				end if;
			
			when x"30" =>
			   if (win = "10") then
				   videoe <= x"31";
					restart <= '1';
					enable <= '0';
				elsif (win = "01") then
				   videoe <= x"32";
					restart <= '1';
					enable <= '0';
				else 
				   videoe <= x"00";
				end if;
				
			when x"31" => --barrinha baixo ganha
			   videochar(15 downto 0) <= "0000111101010000";---"P"
				videopos(15 downto 0) <= x"0243";
				videodraw <= '1';
				videoe <= x"33";
				
			when x"32" => --barrinha cima ganha
			   videochar(15 downto 0) <= "0000111101000001";---"A"
				videopos(15 downto 0) <= x"0243";
				videodraw <= '1';
				videoe <= x"33";
				
			when x"33" =>
			   videodraw <= '0';
				videoe <= x"34";
				
			when x"34" => 
			   videochar(15 downto 0) <= "0000111100110001";---"1"
				videopos(15 downto 0) <= x"0244";
				videodraw <= '1';
				videoe <= x"35";
				
			when x"35" =>
			   videodraw <= '0';
				videoe <= x"36";
			
		   when x"36" => 
			   videochar(15 downto 0) <= "0000111101010111";---"W"
				videopos(15 downto 0) <= x"026A";
				videodraw <= '1';
				videoe <= x"37";
				
			when x"37" =>
			   videodraw <= '0';
				videoe <= x"38";
			
	   	when x"38" => 
			   videochar(15 downto 0) <= "0000111101001001";---"I"
				videopos(15 downto 0) <= x"026B";
				videodraw <= '1';
				videoe <= x"39";
				
			when x"39" =>
			   videodraw <= '0';
				videoe <= x"40";
	 		
	   	when x"40" => 
			   videochar(15 downto 0) <= "0000111101001110";---"N"
				videopos(15 downto 0) <= x"026C";
				videodraw <= '1';
				videoe <= x"41";
				
			when x"41" =>
			   videodraw <= '0';
				videoe <= x"42";
			
	   	when x"42" => 
			   videochar(15 downto 0) <= "0000111101010011";---"S"
				videopos(15 downto 0) <= x"026D";
				videodraw <= '1';
				videoe <= x"43";
				
			when x"43" =>
			   videodraw <= '0';
				videoe <= x"44";	
			
			when x"44" =>
			   if (key = 32) then --space
				  count := 0;--vai "pintar" todos os 1200 pontos da tela
              count1 := 17;--desenha 5 partes da barra de cima
		        count2:= 1177;--desenha 5 partes da barra de baixo
				  videoe <= x"23";
				else
				   videoe <= x"44";
				end if;
			
		   when x"00" => --apaga bolinha
			   if (bolaposa = bolapos) then
				   videoe <= x"04";
				else
				   videochar(15 downto 12) <= "0000";
					videochar(11 downto 8) <= "0000";
					videochar(7 downto 0) <= "00000000";
					videopos(15 downto 0) <= bolaposa;
					
					videodraw <= '1';
					videoe <= x"01";
				end if;
				
			when x"01" =>
			   videodraw <= '0';
				videoe <= x"02";
				
			when x"02" => --desenha bolinha
			    videochar(15 downto 12) <= "0000";
				 videochar(11 downto 8) <= bolacor;
				 videochar(7 downto 0) <= bolachar;
				 videopos(15 downto 0) <= bolapos;
				 
				 bolaposa <= bolapos;
				 videodraw <= '1';
				 videoe <= x"03";
				 
			when x"03" =>
			   videodraw <= '0';
				videoe <= x"04";
			
			when x"04" => --apaga barra1pos1
			   if (barra1posa1 = barra1pos1) then
				   videoe <= x"08";
				elsif (esqdir1 = "10") then
				   videoe <= x"06";
				else
				   videochar(15 downto 12) <= "0000";
					videochar(11 downto 8) <= "0000";
					videochar(7 downto 0) <= "00000000";
					videopos(15 downto 0) <= barra1posa1;
					
					videodraw <= '1';
					videoe <= x"05";
				end if;
			
			when x"05" =>
			   videodraw <= '0';
				videoe <= x"06";
				
			when x"06" => --desenha barra1pos1
			   videochar(15 downto 12) <= "0000";
				videochar(11 downto 8) <= barra1cor1;
				videochar(7 downto 0) <= barra1char1;
				videopos(15 downto 0) <= barra1pos1;
				
				barra1posa1 <= barra1pos1;
				videodraw <= '1';
				videoe <= x"07";
			
			when x"07" =>
			   videodraw <= '0';
				videoe <= x"08";				
				
			when x"08" => --apaga barra1pos5
			   if ((barra1posa5 = barra1pos5)) then
				   videoe <= x"12";
				elsif (esqdir2 = "01") then
				   videoe <= x"10";
				else
				   videochar(15 downto 12) <= "0000";
					videochar(11 downto 8) <= "0000";
					videochar(7 downto 0) <= "00000000";
					videopos(15 downto 0) <= barra1posa5;
					
					videodraw <= '1';
					videoe <= x"09";
				end if;
				
			when x"09" =>
			   videodraw <= '0';
				videoe <= x"10";
				
			when x"10" => --desenha barra1pos5
			   videochar(15 downto 12) <= "0000";
				videochar(11 downto 8) <= barra1cor5;
				videochar(7 downto 0) <= barra1char5;
				videopos(15 downto 0) <= barra1pos5;
				
				barra1posa5 <= barra1pos5;
				videodraw <= '1';
				videoe <= x"11";
			
			when x"11" =>
			   videodraw <= '0';
				videoe <= x"12";
						
			when x"12" => --apaga barra2pos1
			   if (barra2posa1 = barra2pos1) then
				   videoe <= x"16";
				elsif (esqdir3 = "10") then
				   videoe <= x"14";
				else
				   videochar(15 downto 12) <= "0000";
					videochar(11 downto 8) <= "0000";
					videochar(7 downto 0) <= "00000000";
					videopos(15 downto 0) <= barra2posa1;
					
					videodraw <= '1';
					videoe <= x"13";
				end if;
				
			when x"13" =>
			   videodraw <= '0';
				videoe <= x"14";
				
			when x"14" => --desenha barra2pos1
			   videochar(15 downto 12) <= "0000";
				videochar(11 downto 8) <= barra2cor1;
				videochar(7 downto 0) <= barra2char1;
				videopos(15 downto 0) <= barra2pos1;
				
				barra2posa1 <= barra2pos1;
				videodraw <= '1';
				videoe <= x"15";
			
			when x"15" =>
			   videodraw <= '0';
				videoe <= x"16";
				
			when x"16" => --apaga barra2pos5
			   if (barra2posa5 = barra2pos5) then
				   videoe <= x"20";
				elsif (esqdir4 = "01") then
				   videoe <= x"18";
				else
				   videochar(15 downto 12) <= "0000";
					videochar(11 downto 8) <= "0000";
					videochar(7 downto 0) <= "00000000";
					videopos(15 downto 0) <= barra2posa5;
					
					videodraw <= '1';
					videoe <= x"17";
				end if;
			
			when x"17" =>
			   videodraw <= '0';
				videoe <= x"18";
									
			when x"18" => --desenha barra2pos5
			   videochar(15 downto 12) <= "0000";
				videochar(11 downto 8) <= barra2cor5;
				videochar(7 downto 0) <= barra2char5;
				videopos(15 downto 0) <= barra2pos5;
				
				barra2posa5 <= barra2pos5;
				videodraw <= '1';
				videoe <= x"19";
				
			when x"19" =>
			   videodraw <= '0';
				videoe <= x"20";
			
			when x"20" => --desenhar contbaixo
			   videochar(15 downto 12) <= "0000";
				videochar(11 downto 8) <= contbaixocor;
				videochar(7 downto 0) <= contbaixochar;
				videopos(15 downto 0) <= contbaixopos;
				
				videodraw <= '1';
				videoe <= x"21";
			
			when x"21" =>
			   videodraw <= '0';
				videoe <= x"22";
				
			when x"22" => --desenhar contcima
			   videochar(15 downto 12) <= "0000";
				videochar(11 downto 8) <= contcimacor;
				videochar(7 downto 0) <= contcimachar;
				videopos(15 downto 0) <= contcimapos;
				
				videodraw <= '1';
				videoe <= x"ff";
			
			when others =>
			   videodraw <= '0';
				videoe <= x"30";
		   end case;
	   end if;
	end process;
end behav;