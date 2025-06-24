set start_timestamp [clock format [clock seconds] -format %y%m%d_%H%M]
set_multi_cpu_usage -local_cpu 16
set_db max_cpus_per_server 16
set_db super_thread_servers "localhost"

# Set up libraries
set_db lib_search_path $LIB_SEARCH_PATH
set_db library ${LIB_NAME}
#set_db lef_library ${LEF_FILE}

# General settings
set_db / .information_level 9
set_db / .hdl_track_filename_row_col 1
set_db / .source_verbose true
set_db / .hdl_error_on_blackbox true 
set_db / .hdl_error_on_latch true
set_db / .hdl_vhdl_read_version 2008
set_db / .hdl_enable_real_support true
set_db / .optimize_constant_0_flops false
set_db / .delete_unloaded_insts false
set_db / .delete_unloaded_seqs false
set_db / .auto_ungroup none
set_db / .use_scan_seqs_for_non_dft false


# Read RTL files
source ../syn/scr/bender_hdl_import.tcl

elaborate ${TOP_NAME}
read_sdc ${SYN_DIR}/constraints.sdc
#read_def ${SYN_DIR}/floorplan.def

# check if environment variable  DEBUG is set
if {[info exists ::env(DEBUG)]} {
    if {${::env(DEBUG)} == "1"} {
        return
    }
}


syn_generic
syn_map
syn_opt


write_hdl > "${OUT_DIR}/${PREFIX}${TOP_NAME}_${start_timestamp}${SUFFIX}.v"
write_sdc > "${OUT_DIR}/${PREFIX}${TOP_NAME}_${start_timestamp}${SUFFIX}.sdc"
write_sdf > "${OUT_DIR}/${PREFIX}${TOP_NAME}_${start_timestamp}${SUFFIX}.sdf"
write_db    "${OUT_DIR}/${PREFIX}${TOP_NAME}_${start_timestamp}${SUFFIX}.gen"
report_timing > "${REPORT_DIR}/${PREFIX}${TOP_NAME}_${start_timestamp}_timing${SUFFIX}.txt"
report_power  > "${REPORT_DIR}/${PREFIX}${TOP_NAME}_${start_timestamp}_power${SUFFIX}.txt"
report_area > "${REPORT_DIR}/${PREFIX}${TOP_NAME}_${start_timestamp}_area${SUFFIX}.txt"
