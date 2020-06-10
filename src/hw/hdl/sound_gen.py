#
# This file is a helper to generate the sound_gen component, which handles
# the complete sound generation pipeline
#
# file:         sound_gen.py
# generates:    sound_gen.vhd
# author:       Alexandre CHAU
import math
import datetime

# Configure DAC properties here
DAC_FREQ = 48000
DAC_DEPTH = 16
N_OSC = 1

# Derived properties
DAC_MAX_SIGNED_INT = (2 ** (DAC_DEPTH - 1) - 1)
DAC_MIN_SIGNED_INT = -(2 ** (DAC_DEPTH - 1))
OSC_RANGE = int(math.floor((DAC_MAX_SIGNED_INT - DAC_MIN_SIGNED_INT) / N_OSC))
OSC_DEPTH = math.ceil(math.log(OSC_RANGE, 2))
OSC_MAX = int(math.floor(OSC_RANGE / 2))
OSC_MIN = -OSC_MAX


# Generate VHDL

header = f"""--
-- Sound synthesizer master generator
-- Computes final audio samples to be sent to the WM8731 audio codec
--
-- DO NOT CHANGE THIS FILE DIRECTLY, INSTEAD CHANGE sound_gen.py!
--
-- file:                sound_gen.vhd
-- auto-generated from: sound_gen.py
-- last generated:      {datetime.date.today()}
-- author:              Alexandre CHAU & Loïc DROZ
--
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
"""

entity = f"""
entity sound_gen is
    port (
        clk     : in std_logic;
        reset_n : in std_logic;

        -- Avalon
        as_address   : in std_logic_vector(1 downto 0);
        as_write     : in std_logic;
        as_writedata : in std_logic_vector(31 downto 0);

        -- WM8731 audio codec
        aud_clk12   : in std_logic; -- This clock MUST be at 12 MHz to ensure 48 KHz sample rate
        aud_daclrck : out std_logic;
        aud_dacdat  : out std_logic;

        -- Debug
        debug_daclrck : out std_logic;
        debug_dacdat  : out std_logic
    );
end entity sound_gen;
"""

osc_registers = [f"""-- registers for oscillator instance osc{i}
    signal osc{i}_note_step : unsigned({OSC_DEPTH - 1} downto 0);
    signal osc{i}_note      : std_logic_vector(31 downto 0);
    signal osc{i}_out       : signed({OSC_DEPTH - 1} downto 0);""" for i in range(0, N_OSC)]

osc_registers_resets = [f"""osc{i}_note      <= (others => '0');
            osc{i}_note_step <= to_unsigned(0, osc{i}_note_step'length);""" for i in range(0, N_OSC)]

osc_select = [f"""-- select osc{i}
                            osc{i}_note      <= as_writedata;
                            osc{i}_note_step <= linear_diff_result;""" for i in range(0, N_OSC)]

osc_instances = [f"""-- oscillator osc{i} instance
    osc{i} : osc port map(
        aud_clk12 => aud_clk12,
        sclk_en   => sclk_en,
        reset_n   => reset_n,
        reg_on    => reg_on,
        note_step => osc{i}_note_step,
        osc_out   => osc{i}_out
    );""" for i in range (0, N_OSC)]

mixer_osc = " + ".join([f"osc{i}_out" for i in range (0, N_OSC)])

architecture = f"""
architecture rtl of sound_gen is
    -- register map
    constant REG_START_OFFSET    : std_logic_vector(as_address'length - 1 downto 0) := "00";
    constant REG_STOP_OFFSET     : std_logic_vector(as_address'length - 1 downto 0) := "01";
    constant REG_MIDI_MSG_OFFSET : std_logic_vector(as_address'length - 1 downto 0) := "10";

    -- internal register
    signal reg_on : std_logic;

    -- slow clock at 48 KHz
    signal sclk_counter : integer range 0 to 255;
    signal sclk_en      : std_logic;

    -- sound transfer fsm
    type state_type is (Q_IDLE, Q_SEND);
    signal state               : state_type;
    signal sample_bits_counter : integer range 0 to 31;

    -- final audio sample (sample is mono, audio is stereo)
    signal audio  : std_logic_vector(31 downto 0);
    signal sample : signed(15 downto 0);

    -- linear diff lookup table
    signal linear_diff_result : unsigned({OSC_DEPTH - 1} downto 0);
    component linear_diff
        port (
            midi_note_code   : in std_logic_vector(7 downto 0);
            note_linear_diff : out unsigned({OSC_DEPTH - 1} downto 0)
        );
    end component linear_diff;

    -- oscillator component
    component osc
        port (
            aud_clk12 : in std_logic;
            sclk_en   : in std_logic;
            reset_n   : in std_logic;
            reg_on    : in std_logic;
            note_step : in unsigned({OSC_DEPTH - 1} downto 0);
            osc_out   : out signed({OSC_DEPTH - 1} downto 0)
        );
    end component osc;

    {"".join(osc_registers)}
begin
    -- instantiate linear diff computation
    linear_diff0 : linear_diff port map(
        midi_note_code   => as_writedata(15 downto 8),
        note_linear_diff => linear_diff_result
    );

    -- writes to the status registers on Avalon writes
    as_write_process : process (clk, reset_n)
    begin
        if reset_n = '0' then
            reg_on         <= '0';
            {"".join(osc_registers_resets)}

        elsif rising_edge(clk) then
            if as_write = '1' then
                case as_address is
                    when REG_START_OFFSET =>
                        reg_on <= '1';
                    when REG_STOP_OFFSET =>
                        reg_on <= '0';
                    when REG_MIDI_MSG_OFFSET =>
                        -- save note_step if MIDI event is note on (0x90)
                        -- TODO: implement OSC selection
                        if to_integer(unsigned(as_writedata(23 downto 16))) = 16#90# then
                            {"".join(osc_select)}
                        end if;
                    when others =>
                        null;
                end case;
            end if;
        end if;
    end process as_write_process;

    -- generates the 48 KHz pulse slow "clock"
    sclk_gen : process (aud_clk12, reset_n)
    begin
        if reset_n = '0' then
            sclk_counter  <= 0;
            sclk_en       <= '0';
            aud_daclrck   <= '0';
            debug_daclrck <= '0';

        elsif falling_edge(aud_clk12) then
            aud_daclrck   <= sclk_en and reg_on;
            debug_daclrck <= sclk_en and reg_on;

            if (sclk_counter < 250) then
                sclk_counter <= sclk_counter + 1;
                sclk_en      <= '0';
            else
                sclk_counter <= 0;
                sclk_en      <= '1';
            end if;
        end if;
    end process sclk_gen;

    -- transfer sound to audio output through DAC
    transfer_fsm : process (aud_clk12, reset_n)
    begin
        if reset_n = '0' then
            aud_dacdat          <= '0';
            debug_dacdat        <= '0';
            sample_bits_counter <= 0;
            state               <= Q_IDLE;

        elsif falling_edge(aud_clk12) then
            case state is
                when Q_IDLE =>
                    if reg_on = '1' and sclk_en = '1' then
                        sample_bits_counter <= 31;
                        state               <= Q_SEND;
                    end if;

                when Q_SEND =>
                    if sample_bits_counter > 0 then
                        sample_bits_counter <= sample_bits_counter - 1;
                    elsif sample_bits_counter = 0 then
                        state <= Q_IDLE;
                    end if;
                    aud_dacdat   <= audio(sample_bits_counter);
                    debug_dacdat <= audio(sample_bits_counter);

                when others =>
                    null;
            end case;
        end if;
    end process transfer_fsm;

    {"".join(osc_instances)}

    -- mixes sound from generators into the final audio sample
    mixer : process (aud_clk12, reset_n)
    begin
        if reset_n = '0' then
            audio  <= (others => '0');
            sample <= to_signed(0, sample'length);

        elsif falling_edge(aud_clk12) then
            if reg_on = '1' and sclk_en = '1' then
                sample <= {mixer_osc};

                -- mix samples in mono: left and right channels get assigned the sample
                audio(31 downto 16) <= std_logic_vector(sample);
                audio(15 downto 0)  <= std_logic_vector(sample);
            end if;
        end if;
    end process mixer;

end architecture rtl;

-- DO NOT CHANGE THIS FILE DIRECTLY, INSTEAD CHANGE sound_gen.py!"""

vhdl = header + entity + architecture

FILENAME = "sound_gen.vhd"
with open(FILENAME, "w") as file:
    file.write(vhdl)
    print(f"Wrote generated sound_gen component to {FILENAME}")