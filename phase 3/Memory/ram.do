vsim -gui work.rampipelined
# vsim -gui work.rampipelined 
# Start time: 01:06:01 on May 05,2020
# Loading std.standard
# Loading std.textio(body)
# Loading ieee.std_logic_1164(body)
# Loading ieee.numeric_std(body)
# Loading work.rampipelined(sync_ram_a)
add wave -position insertpoint sim:/rampipelined/*
# ** Warning: (vsim-WLF-5000) WLF file currently in use: vsim.wlf
#           File in use by: ESLAM ELECTRONICS  Hostname: DESKTOP-EKFC7R1  ProcessID: 6360
#           Attempting to use alternate WLF file "./wlft0hcswn".
# ** Warning: (vsim-WLF-5001) Could not open WLF file: vsim.wlf
#           Using alternate file: ./wlft0hcswn
force -freeze sim:/rampipelined/clk 1 0, 0 {50 ps} -r 100
force -freeze sim:/rampipelined/we 0 0
force -freeze sim:/rampipelined/re 1 0
force -freeze sim:/rampipelined/reset 0 0
force -freeze sim:/rampipelined/interrupt 0 0
force -freeze sim:/rampipelined/address 10 0
force -freeze sim:/rampipelined/datain 1111111111111111 0
run
run
# WARNING: No extended dataflow license exists
force -freeze sim:/rampipelined/we 1 0
force -freeze sim:/rampipelined/re 0 0
run
force -freeze sim:/rampipelined/we 0 0
force -freeze sim:/rampipelined/re 1 0
run
run
force -freeze sim:/rampipelined/interrupt 1 0
run
run
force -freeze sim:/rampipelined/reset 1 0
run
run

