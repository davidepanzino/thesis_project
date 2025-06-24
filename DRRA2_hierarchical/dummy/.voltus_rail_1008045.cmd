# Voltus_rail Command File

#Result directory
setvar output_directory_name ../../../dummy/

#Distributed processing setting
setvar max_cpu 1
setvar nga_enabled true
nga_dp_hosts max_cpu=1 mode=local time_out=3600

#Layout Files
layout_file /home/finazzi/Desktop/15_april_power/dummy/innovus_temp_1008045_78d611f4-64fe-438f-a5af-e05578755105_4f5323946af0_finazzi_7PUI9d/eps_out_1008045.def.gz

#Cell Library
cell_library ../../../dummy/techonly.cl
setvar tesla_accuracy_mode hd
use_cell_view type standard fast
use_cell_view type macro fast_accurate
use_cell_view type io fast_accurate
setvar unified_power_switch_flow true
setvar power_up_fast_mode true
setvar report_msmv_format true
setvar compress_powergrid_database false
setvar operation_mode signoff_verification
setvar hierarchy_char /
setvar report_shorts true
setvar use_cell_id true
nga_setvar nga_enable_new_transient_analysis true
setvar enable_smx true
setvar extract_oci_flow true
setvar ignore_shorts false
setvar enable_manufacturing_effects true
setvar cluster_via_size 4
setvar cluster_via1_ports true
setvar ignore_fillers true
setvar ignore_decaps true
setvar vsrc_search_distance 50
setvar report_via_current_direction true
setvar em_redundancy_via_current_threshold 0.0
setvar gif_zoom_topcell_diearea false
setvar keep_log false
setvar enable_report_db true
setvar eiv_report_auto true
nga_setvar nga_current_redistribution true
setvar mge_load_static_pti false
nga_setvar nga_protect_rail_simulation_time false
layout_file -lef /home/finazzi/Desktop/15_april_power/phy/db/fabric.dat/libs/lef/tsmcn28_9lm5X1Y1Z1UUTRDL.tlef
layout_file -lef /home/finazzi/Desktop/15_april_power/phy/db/fabric.dat/libs/lef/tcbn28hpcplusbwp30p140.lef
layout_file -lef /home/finazzi/Desktop/15_april_power/phy/db/fabric.dat/libs/lef/tsdn28hpcpuhdb64x128m4mwa_170a.lef
layout_file -lef /home/finazzi/Desktop/15_april_power/phy/db/fabric.dat/libs/lef/tphn28hpcpgv18_8lm.lef
layout_file -lef /home/finazzi/Desktop/15_april_power/phy/db/fabric.dat/libs/lef/tpbn28v_9lm.lef
net_voltage VDD 1 0.1
power_pin_supply_tolerance 0.7 1.3 net=VDD
net_voltage VSS 0 0.1
power_pin_supply_tolerance 0 0.3 net=VSS
power_domain CORE_PG pwrnet="VDD" gndnet="VSS"
current_data_file ../../../dummy/power/static_VDD.ptiavg
current_data_file ../../../dummy/power/static_VSS.ptiavg
power_pin VDD file=/home/finazzi/Desktop/15_april_power/phy/db/fabric.dat/./power/vdd_sources.pp
power_pin VDD file=/home/finazzi/Desktop/15_april_power/phy/db/fabric.dat/../../../dummy/power/vdd_sources.pp
power_pin VSS file=/home/finazzi/Desktop/15_april_power/phy/db/fabric.dat/./power/vss_sources.pp
power_pin VSS file=/home/finazzi/Desktop/15_april_power/phy/db/fabric.dat/../../../dummy/power/vss_sources.pp
power_pin VDD file=/home/finazzi/Desktop/15_april_power/phy/db/fabric.dat/./power/vdd_sources.pp
power_pin VDD file=/home/finazzi/Desktop/15_april_power/phy/db/fabric.dat/../../../dummy/power/vdd_sources.pp
power_pin VSS file=/home/finazzi/Desktop/15_april_power/phy/db/fabric.dat/./power/vss_sources.pp
power_pin VSS file=/home/finazzi/Desktop/15_april_power/phy/db/fabric.dat/../../../dummy/power/vss_sources.pp
analyze CORE_PG 1 avg 0.1 ir tc rc iv rv vc pv pi reff dreff
