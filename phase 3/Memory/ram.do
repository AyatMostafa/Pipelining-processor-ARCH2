vsim -gui work.rampipelined
# vsim -gui work.rampipelined 
# Start time: 18:00:20 on May 04,2020
# Loading std.standard
# Loading std.textio(body)
# Loading ieee.std_logic_1164(body)
# Loading ieee.numeric_std(body)
# Loading work.rampipelined(sync_ram_a)
add wave -position insertpoint sim:/rampipelined/*
# ** Warning: (vsim-WLF-5000) WLF file currently in use: vsim.wlf
#           File in use by: ESLAM ELECTRONICS  Hostname: DESKTOP-EKFC7R1  ProcessID: 6360
#           Attempting to use alternate WLF file "./wlfthb99zh".
# ** Warning: (vsim-WLF-5001) Could not open WLF file: vsim.wlf
#           Using alternate file: ./wlfthb99zh
force -freeze sim:/rampipelined/we 0 0
force -freeze sim:/rampipelined/re 1 0
force -freeze sim:/rampipelined/address 10 0
force -freeze sim:/rampipelined/datain UUUUUUUUUUUUUUUU 0
force -freeze sim:/rampipelined/clk 1 0, 0 {50 ps} -r 100
run
run
run
force -freeze sim:/rampipelined/we 1 0
force -freeze sim:/rampipelined/re 0 0
force -freeze sim:/rampipelined/datain 1010101010101010 0
# Compile of RamPipelined.vhd was successful.
run
run
force -freeze sim:/rampipelined/we 0 0
force -freeze sim:/rampipelined/re 1 0
force -freeze sim:/rampipelined/datain 0000000000000000 0
run
run
force -freeze sim:/rampipelined/we 1 0
force -freeze sim:/rampipelined/re 0 0
run
force -freeze sim:/rampipelined/we 0 0
force -freeze sim:/rampipelined/re 1 0
run
run