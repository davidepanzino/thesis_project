##########################################################################
# Power Rail Analysis Script for DRRA2 Layout
# Author: Davide Finazzi
# Project: Backend Automation for DRRA2 - Automating Floorplanning and Power Planning in the SiLago Framework
# Tool: Cadence Innovus
##########################################################################

# Description:
# ------------
# This script performs full static power and rail analysis on the DRRA2 layout 
# using Cadence Innovus. It evaluates IR drop and current density across the 
# power grid by leveraging PTI current files and annotated voltage source pads.
#
# The script includes:
#   - PG net definition and voltage assignment
#   - Static power analysis setup and PTI file generation
#   - Voltage source pad loading from .pp files
#   - Rail extraction and parasitic model configuration
#   - Domain-based IR drop report generation

# Inputs:
# -------
#   - VDD/VSS source pads: ../phy/scr/vdd_sources.pp and vss_sources.pp
#   - Static power results: ./power/static_VDD.ptiavg, ./power/static_VSS.ptiavg
#   - QRC tech file: <your_foundry_qrcTechFile>
#
# Outputs:
# --------
#   - power/fabric.rpt                → Power report
#   - CORE_PG_25C_avg_1/              → Rail analysis directory
#   - ./power/power.db                → Power data for further analysis
#   - Voltage waveform and current reports inside rail analysis directory

# Notes:
# ------
# - Rail analysis might fail when run directly from the terminal.
#    If so, set it up through the GUI commands.
#
# - You must generate VDD/VSS pad files using the power pad generation script 
#    before running this.

##########################################################################

set_pg_nets -net VDD -voltage 0.9 -threshold 0.1 
set_pg_nets -net VSS -voltage 0.0 -threshold 0.1 

#power analysis
mkdir power
reset_db -category power
set_power_analysis_mode -method static -corner max -create_binary_db true -write_static_currents true -honor_negative_energy true -ignore_control_signals true
set_db power_method static ; set_db power_corner max ; set_db power_write_db true ; set_db power_write_static_currents true ; set_db power_honor_negative_energy true ; set_db power_ignore_control_signals true
set_power_output_dir -reset
set_power_output_dir power
set_default_switching_activity -reset
set_default_switching_activity -input_activity 0.2 -period 1.0ns
read_activity_file -reset
set_power -reset
set_dynamic_power_simulation -reset
report_power -rail_analysis_format VS -out_file power/fabric.rpt

#rail analysis
set_power_data {./power/static_VDD.ptiavg ./power/static_VSS.ptiavg} -format current

set_power_pads -reset
set_power_pads -format xy -file ../phy/scr/vdd_sources.pp -net VDD
set_power_pads -format xy -file ../phy/scr/vss_sources.pp -net VSS

set_pg_library_mode \
    -extraction_tech_file {/opt/pdk/tsmc28/QRC/RC_QRC_crn28hpc+_1p09m+ut-alrdl_5x1y1z1u_rcworst/qrcTechFile} \
    -cell_type techonly \
    -power_pins { VDD 0.9 } \
    -ground_pins { VSS } \
    -temperature 25

write_pg_library

set_rail_analysis_domain \
    -domain_name CORE_PG \
    -power_nets {VDD} \
    -ground_nets {VSS} \
    -threshold 0.1

set_rail_analysis_config \
    -method static \
    -accuracy hd \
    -power_grid_libraries {./techonly.cl} \
    -voltage_source_search_distance 50 \
    -enable_rlrp_analysis true \
    -enable_reff_analysis true \
    -report_shorts true \
    -report_via_current_direction true \
    -write_voltage_waveforms true

report_rail -type domain -output_dir ./ CORE_PG

read_power_rail_results -power_db ./power/power.db -rail_directory CORE_PG_25C_avg_1/





