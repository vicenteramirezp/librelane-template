current_design spm_chip_sg13g2
set_units -time ns -resistance kOhm -capacitance pF -voltage V -current uA

# Set a higher limits than in lib
set_max_fanout 8 [current_design]
set_max_capacitance 0.5 [current_design]
set_max_transition 3 [current_design]
set_max_area 0

set_ideal_network [get_pins sg13g2_IOPad_io_clock]
create_clock [get_pins sg13g2_IOPad_io_clock] -name clk_core -period 20.0 -waveform {0 10}
set_clock_uncertainty 0.15 [get_clocks clk_core]
set_clock_transition 0.25 [get_clocks clk_core]
