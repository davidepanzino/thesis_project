################################################################################
# Genus logic synthesis script
################################################################################
#
# This script is meant to be executed with the following directory structure
#
# project_top_folder
# |
# |- db: store output data like mapped designs or physical files like GDSII
# |
# |- phy: physical synthesis material (scripts, pins, etc)
# |
# |- rtl: contains rtl code for the design, it should also contain a
# |       hierarchy.txt file with the all the files that compose the design
# |
# |- syn: logic synthesis material (this script, SDC constraints, etc)
# |
# |- sim: simulation stuff like waveforms, reports, coverage etc.
# |
# |- tb: testbenches for the rtl code
#
#
# The standard way of executing the is from the project_top_folder
# with the following command
#
# $ genus -files ./syn/genus_synthesis.tcl
#
# Additionally it should be possible to do
#
# $ make syn
#
# If the standard Makefile is present in the project directory
################################################################################

# if we are in the exe directory, go back to root

# Synthesis controls

################################################################################
# Synthesis process
# From this point the script should not require to be modified 
################################################################################

# Technology variables 


# Directories for output material
set REPORT_DIR  ../syn/rpt;      # synthesis reports: timing, area, etc.
set OUT_DIR     ../syn/db;       # output files: netlist, sdf sdc etc.
set SOURCE_DIR  ../rtl;          # rtl code that should be synthesised
set SYN_DIR     ../syn;          # synthesis directory, synthesis scripts constraints etc.
set SCR_DIR     ../syn/scr;      # synthesis scripts

# Design specific variables
if {[info exists ::env(TOP_NAME)]} {
    set TOP_NAME ${::env(TOP_NAME)}
} else {
    set TOP_NAME fabric
}

# prefix for report and output names
if {[info exists ::env(PREFIX)]} {
    set PREFIX $::env(PREFIX)
} else {
    set PREFIX ""
}

# sufix for report and output names
if {[info exists ::env(SUFFIX)]} {
    set SUFFIX $::env(SUFFIX)
} else {
    set SUFFIX ""
}

if {[info exists ::env(SAVE_STEPS)]} {
    set SAVE_STEPS $::env(SAVE_STEPS)
} else {
    set SAVE_STEPS false
}

if {[info exists ::env(TIMESTAMP)]} {
    set start_timestamp $::env(TIMESTAMP)
} else {
    set start_timestamp [clock format [clock seconds] -format %y%m%d_%H%M]
}
