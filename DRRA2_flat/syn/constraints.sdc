#create_clock -period 0.277 -name clk [get_ports clk]
create_clock -period 1.0 -name clk [get_ports clk]
set_false_path -from [get_ports rst_n]

set_driving_cell -lib_cell INVD4BWP30P140 [all_inputs]
set_load -pin_load [load_of INVD4BWP30P140/I] [all_outputs]


