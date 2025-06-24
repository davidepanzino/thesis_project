source ../phy/scr/global_variables.tcl

cd ../phy/db/part/FSM.enc.dat/
read_db .

place_design 
ccopt_design
route_design

write_db ./pnr/

write_ilm

#same for all partitions, just change the directory


