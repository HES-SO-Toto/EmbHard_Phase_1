-------------------------------------------------------------------------------
-- HES-SO Master, projet du cours de EmbHard 
--
-- File         : DMA.vhd
-- Description  : The file contain a implementation of a DMA component
--                
--
-- Author       : Antonin Kenzi
-- Date         : 03.10.2024
-- Version      : 1.1
--
-- Dependencies : LDC_CTL.vhd
--
--| Modifications |------------------------------------------------------------
-- Version   Author Date               Description
-- 1.0       AKI    18.10.2024          Creation of the file
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity DMA_LCD_ctrl is
	port (
		clk_i                 : in    std_logic                    ;
		reset_n_i             : in    std_logic                    ;         
		-- master interface
 		master_address_o	    : out  std_logic_vector(31 downto 0);
		master_read_o         	: out std_logic;
		master_readdata_i	    : in std_logic_vector(15 downto 0) ;
		master_waitrequest_i  	: in std_logic;
		-- IRQ generation
		end_of_transaction_irq_o : out std_logic;		
		-- slave interface 
		avalon_address_i    : in    std_logic_vector(2 downto 0) ;
		avalon_cs_i         : in    std_logic                   ;  
		avalon_wr_i         : in    std_logic                    ;  
		avalon_write_data_i : in    std_logic_vector(31 downto 0);
		avalon_rd_i         : in    std_logic                    ;  
		avalon_read_data_o  : out    std_logic_vector(31 downto 0);
		-- LCD interface
		LCD_data_o      : out std_logic_vector(15 downto 0) ;
		LCD_CS_n_o	  : out    std_logic ;		
		LCD_WR_n_o	  : out    std_logic ;				
		LCD_D_C_n_o	  : out    std_logic 
	);
end entity DMA_LCD_ctrl;

architecture rtl of DMA_LCD_ctrl is
    -- Déclaration of the signals,components,types and procedures
    -- Components (Nomenclature : name of the component + _c)
    -- TODO add LCD_DMA_c
    -- Types (Nomenclature : name of the type + _t)
	type state_ctl_t is (IDLE, DMA_ACCESS, LDC_SEND,FINISH);
	type state_DMA_t is (IDLE, WAIT_FREE_AVALON, ACCESS_SRAM,WAIT_DATA);
	type state_LCD_t is (IDLE, S1, S2,S3);
    -- exemple : type state_t is (idle, start, stop);
	
    -- Signals (Nomenclature : name of the signal + _s)
    -- exemple : signal a : signed(N_bit-1 downto 0);
    signal state_reg_ctl_s : state_ctl_t;
    signal state_fut_ctl_s : state_ctl_t;
	
    signal pointer_reg_s : std_logic_vector(31 downto 0);
    signal size_regs_s : std_logic_vector(31 downto 0);
    signal ctl_reg_s : std_logic_vector(2 downto 0);
    signal ctl_fut_s : std_logic_vector(2 downto 0);
    signal status_reg_s : std_logic_vector(2 downto 0);
    signal status_fut_s : std_logic_vector(2 downto 0);
	

    signal D_C_n_reg_s 			: std_logic;
    signal state_reg_LCD_s 	  	: state_t;
    signal state_fut_LCD_s 	  	: state_t
	signal start_lcd_s			: std_logic;
	signal start_lcd_DMA_s		: std_logic;
	signal wait_lcd_s			: std_logic;
    signal WR_n_reg_s 	  	  	: std_logic;
    signal WR_n_fut_s 	  	  	: std_logic;
    signal DB_reg_s				: std_logic_vector(N-1 DOWNTO 0);
    -- Procedures (Nomenclature : name of the procedure + _p)
	-- Déclaration of the signals,components,types and procedures
    -- Components (Nomenclature : name of the component + _c)
    -- Signals (Nomenclature : name of the signal + _s)
    -- exemple : signal a : signed(N_bit-1 downto 0);
	 

begin
    -- Declarations
    -- Process
    --===================== avalon slave ============================
	--
	Slave_Wr_p : process(Clk_i,reset_n_i)
	begin
		start_ldc_s <= '0'
		if reset_n='0' then
			pointer_reg_s <= (others => '0');
			size_reg_s <= (others => '0');
			ctl_reg_s <= (others => '0');
		elsif rising_edge(Clk) then
			ctl_reg_s <= ctl_fut_s;
			status_reg_s <= status_fut_s;
			if avalon_cs = '1' and avalon_wr = '1' then -- Write cycle
				case avalon_address_i(2 downto 0) is
					when "000" => 
						start_lcd_s => '1';
					when "001" => 
						start_lcd_s => '1';
					when "010" => pointer_reg_s <= WriteData;
					when "011" => size_reg_s <= WriteData;
					when "100" => 
						status_reg_s(0) <= '0';
						status_reg_s(1) <= WriteData(0);
						status_reg_s(2) <= '0' when WriteData(2) = '1' else status_fut_s(2);
					when others => null;
				end case;
			end if; 
		end if; 
	end process Slave_Wr_p;
 
	Slave_Rd_p: process(Clk)
	begin
		if rising_edge(clk) then
			master_readdata <= (others => '0'); -- default value
			if ChipSelect = '1' and avalon_rd = '1' then -- Read cycle
				case avalon_address_i(2 downto 0) is
					when "010" => master_readdata <= pointer_reg_s;
					when "011" => master_readdata <= size_reg_s;
					when "101" => master_readdata <=(2 downto 0 => status_reg_s, others => '0');
					when others => null;
				end case;
			end if;
		end if;
	end process Slave_Rd_p;

	--================= STATE MACHINE DMA ==========================

	
	pState_update : process(all)
	begin
	  if reset_n='0' then
			state_reg_ctl_s <= IDLE;
	  elsif rising_edge(Clk) then
            state_reg_ctl_s  <= state_fut_ctl_s;
			status_reg_s <= status_fut_s
	  end if; 
	end process pState_update;

    decode_CTL_state : process(all)
	begin
      state_fut_ctl_s <= state_reg_ctl_s;
	  master_read_s <= '0';
	  start_lcd_DMA_s <= '0';
	  case state_reg_ctl_s is
			when IDLE =>
				cnt <= pointer_reg_s; --need to be convert
				if status_reg_s(1) = '1' then 
					state_fut_ctl_s <= DMA_ACCESS;
				else
					state_fut_ctl_s <= IDLE;
				end if 
			when DMA_ACCESS =>
				if state_reg_LCD_s = IDLE then 
                	state_fut_ctl_s <= WAIT_DMA_VALUE;
					master_read_s <= '1'; --Start ram TODO 
				else 
                	state_fut_ctl_s <= DMA_ACCESS;
				end if
			when WAIT_DMA_VALUE =>
				if master_waitrequest = '1' then 
					state_fut_ctl_s <= WAIT_DMA_VALUE;
					master_read_s <= '1';
				else
					start_lcd_DMA_s <= '1';
					if unsigned(cnt) >= unsigned(pointer_reg_s) + unsigned(size_reg_s) then 
						state_fut_ctl_s <= FINISH;
					else
						state_fut_ctl_s <= DMA_ACCESS;
						cnt <= std_logic_vector(unsigned(cnt) + x"00000002")
					end if 
				end if
			when FINISH =>
                --irq enable TODO
				status_fut_s(0) <= '1';--done
				status_fut_s(1) <= '0'; 
                status_fut_s(2) <= '1'; --IQR
                state_fut_ctl_s <= IDLE;
			when others => 
			    state_fut_ctl_s <= IDLE;
	  end case;
	end process;

	end_of_transaction_irq_o <= status_reg_s(2);
    master_address_o <= pointer_reg_s + cnt;
    master_read_o <= master_read_s;

	--======================== LDC ===========================
	-- start_lcd_s start vector
	-- D_C_n_reg_s and DB_reg_s controled outside
    -- Process
	reg_wr_process :
	process(all)
	begin
	  if nReset_i='0' then
			state_reg_LCD_s		<= idle;
			WR_n_reg_s 			<= '0';
			D_C_n_reg_s			<= '0';
			DB_reg_s 			<= (others => '0');
	  elsif rising_edge(Clk_i) then
			D_C_n_reg_s			<= D_C_n_fut_s;
			DB_reg_s			<= DB_fut_s;
			state_reg_LCD_s 	<= state_fut_s;
			WR_n_reg_s			<= WR_n_fut_s;
	  end if; 
	end process;
	
	decode_state : process(all)
	begin
	  	state_fut_s 	<= state_reg_LCD_s;
	  	WR_n_fut_s 		<= '1';
		wait_lcd_s 		<= '1';
		DB_fut_s 		<= DB_reg_s;
		D_C_n_fut_s		<= D_C_n_reg_s;
		case state_reg_LCD_s is
				when IDLE =>
					if state_reg_ctl_s = IDLE then
						D_C_n_fut_s <= avalon_address_i(0); --adress slave
						DB_fut_s <= slave_WriteData(15 downto 0);
					else
						D_C_n_fut_s <= '1';
						DB_fut_s <= master_ReadData(15 downto 0);
					end if 
					wait_lcd_s <= '0';
					if start_lcd_s = '1' or start_lcd_DMA_s = '1' then 
						state_fut_s <= S1;
						WR_n_fut_s <= '0';
					end if;
				when S1 =>
					state_fut_s <= S2;
				when S2 =>
					state_fut_s <= S3;
				when S3 =>
					wait_lcd_s <= '0';
					state_fut_s <= IDLE;
				when others => 
					wait_lcd_s <= '0';
					state_fut_s <= IDLE;
		end case;
	end process;

	-- 8080 interface link
	LCD_data_o <= DB_reg_s;
	LCD_D_C_n_o <= D_C_n_reg_s;
	LCD_WR_n_o <= WR_n_reg_s;
	LCD_CS_n_o <= '1';

END rtl;