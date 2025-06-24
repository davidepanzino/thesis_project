##########################################################################
# Signal Wire Extraction Script (Non-PG Nets)
# Author: Davide Finazzi
# Project: Backend Automation for DRRA2 - Automating Floorplanning and Power Planning in the SiLago Framework
# Tool: Cadence Innovus
##########################################################################

# Description:
# ------------
# This script collects physical implementation data for all *signal* wires 
# (i.e., excluding power and ground nets such as VDD/VSS) from the design 
# database in Cadence Innovus.
#
# For each wire belonging to a signal net, it extracts:
#   - Physical rectangle coordinates (bounding box)
#   - Metal layer name
#   - Associated net name
#
# The data is written to the following output files:
#   - area_list.txt   → Physical dimensions of each wire segment (rects)
#   - layer_list.txt  → Metal layer used for each wire
#   - net_list.txt    → Logical net associated with each wire
#
# These files can be used for post-layout parasitic analysis, rail density 
# visualization, or congestion evaluation.

# Usage:
# ------
# Launch Innovus, load your design, and source this script:
#   source normal_wires_data.tcl

##########################################################################

set area_list ""

foreach net [get_db nets *] {
    foreach wire [get_db $net .wires] {
        set area [get_db $wire .rect]
        lappend area_list $area
    }
}

set str [join $area_list "\n"]
set fp [open "./area_list.txt" "w"]
puts $fp $str
close $fp

set layer_list ""

foreach net [get_db nets *] {
    foreach wire [get_db $net .wires] {
        set layer [get_db $wire .layer]
        lappend layer_list $layer
    }
}

set str [join $layer_list "\n"]
set fp [open "./layer_list.txt" "w"]
puts $fp $str
close $fp

