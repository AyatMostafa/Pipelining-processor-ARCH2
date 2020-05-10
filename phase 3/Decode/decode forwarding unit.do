vsim -gui work.dfu
# vsim -gui work.dfu 
# Start time: 05:15:44 on May 10,2020
# Loading std.standard
# Loading std.textio(body)
# Loading ieee.std_logic_1164(body)
# Loading ieee.numeric_bit(body)
# Loading ieee.numeric_bit_unsigned(body)
# Loading ieee.numeric_std(body)
# Loading work.dfu(behavioral)
add wave -position insertpoint sim:/dfu/*
# ** Warning: (vsim-WLF-5000) WLF file currently in use: vsim.wlf
#           File in use by: ESLAM ELECTRONICS  Hostname: DESKTOP-EKFC7R1  ProcessID: 6360
#           Attempting to use alternate WLF file "./wlft2qm7ev".
# ** Warning: (vsim-WLF-5001) Could not open WLF file: vsim.wlf
#           Using alternate file: ./wlft2qm7ev
force -freeze sim:/dfu/clk 1 0, 0 {50 ps} -r 100
force -freeze sim:/dfu/Rdest_JZ 000 0
force -freeze sim:/dfu/Rdst_exec 111 0
force -freeze sim:/dfu/Rdst_mem 010 0
force -freeze sim:/dfu/wb_mem 1 0
force -freeze sim:/dfu/wb_exec 1 0
run
run
force -freeze sim:/dfu/Rdst_exec 000 0
run
run
force -freeze sim:/dfu/Rdst_exec 101 0
run
run
force -freeze sim:/dfu/Rdst_mem 000 0
# Compile of decode FU.vhd was successful.
run
run
force -freeze sim:/dfu/Rdst_exec 000 0
force -freeze sim:/dfu/Rdst_mem 111 0
force -freeze sim:/dfu/wb_mem 0 0
force -freeze sim:/dfu/wb_exec 0 0
force -freeze sim:/dfu/wb_mem 1 0
run
run
force -freeze sim:/dfu/Rdst_mem 00 0
# Value length (2) does not equal array index length (3).
# 
# ** Error: (vsim-4011) Invalid force value: 00 0.
# 
force -freeze sim:/dfu/Rdst_mem 000 0
force -freeze sim:/dfu/wb_mem 0 0
run
run
force -freeze sim:/dfu/Rdst_mem 000 0
force -freeze sim:/dfu/wb_mem 1 0
run
run

