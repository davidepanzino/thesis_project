##########################################################################
# Power/Ground (PG) Stripe Extraction Script
# Author: Davide Finazzi
# Project: Backend Automation for DRRA2 - Automating Floorplanning and Power Planning in the SiLago Framework
# Tool: Cadence Innovus
##########################################################################

# Description:
# ------------
# This script extracts detailed information about power and ground (PG) 
# special wires from the Innovus database. These include VDD and VSS rails,
# stripes and rings, defined as `special_wires` under `pg_nets`.
#
# For each wire segment belonging to a PG net, it collects:
#   - Physical rectangle area
#   - Metal layer used
#   - Net name (typically VDD or VSS)
#
# The extracted data is written to text files for use in:
#   - Power grid density analysis
#   - Rail coverage visualization
#   - Comparison with routed signal interconnects

# Outputs:
# --------
#   - area_list.txt   → Bounding area of each special wire segment
#   - layer_list.txt  → Routing layer (e.g., M6, M7, M8)
#   - net_list.txt    → Net name (VDD, VSS, etc.)

# Usage:
# ------
# After loading the full layout in Cadence Innovus:
#   source pg_wires_data.tcl

##########################################################################


set area_list ""

foreach pgnet [get_db pg_nets *] {
    foreach wire [get_db $pgnet .special_wires] {
        set area [get_db $wire .area]
        lappend area_list $area
    }
}

set str [join $area_list "\n"]
set fp [open "./area_pg_list.txt" "w"]
puts $fp $str
close $fp

set layer_list ""

foreach pgnet [get_db pg_nets *] {
    foreach wire [get_db $pgnet .special_wires] {
        set layer [get_db $wire .layer]
        lappend layer_list $layer
    }
}

set str [join $layer_list "\n"]
set fp [open "./layer_pg_list.txt" "w"]
puts $fp $str
close $fp


set net_list ""

foreach pgnet [get_db pg_nets *] {
    foreach wire [get_db $pgnet .special_wires] {
        set net [get_db $wire .net]
        lappend net_list $net
    }
}

set str [join $net_list "\n"]
set fp [open "./net_pg_list.txt" "w"]
puts $fp $str
close $fp

