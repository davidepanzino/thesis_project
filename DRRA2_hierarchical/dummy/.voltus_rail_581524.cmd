# Voltus_rail Command File

#Result directory
setvar output_directory_name ./

#Distributed processing setting
setvar max_cpu 8
setvar nga_enabled true
nga_dp_hosts max_cpu=8 mode=local time_out=3600

#Layout Files
layout_file /home/finazzi/Desktop/12april_power/dummy/innovus_temp_581524_bee9174f-1352-4f2a-9ace-bdd69a603ad8_4f5323946af0_finazzi_pD9TKP/eps_out_581524.def.gz

#Cell Library
cell_library techonly.cl
setvar tesla_accuracy_mode xd
use_cell_view type standard fast
use_cell_view type macro fast
use_cell_view type io fast
use_cell_view type powergate fast
setvar unified_power_switch_flow true
setvar power_up_fast_mode true
setvar report_msmv_format true
setvar compress_powergrid_database false
setvar hierarchy_char /
setvar report_shorts true
setvar use_cell_id true
nga_setvar nga_enable_new_transient_analysis true
setvar enable_smx true
setvar extract_oci_flow true
setvar ignore_shorts false
setvar enable_manufacturing_effects false
setvar cluster_via1_ports true
setvar ignore_fillers true
setvar ignore_decaps true
setvar vsrc_search_distance 50
setvar report_via_current_direction false
setvar em_redundancy_via_current_threshold 0.0
setvar gif_zoom_topcell_diearea false
setvar keep_log false
setvar enable_report_db true
setvar eiv_report_auto true
nga_setvar nga_current_redistribution true
setvar mge_load_static_pti false
nga_setvar nga_protect_rail_simulation_time false
setvar halt_on_net_with_no_cell_connections false
setvar enable_scheduler true
layout_file -lef /opt/pdk/tsmc28/CMOS/util/PRTF_EDI_28nm_Cad_V19_1a/tsmcn28_9lm5X1Y1Z1UUTRDL.tlef
layout_file -lef /opt/pdk/tsmc28/CMOS/HPC+/stclib/9-track/tcbn28hpcplusbwp30p140-set/tcbn28hpcplusbwp30p140_190a_FE/TSMCHOME/digital/Back_End/lef/tcbn28hpcplusbwp30p140_110a/lef/tcbn28hpcplusbwp30p140.lef
layout_file -lef /opt/pdk/tsmc28/SRAM/macros/tsdn28hpcpuhdb64x128m4mwa_170a/LEF/tsdn28hpcpuhdb64x128m4mwa_170a.lef
layout_file -lef /opt/pdk/tsmc28/CMOS/HPC+/IO1.8V/iolib/STAGGERED/tphn28hpcpgv18_170d_FE/TSMCHOME/digital/Back_End/lef/tphn28hpcpgv18_110a/mt_2/8lm/lef/tphn28hpcpgv18_8lm.lef
layout_file -lef /opt/pdk/tsmc28/iolib/tpbn28v_160a_FE/TSMCHOME/digital/Back_End/lef/tpbn28v_160a/cup/9m/9M_5X1Y1Z1U/lef/tpbn28v_9lm.lef
net_voltage VDD 0.81 0.1
power_pin_supply_tolerance 0.567 1.053 net=VDD
power_domain CORE pwrnet="VDD" gndnet="VSS"
current_data_file ./power.rpt
power_pin VDD pad=/home/finazzi/Desktop/12april_power/dummy/../phy/scr/vdd_pads.padcell auto_vsrc_creation=true
power_pin VDD pad=/home/finazzi/Desktop/12april_power/dummy/../phy/scr/vdd_pads.padcell
power_pin VDD pad=/home/finazzi/Desktop/12april_power/dummy/VDD.padcell
power_pin VDD pad=/home/finazzi/Desktop/12april_power/dummy/../phy/scr/vdd_pads.padcell
power_pin VDD pad=/home/finazzi/Desktop/12april_power/dummy/../phy/scr/vdd_pads.padcell
power_pin VDD pad=/home/finazzi/Desktop/12april_power/dummy/../phy/scr/vdd_pads.padcell
power_pin VDD pad=/home/finazzi/Desktop/12april_power/dummy/../phy/scr/vdd_pads.pp
power_pin VDD pad=/home/finazzi/Desktop/12april_power/dummy/../phy/scr/vdd_pads.padcell auto_vsrc_creation=true
power_pin VDD pad=/home/finazzi/Desktop/12april_power/dummy/../phy/scr/vdd_pads.padcell
power_pin VDD pad=/home/finazzi/Desktop/12april_power/dummy/VDD.padcell
power_pin VDD pad=/home/finazzi/Desktop/12april_power/dummy/../phy/scr/vdd_pads.padcell
power_pin VDD pad=/home/finazzi/Desktop/12april_power/dummy/../phy/scr/vdd_pads.padcell
power_pin VDD pad=/home/finazzi/Desktop/12april_power/dummy/../phy/scr/vdd_pads.padcell
power_pin VDD pad=/home/finazzi/Desktop/12april_power/dummy/../phy/scr/vdd_pads.pp
power_pin VDD pad=/home/finazzi/Desktop/12april_power/dummy/../phy/scr/vdd_pads.padcell auto_vsrc_creation=true
power_pin VDD pad=/home/finazzi/Desktop/12april_power/dummy/../phy/scr/vdd_pads.padcell
power_pin VDD pad=/home/finazzi/Desktop/12april_power/dummy/VDD.padcell
power_pin VDD pad=/home/finazzi/Desktop/12april_power/dummy/../phy/scr/vdd_pads.padcell
power_pin VDD pad=/home/finazzi/Desktop/12april_power/dummy/../phy/scr/vdd_pads.padcell
power_pin VDD pad=/home/finazzi/Desktop/12april_power/dummy/../phy/scr/vdd_pads.padcell
power_pin VDD pad=/home/finazzi/Desktop/12april_power/dummy/../phy/scr/vdd_pads.pp
power_pin VDD pad=/home/finazzi/Desktop/12april_power/dummy/../phy/scr/vdd_pads.padcell auto_vsrc_creation=true
power_pin VDD pad=/home/finazzi/Desktop/12april_power/dummy/../phy/scr/vdd_pads.padcell
power_pin VDD pad=/home/finazzi/Desktop/12april_power/dummy/VDD.padcell
power_pin VDD pad=/home/finazzi/Desktop/12april_power/dummy/../phy/scr/vdd_pads.padcell
power_pin VDD pad=/home/finazzi/Desktop/12april_power/dummy/../phy/scr/vdd_pads.padcell
power_pin VDD pad=/home/finazzi/Desktop/12april_power/dummy/../phy/scr/vdd_pads.padcell
power_pin VDD pad=/home/finazzi/Desktop/12april_power/dummy/../phy/scr/vdd_pads.pp
power_pin VDD pad=/home/finazzi/Desktop/12april_power/dummy/../phy/scr/vdd_pads.padcell auto_vsrc_creation=true
power_pin VDD pad=/home/finazzi/Desktop/12april_power/dummy/../phy/scr/vdd_pads.padcell
power_pin VDD pad=/home/finazzi/Desktop/12april_power/dummy/VDD.padcell
power_pin VDD pad=/home/finazzi/Desktop/12april_power/dummy/../phy/scr/vdd_pads.padcell
power_pin VDD pad=/home/finazzi/Desktop/12april_power/dummy/../phy/scr/vdd_pads.padcell
power_pin VDD pad=/home/finazzi/Desktop/12april_power/dummy/../phy/scr/vdd_pads.padcell
power_pin VDD pad=/home/finazzi/Desktop/12april_power/dummy/../phy/scr/vdd_pads.pp
power_pin VDD pad=/home/finazzi/Desktop/12april_power/dummy/../phy/scr/vdd_pads.padcell auto_vsrc_creation=true
power_pin VDD pad=/home/finazzi/Desktop/12april_power/dummy/../phy/scr/vdd_pads.padcell
power_pin VDD pad=/home/finazzi/Desktop/12april_power/dummy/VDD.padcell
power_pin VDD pad=/home/finazzi/Desktop/12april_power/dummy/../phy/scr/vdd_pads.padcell
power_pin VDD pad=/home/finazzi/Desktop/12april_power/dummy/../phy/scr/vdd_pads.padcell
power_pin VDD pad=/home/finazzi/Desktop/12april_power/dummy/../phy/scr/vdd_pads.padcell
power_pin VDD pad=/home/finazzi/Desktop/12april_power/dummy/../phy/scr/vdd_pads.pp
power_pin VDD pad=/home/finazzi/Desktop/12april_power/dummy/../phy/scr/vdd_pads.padcell auto_vsrc_creation=true
power_pin VDD pad=/home/finazzi/Desktop/12april_power/dummy/../phy/scr/vdd_pads.padcell
power_pin VDD pad=/home/finazzi/Desktop/12april_power/dummy/VDD.padcell
power_pin VDD pad=/home/finazzi/Desktop/12april_power/dummy/../phy/scr/vdd_pads.padcell
power_pin VDD pad=/home/finazzi/Desktop/12april_power/dummy/../phy/scr/vdd_pads.padcell
power_pin VDD pad=/home/finazzi/Desktop/12april_power/dummy/../phy/scr/vdd_pads.padcell
power_pin VDD pad=/home/finazzi/Desktop/12april_power/dummy/../phy/scr/vdd_pads.pp
analyze VDD 0.81 avg 0.1 ir tc rc iv rv vc pv pi
