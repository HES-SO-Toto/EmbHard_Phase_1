-------------------------------------------------------------------------------
-- HES-SO Master, projet du cours de LPSC 
--
-- File         : LCD_CTL.vhd
-- Description  : The file contain a implementation of a controler LDC for interface 8080
--                
--
-- Author       : Antonin Kenzi
-- Date         : 03.10.2024
-- Version      : 1.0
--
-- Dependencies :
--
--| Modifications |------------------------------------------------------------
-- Version   Author Date               Description
-- 1.0       AKI    12.03.2024          Creation of the file
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

ENTITY LCD_CTL IS
 GENERIC(N : NATURAL := 16);
 PORT(
	-- Avalon interfaces signals
		Clk_i				: IN std_logic;
		nReset_i 		: IN std_logic;
		D_C_n_i 		: IN std_logic;
		Start_i 			: IN std_logic;
		WriteData_i 	: IN std_logic_vector (N-1 DOWNTO 0);
		
		waitRequest_o	: out std_logic;
		
	-- 8080 interface
		DB_o				: OUT std_logic_vector (N-1 DOWNTO 0);
		D_C_n_o 		 	: out std_logic;
		--RD_n_o 			: out std_logic;
		WR_n_o 			: out std_logic
		--CS_n_o 			: out std_logic;
		--LCS_reset_n_o	: out std_logic;
		--IM0_o				: out std_logic
	);
End LCD_CTL;

ARCHITECTURE comp OF LCD_CTL IS
    -- Déclaration of the signals,components,types and procedures
    -- Components (Nomenclature : name of the component + _c)
    -- Types (Nomenclature : name of the type + _t)
    -- exemple : type state_t is (idle, start, stop);
	 type state_t is (idle, S1, S2,S3);
    -- Signals (Nomenclature : name of the signal + _s)
    -- exemple : signal a : signed(N_bit-1 downto 0);
    signal D_C_n_reg_s : std_logic;
    signal D_C_n_fut_s : std_logic;
    signal state_pres_s 	  : state_t;
    signal state_fut_s 	  	  : state_t;
    signal WR_n_pres_s 	  	  : std_logic;
    signal WR_n_fut_s 	  	  : std_logic;
    signal waitRequest_pres_s: std_logic;
    signal waitRequest_fut_s : std_logic;

	signal DB_fut_s		: std_logic_vector(N-1 DOWNTO 0);
	signal DB_reg_s			: std_logic_vector(N-1 DOWNTO 0);
	 
    -- Procedures (Nomenclature : name of the procedure + _p)

begin
    -- Declarations
    -- Process
	reg_wr_process :
	process(Clk_i, nReset_i)
	begin
	  if nReset_i='0' then
			state_pres_s<= idle;
			D_C_n_reg_s<= '0';
			DB_reg_s <= (others => '0');
			WR_n_pres_s <= '0';
			waitRequest_pres_s <= '0';
	  elsif rising_edge(Clk_i) then
			state_pres_s 			<= state_fut_s;
			D_C_n_reg_s 			<= D_C_n_fut_s;
			DB_reg_s 				<= DB_fut_s;
			WR_n_pres_s				<= WR_n_fut_s;
			waitRequest_pres_s 	<= waitRequest_fut_s;
	  end if; 
	end process;
	
	decode_state : process(Start_i,state_pres_s)
	begin
	  state_fut_s <= state_pres_s;
	  waitRequest_fut_s <= '0';
	  WR_n_fut_s <= '1';
	  D_C_n_fut_s <= D_C_n_reg_s;
	  DB_fut_s_s <= DB_reg_s;
	  case state_pres_s is
			when IDLE =>
				if Start_i = '1' then 
					state_fut_s <= S1;
					WR_n_fut_s <= '0';
					waitRequest_fut_s <= '1';
					DB_reg_fut_s <= WriteData_i;
					D_C_n_fut_s <= D_C_n_i;
				end if;
			when S1 =>
				state_fut_s <= S2;
				waitRequest_fut_s <= '1';
			when S2 => --keep for timing spec
				state_fut_s <= S3;
			when S3 =>
				state_fut_s <= IDLE;
			when others => 
			state_fut_s <= IDLE;
	  end case;
	end process;

	-- 8080 interface link
	DB_o <= DB_reg_s;
	D_C_n_o <= D_C_n_reg_s;
	WR_n_o <= WR_n_pres_s;
	WaitRequest_o <= WaitRequest_pres_s;
	--RD_n_o <= '0';
	--CS_n_o <= '0'; 
	--IM0_o <= '0';
	--LCS_reset_n_o <= nReset_i;
	
END comp;
