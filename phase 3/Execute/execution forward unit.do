vsim -gui work.efu
# vsim -gui work.efu 
# Start time: 04:34:59 on May 10,2020
# Loading std.standard
# Loading std.textio(body)
# Loading ieee.std_logic_1164(body)
# Loading ieee.numeric_bit(body)
# Loading ieee.numeric_bit_unsigned(body)
# Loading ieee.numeric_std(body)
# Loading work.efu(behavioral)
add wave -position insertpoint sim:/efu/*
# ** Warning: (vsim-WLF-5000) WLF file currently in use: vsim.wlf
#           File in use by: ESLAM ELECTRONICS  Hostname: DESKTOP-EKFC7R1  ProcessID: 6360
#           Attempting to use alternate WLF file "./wlftd54h7q".
# ** Warning: (vsim-WLF-5001) Could not open WLF file: vsim.wlf
#           Using alternate file: ./wlftd54h7q
force -freeze sim:/efu/clk 1 0, 0 {50 ps} -r 100
force -freeze sim:/efu/Rsrc1 000 0
force -freeze sim:/efu/Rsrc2 111 0
force -freeze sim:/efu/Rdst_exec 001 0
force -freeze sim:/efu/Rdst_mem 010 0
force -freeze sim:/efu/wb_mem 1 0
force -freeze sim:/efu/wb_exec 1 0
run
run
force -freeze sim:/efu/Rdst_exec 111 0
run
run
force -freeze sim:/efu/Rdst_mem 000 0
run
run
force -freeze sim:/efu/Rdst_exec 000 0
run
run
force -freeze sim:/efu/Rdst_exec 111 0
run
run
force -freeze sim:/efu/Rdst_mem 111 0
force -freeze sim:/efu/Rdst_mem 000 0
force -freeze sim:/efu/Rsrc1 010 0
run
run
force -freeze sim:/efu/wb_mem 0 0
force -freeze sim:/efu/Rdst_mem 010 0
run
run
run
force -freeze sim:/efu/Rdst_mem 010 0
force -freeze sim:/efu/wb_mem 1 0
run
run
force -freeze sim:/efu/wb_exec 0 0
run
run
force -freeze sim:/efu/wb_mem 0 0
run
run

