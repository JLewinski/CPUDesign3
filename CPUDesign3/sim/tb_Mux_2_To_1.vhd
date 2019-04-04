library ieee;
    use ieee.std_logic_1164.all;
    use ieee.NUMERIC_STD.all;

library std;
    use std.textio.all;

entity tb_Mux_2_To_1 is
end entity;

architecture rtl_sim of tb_Mux_2_To_1 is

    constant d_WIDTH: integer := 1;

    constant CLK_PERIOD: time := 40 ns;
    constant RST_HOLD_DURATION: time := 200 ns;
    signal SEL: std_logic;
    signal CLK: std_logic;
    signal RST: std_logic;
    signal i_Data1: std_logic_vector(d_WIDTH - 1 downto 0);
    signal i_Data2: std_logic_vector(d_WIDTH - 1 downto 0);
    signal o_Data: std_logic_vector(d_WIDTH - 1 downto 0);

begin

    Mux_2_To_1_inst: entity work.Mux_2_To_1
        generic map (
            d_WIDTH => d_WIDTH
        )
        port map (
            SEL     => SEL,
            RST     => RST,
            i_Data1 => i_Data1,
            i_Data2 => i_Data2,
            o_Data  => o_Data
        );

    stimuli_p: process is
    begin
        SEL <= '0';
        i_Data1 <= (others => '0');
        i_Data2 <= (others => '0');
        wait until falling_edge(RST);
        wait until falling_edge(CLK);

        for i in 0 to 2 ** d_WIDTH - 1 loop
            SEL <= '0';
            i_Data1 <= STD_LOGIC_VECTOR(TO_UNSIGNED(i, d_WIDTH));
            i_Data2 <= STD_LOGIC_VECTOR(TO_UNSIGNED(2 ** d_WIDTH - 1 - i, d_WIDTH));
            wait for CLK_PERIOD * 2;

            SEL <= '1';
            wait for CLK_PERIOD * 2;
        end loop;

        wait;
    end process;

    clock_p: process is
    begin
        CLK <= '0';
        wait for CLK_PERIOD / 2;
        CLK <= '1';
        wait for CLK_PERIOD / 2;
    end process;

    reset_p: process is
    begin
        RST <= '1';
        wait for RST_HOLD_DURATION;
        wait until rising_edge(CLK);
        RST <= '0';
        wait;
    end process;

end architecture;

