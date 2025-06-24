source ../phy/scr/global_variables.tcl

set_multi_cpu_usage -local_cpu ${NUM_CPUS} -cpu_per_remote_host 1 -remote_host 0 -keep_license true
set_distributed_hosts -local

set_db init_power_nets {VDD VDDPST}
set_db init_ground_nets {VSS VSSPST}

read_mmmc ${MMMC_FILE}
read_physical -lef ${LEF_FILE}
read_netlist ${NETLIST_FILE}
init_design

set_preference MinFPModuleSize 0
set_io_flow_flag 0

set_db design_process_node ${PROCESS_NODE}
set_db timing_analysis_type ocv
set_db timing_analysis_cppr both
