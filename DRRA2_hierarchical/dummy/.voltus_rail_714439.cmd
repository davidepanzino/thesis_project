# Voltus_rail Command File

#Result directory
setvar output_directory_name ./

#Distributed processing setting
setvar max_cpu 8
setvar nga_enabled true
nga_dp_hosts max_cpu=8 mode=local time_out=3600

#Layout Files
layout_file /home/finazzi/Desktop/12april_power/dummy/innovus_temp_714439_4dc79762-a182-401c-9262-8c3f26a0829c_4f5323946af0_finazzi_uLWwFh/eps_out_714439.def.gz

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
# EPS signoff mode with ignoring shorts utilizes voltus early mode with DFM effects
setvar operation_mode early_verification
setvar enable_dfmeffects_in_early true
setvar hierarchy_char /
setvar report_shorts true
setvar use_cell_id true
nga_setvar nga_enable_new_transient_analysis true
setvar enable_smx true
setvar ignore_shorts true
setvar enable_manufacturing_effects true
setvar enable_dfmeffects_in_early true
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
layout_file -lef /opt/pdk/tsmc28/CMOS/HPC+/IO1.8V/iolib/STAGGERED/tphn28hpcpgv18_170d_FE/TSMCHOME/digital/Back_End/lef/tphn28hpcpgv18_110a/mt_2/8lm/lef/tphn28hpcpgv18_8lm.lef
layout_file -lef /opt/pdk/tsmc28/iolib/tpbn28v_160a_FE/TSMCHOME/digital/Back_End/lef/tpbn28v_160a/cup/9m/9M_5X1Y1Z1U/lef/tpbn28v_9lm.lef
net_voltage VDD 1.2 1.08
power_pin_supply_tolerance 0.84 1.56 net=VDD
current_data_file ./static_VDD.ptiavg
power_pin VDD file=/home/finazzi/Desktop/12april_power/dummy/./vdd_sources.pp
analyze VDD 1.2 avg 1.08 ir tc rc iv rv vc pv pi reff dreff
