# Voltus_rail Command File

#Result directory
setvar output_directory_name ./

#Distributed processing setting
setvar max_cpu 8
setvar nga_enabled true
nga_dp_hosts max_cpu=8 mode=local time_out=3600

#Layout Files
layout_file /home/finazzi/Desktop/9_june/dummy/innovus_temp_1924669_195cebab-d33c-4650-94f0-9c34bc8a1f92_4f5323946af0_finazzi_fyk7sH/eps_out_1924669.def.gz

#Cell Library
cell_library ./techonly.cl
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
layout_file -lef /opt/pdk/tsmc28/CMOS/util/PRTF_EDI_28nm_Cad_V19_1a/tsmcn28_9lm5X1Y1Z1UUTRDL.tlef
layout_file -lef /opt/pdk/tsmc28/CMOS/HPC+/stclib/9-track/tcbn28hpcplusbwp30p140-set/tcbn28hpcplusbwp30p140_190a_FE/TSMCHOME/digital/Back_End/lef/tcbn28hpcplusbwp30p140_110a/lef/tcbn28hpcplusbwp30p140.lef
layout_file -lef /opt/pdk/tsmc28/SRAM/macros/tsdn28hpcpuhdb64x128m4mwa_170a/LEF/tsdn28hpcpuhdb64x128m4mwa_170a.lef
layout_file -lef /opt/pdk/tsmc28/SRAM/macros/tsdn28hpcpuhdb64x64m4mwa_170a/LEF/tsdn28hpcpuhdb64x64m4mwa_170a.lef
layout_file -lef /opt/pdk/tsmc28/SRAM/macros/ts6n28hpcphvta16x16m2fwbso_200b/LEF/ts6n28hpcphvta16x16m2fwbso_200b.lef
layout_file -lef /opt/pdk/tsmc28/SRAM/macros/ts6n28hpcphvta16x32m2fwbso_200b/LEF/ts6n28hpcphvta16x32m2fwbso_200b.lef
layout_file -lef /opt/pdk/tsmc28/CMOS/HPC+/IO1.8V/iolib/STAGGERED/tphn28hpcpgv18_170d_FE/TSMCHOME/digital/Back_End/lef/tphn28hpcpgv18_110a/mt_2/8lm/lef/tphn28hpcpgv18_8lm.lef
layout_file -lef /opt/pdk/tsmc28/iolib/tpbn28v_160a_FE/TSMCHOME/digital/Back_End/lef/tpbn28v_160a/cup/9m/9M_5X1Y1Z1U/lef/tpbn28v_9lm.lef
net_voltage VDD 0.9 0.1
power_pin_supply_tolerance 0.63 1.17 net=VDD
net_voltage VSS 0 0.1
power_pin_supply_tolerance 0 0.3 net=VSS
power_domain CORE_PG pwrnet="VDD" gndnet="VSS"
current_data_file ./power/static_VDD.ptiavg
current_data_file ./power/static_VSS.ptiavg
power_pin VDD file=/home/finazzi/Desktop/9_june/dummy/../phy/scr/vdd_sources.pp
power_pin VSS file=/home/finazzi/Desktop/9_june/dummy/../phy/scr/vss_sources.pp
analyze CORE_PG 0.9 avg 0.1 ir tc rc iv rv vc pv pi reff dreff
