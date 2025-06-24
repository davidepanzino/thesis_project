"""
------------------------------------------------------------------------------
DRRA2 Physical Design Automation Script
Author: Davide Finazzi
Project: Backend Automation for DRRA2 - Automating Floorplanning and Power Planning in the SiLago Framework
------------------------------------------------------------------------------

Description:
------------
This Python script automates the generation of multiple TCL scripts required 
for physical implementation of DRRA2-based architectures in Cadence Innovus. 
The flow is tailored to the SiLago framework and supports regular tiled layouts 
composed of reconfigurable cells with configurable resources.

The script processes a JSON-based architectural specification along with a 
Verilog netlist, extracting placement and resource mapping information to 
generate backend-ready constraints and setup scripts.

Generated TCL Scripts:
----------------------
- floorplan.tcl        → Cell placement, fencing, and macro-aware floorplanning
- design_variables.tcl      → Partitions module and instantiation names
- power_planning.tcl       → Power stripe insertion with proper pitch, width, and routing layer
- pin_constraints.tcl  → Pin placement between partitions


Inputs:
-------
- arch.json: Describes DRRA2 grid dimensions, resource types, and layout rules
- fabric.v: Verilog netlist from logic synthesis

Outputs:
--------
- A set of TCL scripts for backend design in Cadence Innovus

Usage:
------
Simply run the script in a Python 3 environment. The output files will be written 
to the directory ../phy/scr/
"""

import json
import re
from collections import defaultdict
import textwrap

# Define file paths
json_file_path = "arch.json"
netlist_file_path = "../syn/db/fabric.v"
floorplan_tcl_file_path = "../phy/scr/floorplan.tcl"
design_variables_tcl_file_path = "../phy/scr/design_variables.tcl"
power_planning_tcl_file_path = "../phy/scr/power_planning.tcl"
pins_constraints_tcl_file_path = "../phy/scr/pin_constraints.tcl"


# Load JSON file
with open(json_file_path, "r") as file:
    data = json.load(file)

# Extract architecture dimensions
columns = data["width"]
rows = data["height"]


# Extract cell fingerprints and their coordinates from JSON. Coordinates start from top left corner
cell_coordinates = defaultdict(lambda : {
    "fingerprint": None,
    "cell_instance": None,
    "resources": defaultdict(dict),
    "controller": {},
    "slots_with_macros": []
})

for cell in data["cells"]:

    col = cell["coordinates"]["col"]
    row = cell["coordinates"]["row"]
    coord_key = (row, col)

    cell_coordinates[coord_key]["fingerprint"] = cell["cell"]["fingerprint"]  # Key: Coordinate, Value: Fingerprint

    resource_num = 0
    # Iterate over resources within each cell
    for resource in cell["cell"]["resources_list"]:
        # Use coordinate as key and fingerprint as sub-key for properties
        cell_coordinates[coord_key]["resources"][f"resource_{resource_num}"] = {
            "resource_fingerprint": resource["fingerprint"],
            "instance_name": None,
            "resource_type": resource["name"],
            "slot": resource["slot"],
            "size": resource["size"],
            "macros": []
        }
        resource_num += 1

    # Extract controller features
    cell_coordinates[coord_key]["controller"] = {
        "fingerprint": cell["cell"]["controller"]["fingerprint"],
        "instance_name": None,
        "type": cell["cell"]["controller"]["name"],
        "size": cell["cell"]["controller"]["size"]
    }


# Read netlist file
with open(netlist_file_path, "r") as file:
    netlist_lines = file.readlines()

# Extract cell instances inside the top module
inside_top_module = False
for line in netlist_lines:
    line = line.strip()
    if re.match(rf"module fabric\s*\(", line):
        inside_top_module = True
        continue
    if inside_top_module and line.startswith("endmodule"):
        break
    if inside_top_module:
        # Extract coordinate and instance name from line
        match = re.search(rf"(\w+)\s+cell_(\d+)_(\d+)_inst", line)
        if match:
            fingerprint_with_suffix, row_str, col_str = match.groups()
            col = int(col_str)
            row = int(row_str)
            coord_key = (row, col)

            cell_coordinates[coord_key]["fingerprint"] = fingerprint_with_suffix
            cell_coordinates[coord_key]["cell_instance"] = f"cell_{row}_{col}_inst"


# Macros hunt
macros = []
current_module = None
for line in netlist_lines:
    line = line.strip()
    module_match = re.search(r'^\s*module\s+(\S+)\s*\(', line)
    if module_match:
        current_module = module_match.group(1)
    
    macro_match = re.search(r'\b(\S*macro\S*)\b', line)
    if macro_match and current_module:
        macro_instance = macro_match.group(1)
        macros.append({
            "module": current_module,
            "macro_instance": macro_instance,
            "big_module": None,
            "other": None
        })

current_big_module = None
for line in netlist_lines:
    line = line.strip()
    module_match = re.search(r"module\s+(\S+)\s*\(", line)
    if module_match:
        current_big_module = module_match.group(1)

    instance_match = re.search(r'^\s*(\S+)\s+([^\s\(]+)\s*\(', line)
    if instance_match and current_big_module:
        for entry in macros:
            if entry["module"] == instance_match.group(1):
                entry["big_module"] = current_big_module
                entry["other"] = instance_match.group(2)


# Extract resources and controllers inside each cell
for coord_key, cell_data in cell_coordinates.items():
    cell_module_name = cell_data["fingerprint"]
    inside_cell_module = False
    base_fingerprints = set()
    for resource in cell_data["resources"].values(): 
        base_fingerprints.add(resource["resource_fingerprint"])
    netlist_modules = []
    controller_fingerprint = cell_data["controller"]["fingerprint"]

    for line in netlist_lines:
        line = line.strip()
        if re.match(rf"module {cell_module_name}\s*\(", line):
            inside_cell_module = True
            continue
        if inside_cell_module and line.startswith("endmodule"):
            inside_cell_module = False
            continue

        if inside_cell_module:
            # For each base fingerprint, find all resource instances in the netlist
            for base in base_fingerprints:
                matches = re.findall(rf"({base}[\w\d]*)\s+(\w+)", line) # fingerprints/module names change at the end
                if matches:
                    netlist_modules.extend(matches)

            match_controller = re.findall(rf"({controller_fingerprint}[\w\d]*)\s+(\w+)", line)
            if match_controller:
                cell_data["controller"]["fingerprint"], cell_data["controller"]["instance_name"] = match_controller[0]
    
    # Update every resource fingerprint, e.g., now we have their netlist module name
    netlist_index = 0
    for resource_name, resource_stuff in cell_data["resources"].items():
        while netlist_index < len(netlist_modules):
            updated_fingerprint, updated_instance = netlist_modules[netlist_index]
            base = resource_stuff["resource_fingerprint"]
            pattern = rf"^{base}(_[\w\d]*)?$"
            if re.match(pattern, updated_fingerprint):
                resource_stuff["instance_name"] = updated_instance
                resource_stuff["resource_fingerprint"] = updated_fingerprint
                netlist_index += 1
                break
            netlist_index += 1


# Adding macros to resource list
for coord_key, cell_data in cell_coordinates.items():
    for resource_name, resource_stuff in cell_data["resources"].items():
        for entry in macros:
            if entry["big_module"] == resource_stuff["resource_fingerprint"]:
                resource_stuff["macros"].append(f'{entry["other"]}/{entry["macro_instance"]}')


# Slots with macros to exclude for power planning
for coord_key, cell_data in cell_coordinates.items():
    for resource in cell_data["resources"].values():
        if resource["macros"]:
            for i in range(resource["size"]):
                cell_data["slots_with_macros"].append(resource["slot"]+i)


# Flip row coordinates for the floorplan (we start from bottom left-corner)
flipped_cell_coordinates = {}

for coord_key, data in cell_coordinates.items():
    original_row, col = coord_key
    flipped_row = (rows - 1) - original_row  # Flip the row
    flipped_coord_key = (flipped_row, col)

    # Preserve all data but update coordinates
    flipped_cell_coordinates[flipped_coord_key] = {
        "fingerprint": data["fingerprint"],
        "cell_instance": data["cell_instance"],
        "resources": data["resources"],
        "controller": data["controller"],
        "slots_with_macros": data["slots_with_macros"]
    }

# Update previous cells dictionary
cell_coordinates = flipped_cell_coordinates



# Print the updated cell_coordinates to check if everything is extracted correctly
for coord, info in cell_coordinates.items():
    print(f"Coordinates: {coord}")
    print(f"  Fingerprint: {info['fingerprint']}")
    print(f"  Cell Instance: {info['cell_instance']}")
    print(f"  Slots with macros: {info["slots_with_macros"]}")
    
    # Print resources
    print(f"  Resources:")
    for res_key, res_info in info["resources"].items():
        print(f"    - {res_key}:")
        print(f"      Resource Fingerprint: {res_info['resource_fingerprint']}")
        print(f"      Instance Name: {res_info['instance_name']}")
        print(f"      Resource Type: {res_info['resource_type']}")
        print(f"      Slot: {res_info['slot']}")
        print(f"      Size: {res_info['size']}")
    
    # Print controller information if available
    if info["controller"]:
        print(f"  Controller:")
        print(f"    Fingerprint: {info['controller']['fingerprint']}")
        print(f"    Instance Name: {info['controller']['instance_name']}")
        print(f"    Type: {info['controller']['type']}")
        print(f"    Size: {info['controller']['size']}")
    else:
        print("  No Controller")

    print("\n" + "-" * 50 + "\n")



###################################################################################################################################################################################



#Floorplan Automation: floorplan.tcl
x_margin = 28
y_margin = 27
resource_width = 347.2
resource_height = 54
swb_router_width = 78.4
swb_router_height = 54
seq_width = 28
seq_height = resource_height * 16
x_sram_macro = 30
y_sram_macro = 23.395
distance_sram_macros = 30

with open(floorplan_tcl_file_path, "w") as tcl_file:

    tcl_file.write("# Define floorplanning variables\n")
    tcl_file.write("# X should be multiple of 5.6\n")
    tcl_file.write("# Y should be multiple of 9.0\n\n")

    # Define TCL variables
    tcl_file.write(f"set x_margin {x_margin}\n")
    tcl_file.write(f"set y_margin {y_margin}\n")
    tcl_file.write(f"set resource_width {resource_width}\n")
    tcl_file.write(f"set resource_height {resource_height}\n")
    tcl_file.write(f"set swb_router_width {swb_router_width}\n")
    tcl_file.write(f"set swb_router_height {swb_router_height}\n")
    tcl_file.write(f"set seq_width {seq_width}\n")
    tcl_file.write("set seq_height [expr {$resource_height * 16}]\n")
    tcl_file.write(f"set x_sram_macro {x_sram_macro}\n")
    tcl_file.write(f"set y_sram_macro {y_sram_macro}\n")
    tcl_file.write(f"set distance_sram_macros {distance_sram_macros}\n")
    tcl_file.write(f"set columns {columns}\n")
    tcl_file.write(f"set rows {rows}\n")
    tcl_file.write("set macro_coords_list {}\n\n")

    tcl_file.write("set x_length [expr {$seq_width + $resource_width + $swb_router_width}]\n")
    tcl_file.write("set y_length [expr {$swb_router_height + $seq_height}]\n\n")

    tcl_file.write("create_floorplan -core_margins_by io -site core -core_size [expr {$x_length * $columns + $x_margin*2}] [expr {$y_length * $rows + $y_margin*2}] 0 0 0 0\n")

    for coord_key, cell_data in cell_coordinates.items():
        row, col = coord_key
        cell_instance = cell_data["cell_instance"]
        tcl_file.write(f"\n\n# Cell {cell_instance} at (row: {row}, col: {col})\n")

        # Controller Placement
        controller_inst_name = cell_data["controller"]["instance_name"]
        tcl_file.write("# Controller\n")
        tcl_file.write(f"set x1 [expr {{$x_length * {col} + $x_margin}}]\n")
        tcl_file.write(f"set y1 [expr {{$y_length * {row} + $y_margin + $swb_router_height}}]\n")
        tcl_file.write("set x2 [expr {$x1 + $seq_width}]\n")
        tcl_file.write("set y2 [expr {$y1 + $seq_height}]\n")
        tcl_file.write(f"create_boundary_constraint -type fence -hinst {cell_instance}/{controller_inst_name} -rects [list [list $x1 $y1 $x2 $y2]]\n\n")

        # Resource Placement
        prev_size = 0
        swb_instance_name = None

        for resource in cell_data["resources"].values():

            if resource["resource_type"] == "swb_impl":  # Switchbox Placement (L-Shaped)

                swb_instance_name = resource["instance_name"]
                tcl_file.write("# Switchbox & Router\n")
                tcl_file.write(f"set x1 [expr {{$x_length * {col} + $x_margin}}]\n")
                tcl_file.write(f"set y1 [expr {{$y_length * {row} + $y_margin}}]\n")
                tcl_file.write("set x2 [expr {$x1 + $seq_width + $resource_width + $swb_router_width}]\n")
                tcl_file.write("set y2 [expr {$y1 + $swb_router_height}]\n")
                tcl_file.write("set x3 [expr {$x1 + $seq_width + $resource_width}]\n")
                tcl_file.write("set y3 $y2\n")
                tcl_file.write("set x4 $x2\n")
                tcl_file.write("set y4 [expr {$y3 + $seq_height}]\n")
                tcl_file.write(f"create_boundary_constraint -type fence -hinst {cell_instance}/{swb_instance_name} -rects [list [list $x1 $y1 $x2 $y2] [list $x3 $y3 $x4 $y4]]\n\n")

            else:

                module_name = resource["resource_fingerprint"]
                instance_name = resource["instance_name"]
                slot = resource["slot"]
                size = resource["size"]

                if slot == 1:
                    tcl_file.write("# Resources\n")
                    tcl_file.write("set resource_y_start [expr {$y_margin + $swb_router_height}]\n")
                else:
                    tcl_file.write(f"set resource_y_start [expr {{$resource_y_start + $resource_height * {prev_size}}}]\n")

                tcl_file.write(f"set x1 [expr {{$x_length * {col} + $x_margin + $seq_width}}]\n")
                tcl_file.write(f"set y1 [expr {{$y_length * {row} + $resource_y_start}}]\n")
                tcl_file.write("set x2 [expr {$x1 + $resource_width}]\n")
                tcl_file.write(f"set y2 [expr {{$y1 + $resource_height * {size}}}]\n")
                tcl_file.write(f"create_boundary_constraint -type fence -hinst {cell_instance}/{instance_name} -rects [list [list $x1 $y1 $x2 $y2]]\n\n")

                if resource["macros"]:
                    tcl_file.write("#Resource's Macros placement\n")
                    macro_num = 0
                    for macro in resource["macros"]:
                        if macro_num == 0:
                            tcl_file.write("set x3 [expr {$x1 + $x_sram_macro}]\n")
                            tcl_file.write("set y3 [expr {$y1 + $y_sram_macro}]\n")
                            tcl_file.write(f"place_inst {cell_instance}/{instance_name}/{macro} $x3 $y3\n")
                            tcl_file.write(f"set bbox0 [get_db inst:{cell_instance}/{instance_name}/{macro} .bbox]\n")
                            tcl_file.write("lappend macro_coords_list [concat {*}$bbox0]\n\n")
                        else:       
                            tcl_file.write(f"set prev_macro_width [get_db inst:{cell_instance}/{instance_name}/{prev_macro} .bbox.width]\n")     
                            tcl_file.write("set x3 [expr {$x3 + $prev_macro_width + $distance_sram_macros}]\n")         
                            tcl_file.write(f"place_inst {cell_instance}/{instance_name}/{macro} $x3 $y3\n")
                            tcl_file.write(f"set bbox0 [get_db inst:{cell_instance}/{instance_name}/{macro} .bbox]\n")
                            tcl_file.write("lappend macro_coords_list [concat {*}$bbox0]\n\n")

                        prev_macro = macro
                        macro_num += 1

                prev_size = size

    tcl_file.write("\n")
    
    tcl_file.write(textwrap.dedent("""\
        #placement blockage below and above macros

        set updated_macro_coords_list {}

        foreach bbox $macro_coords_list {
            lassign $bbox x_min y_min x_max y_max

            # The blockage consists of 2 std cell rows
            set y_min [expr {$y_min - 1.8}]
            set y_max [expr {$y_max + 1.8}]

            # Append updated bbox to new list
            lappend updated_macro_coords_list [list $x_min $y_min $x_max $y_max]
        }

        create_place_blockage -rects $updated_macro_coords_list

    """))

    # add only-physical cells
    tcl_file.write(textwrap.dedent("""\
        # add endcaps
        set_db add_endcaps_right_edge BOUNDARY_RIGHTBWP30P140
        set_db add_endcaps_left_edge BOUNDARY_LEFTBWP30P140
        add_endcaps

        # add well taps
        add_well_taps -checker_board -cell_interval 30 -cell TAPCELLBWP30P140

    """))

print("✅ Floorplan TCL script successfully generated as 'floorplan.tcl'")



###################################################################################################################################################################################



#Variables for Backend Flow: design_variables.tcl

with open(design_variables_tcl_file_path, "w") as tcl_file:

    tcl_file.write("#partitions instantiation names\n")
    tcl_file.write("set partition_hinst_list {\n")
    for coord_key, cell_data in cell_coordinates.items():
        cell_instance = cell_data["cell_instance"]
        tcl_file.write(f"    {cell_instance}/{cell_data["controller"]["instance_name"]} \\\n")
        for resource in cell_data["resources"].values():
            inst_name = resource["instance_name"]
            tcl_file.write(f"    {cell_instance}/{inst_name} \\\n")
    tcl_file.write("}\n\n")

    tcl_file.write("#partitions module names\n")
    tcl_file.write("set partition_module_list {\n")
    for coord_key, cell_data in cell_coordinates.items():
        for resource in cell_data["resources"].values():
            tcl_file.write(f"    {resource["resource_fingerprint"]} \\\n")
        tcl_file.write(f"   {cell_data["controller"]["fingerprint"]} \\\n")
    tcl_file.write("}\n\n")

print("✅ Design variables TCL script successfully generated as 'design_variables.tcl'")



###################################################################################################################################################################################



#Power Planning Automation: power_planning.tcl
vertical_pairs = 4 #VDD/VSS pairs from core rings to fabric boundaries along a single cell vertical edge
horizontal_pairs = 2 #VDD/VSS pairs from core rings to fabric boundaries along a single cell horizontal edge
x_offset_core = 8.0 #horizontal offset for core rings
y_offset_core = 8.0 #vertical offset for core rings
core_rings_size = 5.0 #size of rings around the core
x_offset = 10.0 #horizontal offset for partitions' rings
y_offset = 10.0 #vertical offset for partitions' rings
partition_rings_size = 2.5 #width of rings around partitions
macro_rings_size = 2.0 #width of rings around macros
stripes_size = 2.5 #width of stripes
vertical_pairs_slot = 3 #number of vertical stripes in resources' slots
vertical_stripes_swb_router_bottom = 2 #number of vertical stripes in the bottom part of switchbox/router
distance_stripes_between_rings = 20 #distance between stripes bridging the gap in between two rings

with open("power_planning.tcl", "w") as tcl_file:

    tcl_file.write("# Define power planning variables\n")
    tcl_file.write(f"set core_rings_size {core_rings_size}\n")
    tcl_file.write(f"set vertical_pairs {vertical_pairs}\n")
    tcl_file.write(f"set horizontal_pairs {horizontal_pairs}\n")
    tcl_file.write(f"set x_offset_core {x_offset_core}\n")
    tcl_file.write(f"set y_offset_core {y_offset_core}\n")
    tcl_file.write(f"set x_offset {x_offset}\n")
    tcl_file.write(f"set y_offset {y_offset}\n")
    tcl_file.write(f"set partition_rings_size {partition_rings_size}\n")
    tcl_file.write(f"set macro_rings_size {macro_rings_size}\n")
    tcl_file.write(f"set stripes_size {stripes_size}\n")
    tcl_file.write(f"set vertical_pairs_slot {vertical_pairs_slot}\n")
    tcl_file.write(f"set vertical_stripes_swb_router_bottom {vertical_stripes_swb_router_bottom}\n")
    tcl_file.write(f"set distance_stripes_between_rings {distance_stripes_between_rings}\n\n\n\n")

    #core rings
    tcl_file.write("#rings around the whole fabric\n")
    tcl_file.write("add_rings -nets {VDD VSS} -type core_rings -follow io -layer {top M7 bottom M7 left M8 right M8} -width [list top $core_rings_size bottom $core_rings_size left $core_rings_size right $core_rings_size] -spacing {top 1.8 bottom 1.8 left 1.8 right 1.8} -offset {top 5 bottom 5 left 5 right 5} -center 0 -threshold 0 -jog_distance 0 -snap_wire_center_to_grid none\n\n")

    tcl_file.write("\n\n")

    #stripes to outer world
    tcl_file.write("#stripes to outer world\n")
    tcl_file.write("set vertical_distance [expr {($seq_height + $swb_router_height)/($vertical_pairs + 1)}]\n")
    tcl_file.write("set horizontal_distance [expr {($seq_width + $resource_width + $swb_router_width)/($horizontal_pairs + 1)}]\n")
    
    tcl_file.write(textwrap.dedent("""\
        set_db add_stripes_ignore_block_check false ; set_db add_stripes_break_at none ; set_db add_stripes_route_over_rows_only false ; set_db add_stripes_rows_without_stripes_only false ; set_db add_stripes_extend_to_closest_target ring ; set_db add_stripes_stop_at_last_wire_for_area false ; set_db add_stripes_partial_set_through_domain false ; set_db add_stripes_ignore_non_default_domains true ; set_db add_stripes_trim_antenna_back_to_shape block_ring ; set_db add_stripes_spacing_type edge_to_edge ; set_db add_stripes_spacing_from_block 0 ; set_db add_stripes_stripe_min_length stripe_width ; set_db add_stripes_stacked_via_top_layer AP ; set_db add_stripes_stacked_via_bottom_layer M1 ; set_db add_stripes_via_using_exact_crossover_size true ; set_db add_stripes_split_vias false ; set_db add_stripes_orthogonal_only true ; set_db add_stripes_allow_jog { padcore_ring  block_ring } ; set_db add_stripes_skip_via_on_pin {  standardcell } ; set_db add_stripes_skip_via_on_wire_shape {  noshape   }
        for {set j 0} {$j < $rows} {incr j} {
            #left side
            set x1 0
            set y1 [expr {$y_margin + $vertical_distance + $y_length * $j}]
            set x2 [expr {$x_offset_core}]
            set y2 [expr {$y1 + $y_length - $vertical_distance}]
            set area_stripe [list \\
                $x1 $y1 \\
                $x2 $y1 \\
                $x2 $y2 \\
                $x1 $y2]
            add_stripes -nets {VDD VSS} -layer M7 -direction horizontal -width $core_rings_size -spacing 1.8 -set_to_set_distance $vertical_distance -area $area_stripe -start_from bottom -switch_layer_over_obs false -max_same_layer_jog_length 2 -pad_core_ring_top_layer_limit AP -pad_core_ring_bottom_layer_limit M1 -block_ring_top_layer_limit AP -block_ring_bottom_layer_limit M1 -use_wire_group 0 -snap_wire_center_to_grid none

            #right side
            set x1 [expr {$x_margin * 2 + $x_length*$columns - $x_offset_core}]
            set y1 [expr {$y_margin + $vertical_distance + $y_length * $j}]
            set x2 [expr {$x1 + $x_offset_core}]
            set y2 [expr {$y1 + $y_length - $vertical_distance}]
            set area_stripe [list \\
                $x1 $y1 \\
                $x2 $y1 \\
                $x2 $y2 \\
                $x1 $y2]
            add_stripes -nets {VDD VSS} -layer M7 -direction horizontal -width $core_rings_size -spacing 1.8 -set_to_set_distance $vertical_distance -area $area_stripe -start_from bottom -switch_layer_over_obs false -max_same_layer_jog_length 2 -pad_core_ring_top_layer_limit AP -pad_core_ring_bottom_layer_limit M1 -block_ring_top_layer_limit AP -block_ring_bottom_layer_limit M1 -use_wire_group 0 -snap_wire_center_to_grid none
        }

        for {set i 0} {$i < $columns} {incr i} {
            #bottom side
            set x1 [expr {$x_margin + $horizontal_distance + $x_length *$i}]
            set y1 0
            set x2 [expr {$x1 + $x_length - $horizontal_distance}]
            set y2 [expr {$y_offset_core}]
            set area_stripe [list \\
                $x1 $y1 \\
                $x2 $y1 \\
                $x2 $y2 \\
                $x1 $y2]
            add_stripes -nets {VDD VSS} -layer M8 -direction vertical -width $core_rings_size -spacing 1.8 -set_to_set_distance $horizontal_distance -area $area_stripe -start_from left -switch_layer_over_obs false -merge_stripes_value 10 -max_same_layer_jog_length 2 -pad_core_ring_top_layer_limit AP -pad_core_ring_bottom_layer_limit M1 -block_ring_top_layer_limit AP -block_ring_bottom_layer_limit M1 -use_wire_group 0 -snap_wire_center_to_grid none

            #top side
            set x1 [expr {$x_margin + $horizontal_distance + $x_length *$i}]
            set y1 [expr {$y_margin*2 + $y_length * $rows - $y_offset_core}]
            set x2 [expr {$x1 + $x_length - $horizontal_distance}]
            set y2 [expr {$y1 + $y_offset_core}]
            set area_stripe [list \\
                $x1 $y1 \\
                $x2 $y1 \\
                $x2 $y2 \\
                $x1 $y2]
            add_stripes -nets {VDD VSS} -layer M8 -direction vertical -width $core_rings_size -spacing 1.8 -set_to_set_distance $horizontal_distance -area $area_stripe -start_from left -switch_layer_over_obs false -merge_stripes_value 10 -max_same_layer_jog_length 2 -pad_core_ring_top_layer_limit AP -pad_core_ring_bottom_layer_limit M1 -block_ring_top_layer_limit AP -block_ring_bottom_layer_limit M1 -use_wire_group 0 -snap_wire_center_to_grid none
        }\n
    """))

    tcl_file.write("\n\n")

    #rings for partitions with no macros
    tcl_file.write("#rings for partitions with no macros\n")

    tcl_file.write(textwrap.dedent("""\
        for {set i 0} {$i < $columns} {incr i} {
            for {set j 0} {$j < $rows} {incr j} {
                #controller
                set x1 [expr {$x_length * $i + $x_margin}]
                set y1 [expr {$y_length * $j + $y_margin + $swb_router_height}]
                set x2 [expr {$x1 + $seq_width}]
                set y2 [expr {$y1 + $seq_height}]
                set coordinates [list \\
                    $x1 $y1 \\
                    $x2 $y1 \\
                    $x2 $y2 \\
                    $x1 $y2]
                set new_coordinates [list \\
                    [expr {[lindex $coordinates 0] + $x_offset}] \\
                    [expr {[lindex $coordinates 1] + $y_offset}] \\
                    [expr {[lindex $coordinates 2] - $x_offset}] \\
                    [expr {[lindex $coordinates 3] + $y_offset}] \\
                    [expr {[lindex $coordinates 4] - $x_offset}] \\
                    [expr {[lindex $coordinates 5] - $y_offset}] \\
                    [expr {[lindex $coordinates 6] + $x_offset}] \\
                    [expr {[lindex $coordinates 7] - $y_offset}]]
                add_rings -nets {VDD VSS} -around user_defined -user_defined_region $new_coordinates \\
                    -type block_rings \\
                    -layer {top M7 bottom M7 left M8 right M8} \\
                    -width [list top $partition_rings_size bottom $partition_rings_size left $partition_rings_size right $partition_rings_size] \\
                    -spacing {top 1.8 bottom 1.8 left 1.8 right 1.8} \\
                    -offset {top 1.8 bottom 1.8 left 1.8 right 1.8} \\
                    -center 0 -threshold 0 -jog_distance 0 -snap_wire_center_to_grid none

                #switchbox
                set x1 [expr {$x_length * $i + $x_margin}]
                set y1 [expr {$y_length * $j + $y_margin}]
                set x2 [expr {$x1 + $seq_width + $resource_width + $swb_router_width}]
                set y2 [expr {$y1 + $swb_router_height}]
                set x3 [expr {$x1 + $seq_width + $resource_width}]
                set y3 $y2
                set x4 $x2
                set y4 [expr {$y3 + $seq_height}]
                set coordinates [list \\
                    $x1 $y1 \\
                    $x2 $y1 \\
                    $x4 $y4 \\
                    $x3 $y4 \\
                    $x3 $y3 \\
                    $x1 $y2]

                set new_coordinates [list \\
                    [expr {[lindex $coordinates 0] + $x_offset}] \\
                    [expr {[lindex $coordinates 1] + $y_offset}] \\
                    [expr {[lindex $coordinates 2] - $x_offset}] \\
                    [expr {[lindex $coordinates 3] + $y_offset}] \\
                    [expr {[lindex $coordinates 4] - $x_offset}] \\
                    [expr {[lindex $coordinates 5] - $y_offset}] \\
                    [expr {[lindex $coordinates 6] + $x_offset}] \\
                    [expr {[lindex $coordinates 7] - $y_offset}] \\
                    [expr {[lindex $coordinates 8] + $x_offset}] \\
                    [expr {[lindex $coordinates 9] - $y_offset}] \\
                    [expr {[lindex $coordinates 10] + $x_offset}] \\
                    [expr {[lindex $coordinates 11] - $y_offset}]]
                add_rings -nets {VDD VSS} -around user_defined -user_defined_region $new_coordinates \\
                    -type block_rings \\
                    -layer {top M7 bottom M7 left M8 right M8} \\
                    -width [list top $partition_rings_size bottom $partition_rings_size left $partition_rings_size right $partition_rings_size] \\
                    -spacing {top 1.8 bottom 1.8 left 1.8 right 1.8} \\
                    -offset {top 1.8 bottom 1.8 left 1.8 right 1.8} \\
                    -center 0 -threshold 0 -jog_distance 0 -snap_wire_center_to_grid none\n
    """))

    tcl_file.write("        #resources\n")
    tcl_file.write("        for {set k 0} {$k < 16} {incr k} {\n")

    coords_with_macros = [(r, c) for (r, c), d in cell_coordinates.items() if d.get("slots_with_macros")]
    if_conditions = [f"($i == {c} && $j == {r})" for r, c in coords_with_macros]
    if_condition_str = " || ".join(if_conditions)

    if if_condition_str:
        tcl_file.write(f"            if {{ {if_condition_str} }} {{\n")
        for row, col in coords_with_macros:
            slots = cell_coordinates[(row, col)]["slots_with_macros"]
            k_conditions = " && ".join([f"($k+1) != {val}" for val in slots])
            tcl_file.write(f"                if {{ $i == {col} && $j == {row} && {k_conditions} }} {{\n")
            tcl_file.write("""\
                    set x1 [expr {$x_length * $i + $x_margin + $seq_width}]
                    set y1 [expr {$y_length * $j + $y_margin + $swb_router_height + $resource_height * $k}]
                    set x2 [expr {$x1 + $resource_width}]
                    set y2 [expr {$y1 + $resource_height}]
                    set coordinates [list \\
                        $x1 $y1 \\
                        $x2 $y1 \\
                        $x2 $y2 \\
                        $x1 $y2]
                    set new_coordinates [list \\
                        [expr {[lindex $coordinates 0] + $x_offset}] \\
                        [expr {[lindex $coordinates 1] + $y_offset}] \\
                        [expr {[lindex $coordinates 2] - $x_offset}] \\
                        [expr {[lindex $coordinates 3] + $y_offset}] \\
                        [expr {[lindex $coordinates 4] - $x_offset}] \\
                        [expr {[lindex $coordinates 5] - $y_offset}] \\
                        [expr {[lindex $coordinates 6] + $x_offset}] \\
                        [expr {[lindex $coordinates 7] - $y_offset}]]
                    add_rings -nets {VDD VSS} -around user_defined -user_defined_region $new_coordinates \\
                        -type block_rings \\
                        -layer {top M7 bottom M7 left M8 right M8} \\
                        -width [list top $partition_rings_size bottom $partition_rings_size left $partition_rings_size right $partition_rings_size] \\
                        -spacing {top 1.8 bottom 1.8 left 1.8 right 1.8} \\
                        -offset {top 1.8 bottom 1.8 left 1.8 right 1.8} \\
                        -center 0 -threshold 0 -jog_distance 0 -snap_wire_center_to_grid none
                }\n
""")

    tcl_file.write("            } else {\n")
    tcl_file.write("""\
                set x1 [expr {$x_length * $i + $x_margin + $seq_width}]
                set y1 [expr {$y_length * $j + $y_margin + $swb_router_height + $resource_height * $k}]
                set x2 [expr {$x1 + $resource_width}]
                set y2 [expr {$y1 + $resource_height}]
                set coordinates [list \\
                    $x1 $y1 \\
                    $x2 $y1 \\
                    $x2 $y2 \\
                    $x1 $y2]
                set new_coordinates [list \\
                    [expr {[lindex $coordinates 0] + $x_offset}] \\
                    [expr {[lindex $coordinates 1] + $y_offset}] \\
                    [expr {[lindex $coordinates 2] - $x_offset}] \\
                    [expr {[lindex $coordinates 3] + $y_offset}] \\
                    [expr {[lindex $coordinates 4] - $x_offset}] \\
                    [expr {[lindex $coordinates 5] - $y_offset}] \\
                    [expr {[lindex $coordinates 6] + $x_offset}] \\
                    [expr {[lindex $coordinates 7] - $y_offset}]]
                add_rings -nets {VDD VSS} -around user_defined -user_defined_region $new_coordinates \\
                    -type block_rings \\
                    -layer {top M7 bottom M7 left M8 right M8} \\
                    -width [list top $partition_rings_size bottom $partition_rings_size left $partition_rings_size right $partition_rings_size] \\
                    -spacing {top 1.8 bottom 1.8 left 1.8 right 1.8} \\
                    -offset {top 1.8 bottom 1.8 left 1.8 right 1.8} \\
                    -center 0 -threshold 0 -jog_distance 0 -snap_wire_center_to_grid none
            }
""")

    tcl_file.write("        }\n")
    tcl_file.write("    }\n")
    tcl_file.write("}\n\n")

    tcl_file.write("\n\n")

    #rings for partitions with macros
    tcl_file.write("#rings for partitions with macros\n")

    for coord_key, cell_data in cell_coordinates.items():
        row, col = coord_key
        for resource in cell_data["resources"].values():
            if resource["macros"]:
                tcl_file.write(textwrap.dedent(f"""\
                    set x1 [expr {{$x_length * {col} + $x_margin + $seq_width}}]
                    set y1 [expr {{$y_length * {row} + $y_margin + $swb_router_height + $resource_height * {resource["slot"] - 1}}}]
                    set x2 [expr {{$x1 + $resource_width}}]
                    set y2 [expr {{$y1 + $resource_height * {resource["size"]}}}]
                    set coordinates [list \\
                        $x1 $y1 \\
                        $x2 $y1 \\
                        $x2 $y2 \\
                        $x1 $y2]
                    set new_coordinates [list \\
                        [expr {{[lindex $coordinates 0] + $x_offset}}] \\
                        [expr {{[lindex $coordinates 1] + $y_offset}}] \\
                        [expr {{[lindex $coordinates 2] - $x_offset}}] \\
                        [expr {{[lindex $coordinates 3] + $y_offset}}] \\
                        [expr {{[lindex $coordinates 4] - $x_offset}}] \\
                        [expr {{[lindex $coordinates 5] - $y_offset}}] \\
                        [expr {{[lindex $coordinates 6] + $x_offset}}] \\
                        [expr {{[lindex $coordinates 7] - $y_offset}}]]
                    add_rings -nets {{VDD VSS}} -around user_defined -user_defined_region $new_coordinates \\
                        -type block_rings \\
                        -layer {{top M7 bottom M7 left M8 right M8}} \\
                        -width [list top $partition_rings_size bottom $partition_rings_size left $partition_rings_size right $partition_rings_size] \\
                        -spacing {{top 1.8 bottom 1.8 left 1.8 right 1.8}} \\
                        -offset {{top 1.8 bottom 1.8 left 1.8 right 1.8}} \\
                        -center 0 -threshold 0 -jog_distance 0 -snap_wire_center_to_grid none
                
    """))

    tcl_file.write("\n\n")

    #rings around macros
    tcl_file.write("#rings around macros\n")
    tcl_file.write("add_rings -nets {VDD VSS} -type block_rings -around each_block -layer {top M5 bottom M5 left M6 right M6} -width [list top $macro_rings_size bottom $macro_rings_size left $macro_rings_size right $macro_rings_size] -spacing {top 1.5 bottom 1.5 left 1.5 right 1.5} -offset {top 2 bottom 2 left 2 right 2} -center 0 -threshold 0 -jog_distance 0 -snap_wire_center_to_grid none\n\n")

    tcl_file.write("\n\n")

    #to connect macros VDD and VSS to rings around them
    tcl_file.write("#to connect macros VDD and VSS\n")
    tcl_file.write("connect_global_net VDD -type pg_pin -pin_base_name VDD -inst_base_name * -hinst {} -override -verbose\n")
    tcl_file.write("connect_global_net VSS -type pg_pin -pin_base_name VSS -inst_base_name * -hinst {} -override -verbose\n")
    tcl_file.write("route_special -nets {VDD VSS} -connect {block_pin} -block_pin all -block_pin_target {block_ring stripe ring} -allow_layer_change 1 -allow_jogging 1\n\n")

    tcl_file.write("\n\n")

    #stripes for partitions with macros
    tcl_file.write("#stripes for partitions with macros\n\n")
    for coord_key, cell_data in cell_coordinates.items():
        row, col = coord_key
        cell_instance = cell_data["cell_instance"]
        for resource in cell_data["resources"].values():
            if resource["macros"]:
                instance_name = resource["instance_name"]
                size = resource["size"]
                slot = resource["slot"]
                macro_num = 0
                tcl_file.write(f"#stripes to macros in cell row {row}, col {col}, slot {slot}\n\n")
                for macro in resource["macros"]:
                    if macro_num == 0:

                        #vertical to macro
                        tcl_file.write(textwrap.dedent(f"""\
                            #vertical to macro num {macro_num}
                            set_db add_stripes_ignore_block_check false ; set_db add_stripes_break_at {{  block_ring  outside_ringmacro  }} ; set_db add_stripes_route_over_rows_only false ; set_db add_stripes_rows_without_stripes_only false ; set_db add_stripes_extend_to_closest_target none ; set_db add_stripes_stop_at_last_wire_for_area true ; set_db add_stripes_partial_set_through_domain false ; set_db add_stripes_ignore_non_default_domains false ; set_db add_stripes_trim_antenna_back_to_shape block_ring ; set_db add_stripes_spacing_type edge_to_edge ; set_db add_stripes_spacing_from_block 0 ; set_db add_stripes_stripe_min_length stripe_width ; set_db add_stripes_stacked_via_top_layer AP ; set_db add_stripes_stacked_via_bottom_layer M1 ; set_db add_stripes_via_using_exact_crossover_size false ; set_db add_stripes_split_vias false ; set_db add_stripes_orthogonal_only true ; set_db add_stripes_allow_jog {{ padcore_ring  block_ring }} ; set_db add_stripes_skip_via_on_pin {{  standardcell }} ; set_db add_stripes_skip_via_on_wire_shape {{  noshape   }}
                            set macro_width [get_db inst:{cell_instance}/{instance_name}/{macro} .bbox.width]
                            set x1 [expr {{$x_margin + $seq_width + $x_sram_macro + $macro_width/2 + $x_length * {col}}}]
                            set y1 [expr {{$y_margin + $swb_router_height  + $resource_height * {slot-1} + $y_length * {row}}}]
                            set x2 [expr {{$x1 + $x_offset*2}}]
                            set y2 [expr {{$y1 + $resource_height * {size}}}]
                            set prev_end [expr {{$x1 + $macro_width/2}}]
                            set area_stripe [list \\
                                $x1 $y1 \\
                                $x2 $y1 \\
                                $x2 $y2 \\
                                $x1 $y2]
                            add_stripes -nets {{VDD VSS}} -layer M6 -direction vertical -width {stripes_size} -spacing 1.8 -number_of_sets 1 -area $area_stripe -start_from left -switch_layer_over_obs false -max_same_layer_jog_length 2 -pad_core_ring_top_layer_limit AP -pad_core_ring_bottom_layer_limit M1 -block_ring_top_layer_limit AP -block_ring_bottom_layer_limit M1 -use_wire_group 0 -snap_wire_center_to_grid none
                              
                        """))

                    else:
                        #vertical stripe between macros
                        tcl_file.write(textwrap.dedent(f"""\
                            #vertical stripe between macro {macro_num} and {macro_num+1}
                            set_db add_stripes_ignore_block_check false ; set_db add_stripes_break_at {{  block_ring  outside_ringmacro  }} ; set_db add_stripes_route_over_rows_only false ; set_db add_stripes_rows_without_stripes_only false ; set_db add_stripes_extend_to_closest_target none ; set_db add_stripes_stop_at_last_wire_for_area true ; set_db add_stripes_partial_set_through_domain false ; set_db add_stripes_ignore_non_default_domains false ; set_db add_stripes_trim_antenna_back_to_shape block_ring ; set_db add_stripes_spacing_type edge_to_edge ; set_db add_stripes_spacing_from_block 0 ; set_db add_stripes_stripe_min_length stripe_width ; set_db add_stripes_stacked_via_top_layer AP ; set_db add_stripes_stacked_via_bottom_layer M1 ; set_db add_stripes_via_using_exact_crossover_size false ; set_db add_stripes_split_vias false ; set_db add_stripes_orthogonal_only true ; set_db add_stripes_allow_jog {{ padcore_ring  block_ring }} ; set_db add_stripes_skip_via_on_pin {{  standardcell }} ; set_db add_stripes_skip_via_on_wire_shape {{  noshape   }}
                            set x1 [expr {{$prev_end}}]
                            set y1 [expr {{$y_margin + $swb_router_height  + $resource_height * {slot-1} + $y_length * {row}}}]
                            set x2 [expr {{$x1 + $distance_sram_macros}}]
                            set y2 [expr {{$y1 + $resource_height * {size}}}]
                            set area_stripe [list \\
                                $x1 $y1 \\
                                $x2 $y1 \\
                                $x2 $y2 \\
                                $x1 $y2]
                            add_stripes -nets {{VDD VSS}} -layer M6 -direction vertical -width {stripes_size} -spacing 1.8 -number_of_sets 1 -area $area_stripe -start_from left -start_offset [expr {{$distance_sram_macros/2 - 3.4}}] -switch_layer_over_obs false -max_same_layer_jog_length 2 -pad_core_ring_top_layer_limit AP -pad_core_ring_bottom_layer_limit M1 -block_ring_top_layer_limit AP -block_ring_bottom_layer_limit M1 -use_wire_group 0 -snap_wire_center_to_grid none
                              
                        """))

                        #vertical to macro
                        tcl_file.write(textwrap.dedent(f"""\
                            #vertical to macro num {macro_num}
                            set_db add_stripes_ignore_block_check false ; set_db add_stripes_break_at {{  block_ring  outside_ringmacro  }} ; set_db add_stripes_route_over_rows_only false ; set_db add_stripes_rows_without_stripes_only false ; set_db add_stripes_extend_to_closest_target none ; set_db add_stripes_stop_at_last_wire_for_area true ; set_db add_stripes_partial_set_through_domain false ; set_db add_stripes_ignore_non_default_domains false ; set_db add_stripes_trim_antenna_back_to_shape block_ring ; set_db add_stripes_spacing_type edge_to_edge ; set_db add_stripes_spacing_from_block 0 ; set_db add_stripes_stripe_min_length stripe_width ; set_db add_stripes_stacked_via_top_layer AP ; set_db add_stripes_stacked_via_bottom_layer M1 ; set_db add_stripes_via_using_exact_crossover_size false ; set_db add_stripes_split_vias false ; set_db add_stripes_orthogonal_only true ; set_db add_stripes_allow_jog {{ padcore_ring  block_ring }} ; set_db add_stripes_skip_via_on_pin {{  standardcell }} ; set_db add_stripes_skip_via_on_wire_shape {{  noshape   }}
                            set macro_width [get_db inst:{cell_instance}/{instance_name}/{macro} .bbox.width]
                            set x1 [expr {{$prev_end + $distance_sram_macros + $macro_width/2}}]
                            set y1 [expr {{$y_margin + $swb_router_height  + $resource_height * {slot-1} + $y_length * {row}}}]
                            set x2 [expr {{$x1 + $x_offset*2}}]
                            set y2 [expr {{$y1 + $resource_height * {size}}}]
                            set prev_end [expr {{$x1 + $macro_width/2}}]
                            set area_stripe [list \\
                                $x1 $y1 \\
                                $x2 $y1 \\
                                $x2 $y2 \\
                                $x1 $y2]
                            add_stripes -nets {{VDD VSS}} -layer M6 -direction vertical -width {stripes_size} -spacing 1.8 -number_of_sets 1 -area $area_stripe -start_from left -switch_layer_over_obs false -max_same_layer_jog_length 2 -pad_core_ring_top_layer_limit AP -pad_core_ring_bottom_layer_limit M1 -block_ring_top_layer_limit AP -block_ring_bottom_layer_limit M1 -use_wire_group 0 -snap_wire_center_to_grid none
                              
                        """))

                    macro_num += 1

    tcl_file.write("\n\n")
    

    #stripes for slots with NO macros
    tcl_file.write("#stripes for slots with NO macros\n")
    tcl_file.write(textwrap.dedent("""\
        for {set i 0} {$i < $columns} {incr i} {
            for {set j 0} {$j < $rows} {incr j} {
                for {set k 0} {$k < 16} {incr k} {
    """))

    coords_with_macros = [(r, c) for (r, c), d in cell_coordinates.items() if d.get("slots_with_macros")]
    if_conditions = [f"($i == {c} && $j == {r})" for r, c in coords_with_macros]
    if_condition_str = " || ".join(if_conditions)

    if if_condition_str:
        tcl_file.write(f"            if {{ {if_condition_str} }} {{\n")
        for row, col in coords_with_macros:
            slots = cell_coordinates[(row, col)]["slots_with_macros"]
            k_conditions = " && ".join([f"($k+1) != {val}" for val in slots])
            tcl_file.write(f"                if {{ $i == {col} && $j == {row} && {k_conditions} }} {{\n")
            tcl_file.write("""\
                    set_db add_stripes_ignore_block_check false ; set_db add_stripes_break_at none ; set_db add_stripes_route_over_rows_only false ; set_db add_stripes_rows_without_stripes_only false ; set_db add_stripes_extend_to_closest_target none ; set_db add_stripes_stop_at_last_wire_for_area true ; set_db add_stripes_partial_set_through_domain false ; set_db add_stripes_ignore_non_default_domains false ; set_db add_stripes_trim_antenna_back_to_shape block_ring ; set_db add_stripes_spacing_type edge_to_edge ; set_db add_stripes_spacing_from_block 0 ; set_db add_stripes_stripe_min_length stripe_width ; set_db add_stripes_stacked_via_top_layer AP ; set_db add_stripes_stacked_via_bottom_layer M1 ; set_db add_stripes_via_using_exact_crossover_size false ; set_db add_stripes_split_vias false ; set_db add_stripes_orthogonal_only true ; set_db add_stripes_allow_jog { padcore_ring  block_ring } ; set_db add_stripes_skip_via_on_pin {  standardcell } ; set_db add_stripes_skip_via_on_wire_shape {  noshape   }
                    set x1 [expr {$x_length * $i + $x_margin + $seq_width + $resource_width/($vertical_pairs_slot+1)}]
                    set y1 [expr {$y_length * $j + $y_margin + $swb_router_height + $resource_height * $k}]
                    if {$vertical_pairs_slot == 1} {
                        set x2 [expr {$x1 + ($resource_width/2)*1}]
                    } else {
                        set x2 [expr {$x1 + ($resource_width/($vertical_pairs_slot + 1))*($vertical_pairs_slot - 1)}]
                    }
                    
                    set y2 [expr {$y1 + $resource_height}]
                    set area_stripe [list \\
                        $x1 $y1 \\
                        $x2 $y1 \\
                        $x2 $y2 \\
                        $x1 $y2]
                    add_stripes -nets {VDD VSS} -layer M6 -direction vertical -width $stripes_size -spacing 1.8 -number_of_sets $vertical_pairs_slot -area $area_stripe -start_from left -switch_layer_over_obs false -max_same_layer_jog_length 2 -pad_core_ring_top_layer_limit AP -pad_core_ring_bottom_layer_limit M1 -block_ring_top_layer_limit AP -block_ring_bottom_layer_limit M1 -use_wire_group 0 -snap_wire_center_to_grid none            

                    #horizontal
                    set x1 [expr {$x_length * $i + $x_margin + $seq_width}]
                    set y1 [expr {$y_length * $j + $y_margin + $swb_router_height + $resource_height * $k + $resource_height/2 - 3.4}]
                    set x2 [expr {$x1 + $resource_width}]                  
                    set y2 [expr {$y1 + $y_offset*2}]
                    set area_stripe [list \\
                        $x1 $y1 \\
                        $x2 $y1 \\
                        $x2 $y2 \\
                        $x1 $y2]
                    add_stripes -nets {VDD VSS} -layer M7 -direction horizontal -width $stripes_size -spacing 1.8 -number_of_sets 1 -area $area_stripe -start_from left -switch_layer_over_obs false -max_same_layer_jog_length 2 -pad_core_ring_top_layer_limit AP -pad_core_ring_bottom_layer_limit M1 -block_ring_top_layer_limit AP -block_ring_bottom_layer_limit M1 -use_wire_group 0 -snap_wire_center_to_grid none            
                
                }\n
""")

    tcl_file.write("            } else {\n")
    tcl_file.write("""\
                set_db add_stripes_ignore_block_check false ; set_db add_stripes_break_at none ; set_db add_stripes_route_over_rows_only false ; set_db add_stripes_rows_without_stripes_only false ; set_db add_stripes_extend_to_closest_target none ; set_db add_stripes_stop_at_last_wire_for_area true ; set_db add_stripes_partial_set_through_domain false ; set_db add_stripes_ignore_non_default_domains false ; set_db add_stripes_trim_antenna_back_to_shape block_ring ; set_db add_stripes_spacing_type edge_to_edge ; set_db add_stripes_spacing_from_block 0 ; set_db add_stripes_stripe_min_length stripe_width ; set_db add_stripes_stacked_via_top_layer AP ; set_db add_stripes_stacked_via_bottom_layer M1 ; set_db add_stripes_via_using_exact_crossover_size false ; set_db add_stripes_split_vias false ; set_db add_stripes_orthogonal_only true ; set_db add_stripes_allow_jog { padcore_ring  block_ring } ; set_db add_stripes_skip_via_on_pin {  standardcell } ; set_db add_stripes_skip_via_on_wire_shape {  noshape   }
                set x1 [expr {$x_length * $i + $x_margin + $seq_width + $resource_width/($vertical_pairs_slot+1)}]
                set y1 [expr {$y_length * $j + $y_margin + $swb_router_height + $resource_height * $k}]
                if {$vertical_pairs_slot == 1} {
                    set x2 [expr {$x1 + ($resource_width/2)*1}]
                } else {
                    set x2 [expr {$x1 + ($resource_width/($vertical_pairs_slot + 1))*($vertical_pairs_slot - 1)}]
                }
                set y2 [expr {$y1 + $resource_height}]
                set area_stripe [list \\
                    $x1 $y1 \\
                    $x2 $y1 \\
                    $x2 $y2 \\
                    $x1 $y2]
                add_stripes -nets {VDD VSS} -layer M6 -direction vertical -width $stripes_size -spacing 1.8 -number_of_sets $vertical_pairs_slot -area $area_stripe -start_from left -switch_layer_over_obs false -max_same_layer_jog_length 2 -pad_core_ring_top_layer_limit AP -pad_core_ring_bottom_layer_limit M1 -block_ring_top_layer_limit AP -block_ring_bottom_layer_limit M1 -use_wire_group 0 -snap_wire_center_to_grid none                         

                #horizontal
                set x1 [expr {$x_length * $i + $x_margin + $seq_width}]
                set y1 [expr {$y_length * $j + $y_margin + $swb_router_height + $resource_height * $k + $resource_height/2 - 3.4}]
                set x2 [expr {$x1 + $resource_width}]                  
                set y2 [expr {$y1 + $y_offset*2}]
                set area_stripe [list \\
                    $x1 $y1 \\
                    $x2 $y1 \\
                    $x2 $y2 \\
                    $x1 $y2]
                add_stripes -nets {VDD VSS} -layer M7 -direction horizontal -width $stripes_size -spacing 1.8 -number_of_sets 1 -area $area_stripe -start_from left -switch_layer_over_obs false -max_same_layer_jog_length 2 -pad_core_ring_top_layer_limit AP -pad_core_ring_bottom_layer_limit M1 -block_ring_top_layer_limit AP -block_ring_bottom_layer_limit M1 -use_wire_group 0 -snap_wire_center_to_grid none                        
            }
""")

    tcl_file.write("        }\n")
    tcl_file.write("    }\n")
    tcl_file.write("}\n\n")

    tcl_file.write("\n\n")
    
    #vertical stripe in swb_router
    tcl_file.write(textwrap.dedent("""\
        #vertical stripe in swb_router
        set_db add_stripes_ignore_block_check false ; set_db add_stripes_break_at none ; set_db add_stripes_route_over_rows_only false ; set_db add_stripes_rows_without_stripes_only false ; set_db add_stripes_extend_to_closest_target none ; set_db add_stripes_stop_at_last_wire_for_area true ; set_db add_stripes_partial_set_through_domain false ; set_db add_stripes_ignore_non_default_domains false ; set_db add_stripes_trim_antenna_back_to_shape block_ring ; set_db add_stripes_spacing_type edge_to_edge ; set_db add_stripes_spacing_from_block 0 ; set_db add_stripes_stripe_min_length stripe_width ; set_db add_stripes_stacked_via_top_layer AP ; set_db add_stripes_stacked_via_bottom_layer M1 ; set_db add_stripes_via_using_exact_crossover_size false ; set_db add_stripes_split_vias false ; set_db add_stripes_orthogonal_only true ; set_db add_stripes_allow_jog { padcore_ring  block_ring } ; set_db add_stripes_skip_via_on_pin {  standardcell } ; set_db add_stripes_skip_via_on_wire_shape {  noshape   }

        for {set i 0} {$i < $columns} {incr i} {
            for {set j 0} {$j < $rows} {incr j} {
                set x1 [expr {$x_margin + $x_length * $i + $seq_width + $resource_width + $swb_router_width/2}]
                set y1 [expr {$y_margin + $y_length * $j}]
                set x2 [expr {$x1 + $x_offset * 2}]
                set y2 [expr {$y1 + $swb_router_height + $seq_height}]
                set area_stripe [list \\
                    $x1 $y1 \\
                    $x2 $y1 \\
                    $x2 $y2 \\
                    $x1 $y2]
                add_stripes -nets {VDD VSS} -layer M6 -direction vertical -width $stripes_size -spacing 1.8 -number_of_sets 1 -area $area_stripe -start_from left -switch_layer_over_obs false -max_same_layer_jog_length 2 -pad_core_ring_top_layer_limit AP -pad_core_ring_bottom_layer_limit M1 -block_ring_top_layer_limit AP -block_ring_bottom_layer_limit M1 -use_wire_group 0 -snap_wire_center_to_grid none            
            }
        }
    """))

    tcl_file.write("\n\n\n")
    

    #vertical stripe in swb_router, bottom part
    tcl_file.write(textwrap.dedent("""\
        #vertical stripe in swb_router, bottom part
        set_db add_stripes_ignore_block_check false ; set_db add_stripes_break_at none ; set_db add_stripes_route_over_rows_only false ; set_db add_stripes_rows_without_stripes_only false ; set_db add_stripes_extend_to_closest_target none ; set_db add_stripes_stop_at_last_wire_for_area true ; set_db add_stripes_partial_set_through_domain false ; set_db add_stripes_ignore_non_default_domains false ; set_db add_stripes_trim_antenna_back_to_shape block_ring ; set_db add_stripes_spacing_type edge_to_edge ; set_db add_stripes_spacing_from_block 0 ; set_db add_stripes_stripe_min_length stripe_width ; set_db add_stripes_stacked_via_top_layer AP ; set_db add_stripes_stacked_via_bottom_layer M1 ; set_db add_stripes_via_using_exact_crossover_size false ; set_db add_stripes_split_vias false ; set_db add_stripes_orthogonal_only true ; set_db add_stripes_allow_jog { padcore_ring  block_ring } ; set_db add_stripes_skip_via_on_pin {  standardcell } ; set_db add_stripes_skip_via_on_wire_shape {  noshape   }

        for {set i 0} {$i < $columns} {incr i} {
            for {set j 0} {$j < $rows} {incr j} {
                set x1 [expr {$x_margin + $x_length * $i + ($seq_width + $resource_width)/($vertical_stripes_swb_router_bottom + 1)}]
                set y1 [expr {$y_margin + $y_length * $j}]
                if {$vertical_stripes_swb_router_bottom == 1} {
                    set x2 [expr {$x1 + ($seq_width + $resource_width)*1}]
                } else {
                    set x2 [expr {$x1 + ($seq_width + $resource_width)/($vertical_stripes_swb_router_bottom + 1)*($vertical_stripes_swb_router_bottom - 1)}]
                }
                set y2 [expr {$y1 + $swb_router_height}]
                set area_stripe [list \\
                    $x1 $y1 \\
                    $x2 $y1 \\
                    $x2 $y2 \\
                    $x1 $y2]
                add_stripes -nets {VDD VSS} -layer M6 -direction vertical -width $stripes_size -spacing 1.8 -number_of_sets $vertical_stripes_swb_router_bottom -area $area_stripe -start_from left -switch_layer_over_obs false -max_same_layer_jog_length 2 -pad_core_ring_top_layer_limit AP -pad_core_ring_bottom_layer_limit M1 -block_ring_top_layer_limit AP -block_ring_bottom_layer_limit M1 -use_wire_group 0 -snap_wire_center_to_grid none            
            }
        }
    """))

    tcl_file.write("\n\n\n")
    
    
    #vertical stripe in sequencer
    tcl_file.write(textwrap.dedent("""\
        #vertical stripe in swb_router
        set_db add_stripes_ignore_block_check false ; set_db add_stripes_break_at none ; set_db add_stripes_route_over_rows_only false ; set_db add_stripes_rows_without_stripes_only false ; set_db add_stripes_extend_to_closest_target none ; set_db add_stripes_stop_at_last_wire_for_area true ; set_db add_stripes_partial_set_through_domain false ; set_db add_stripes_ignore_non_default_domains false ; set_db add_stripes_trim_antenna_back_to_shape block_ring ; set_db add_stripes_spacing_type edge_to_edge ; set_db add_stripes_spacing_from_block 0 ; set_db add_stripes_stripe_min_length stripe_width ; set_db add_stripes_stacked_via_top_layer AP ; set_db add_stripes_stacked_via_bottom_layer M1 ; set_db add_stripes_via_using_exact_crossover_size false ; set_db add_stripes_split_vias false ; set_db add_stripes_orthogonal_only true ; set_db add_stripes_allow_jog { padcore_ring  block_ring } ; set_db add_stripes_skip_via_on_pin {  standardcell } ; set_db add_stripes_skip_via_on_wire_shape {  noshape   }

        for {set i 0} {$i < $columns} {incr i} {
            for {set j 0} {$j < $rows} {incr j} {
                set x1 [expr {$x_margin + $x_length * $i + $seq_width/2 - 3.4}]
                set y1 [expr {$y_margin + $swb_router_height + $y_length * $j}]
                set x2 [expr {$x1 + $x_offset * 2}]
                set y2 [expr {$y1 + $seq_height}]
                set area_stripe [list \\
                    $x1 $y1 \\
                    $x2 $y1 \\
                    $x2 $y2 \\
                    $x1 $y2]
                add_stripes -nets {VDD VSS} -layer M6 -direction vertical -width $stripes_size -spacing 1.8 -number_of_sets 1 -area $area_stripe -start_from left -switch_layer_over_obs false -max_same_layer_jog_length 2 -pad_core_ring_top_layer_limit AP -pad_core_ring_bottom_layer_limit M1 -block_ring_top_layer_limit AP -block_ring_bottom_layer_limit M1 -use_wire_group 0 -snap_wire_center_to_grid none            
            }
        }
    """))
    
    tcl_file.write("\n\n\n")

    
    #stripes among rings
    tcl_file.write("#stripes among rings\n")
    tcl_file.write(textwrap.dedent("""\
        set_db add_stripes_ignore_block_check true ; set_db add_stripes_break_at none ; set_db add_stripes_route_over_rows_only false ; set_db add_stripes_rows_without_stripes_only false ; set_db add_stripes_extend_to_closest_target none ; set_db add_stripes_stop_at_last_wire_for_area true ; set_db add_stripes_partial_set_through_domain false ; set_db add_stripes_ignore_non_default_domains false ; set_db add_stripes_trim_antenna_back_to_shape block_ring ; set_db add_stripes_spacing_type edge_to_edge ; set_db add_stripes_spacing_from_block 0 ; set_db add_stripes_stripe_min_length stripe_width ; set_db add_stripes_stacked_via_top_layer AP ; set_db add_stripes_stacked_via_bottom_layer M1 ; set_db add_stripes_via_using_exact_crossover_size false ; set_db add_stripes_split_vias false ; set_db add_stripes_orthogonal_only true ; set_db add_stripes_allow_jog { padcore_ring  block_ring } ; set_db add_stripes_skip_via_on_pin {  standardcell } ; set_db add_stripes_skip_via_on_wire_shape {  noshape   }

        for {set i 0} {$i < $columns} {incr i} {
            for {set j 0} {$j < $rows} {incr j} {
                for {set k 0} {$k < 16} {incr k} {
                    #between sequencer and resources
                    set x1 [expr {$x_margin + $x_length * $i + $seq_width - $x_offset}]
                    set y1 [expr {$y_length * $j + $y_margin + $swb_router_height + $resource_height * $k + $resource_height/2 - 3.4}]
                    set x2 [expr {$x1 + $x_offset * 2}]
                    set y2 [expr {$y1 + $y_offset * 2}]
                    set area_stripe [list \\
                        $x1 $y1 \\
                        $x2 $y1 \\
                        $x2 $y2 \\
                        $x1 $y2]
                    add_stripes -nets {VDD VSS} -layer M7 -direction horizontal -width $stripes_size -spacing 1.8 -number_of_sets 1 -area $area_stripe -start_from bottom -switch_layer_over_obs false -merge_stripes_value 10 -max_same_layer_jog_length 2 -pad_core_ring_top_layer_limit AP -pad_core_ring_bottom_layer_limit M1 -block_ring_top_layer_limit AP -block_ring_bottom_layer_limit M1 -use_wire_group 0 -snap_wire_center_to_grid none
                    #between swb and resources
                    set x1 [expr {$x_margin + $x_length * $i + $seq_width + $resource_width - $x_offset}]
                    set y1 [expr {$y_length * $j + $y_margin + $swb_router_height + $resource_height * $k + $resource_height/2 - 3.4}]
                    set x2 [expr {$x1 + $x_offset * 2}]
                    set y2 [expr {$y1 + $y_offset * 2}]
                    set area_stripe [list \\
                        $x1 $y1 \\
                        $x2 $y1 \\
                        $x2 $y2 \\
                        $x1 $y2]
                    add_stripes -nets {VDD VSS} -layer M7 -direction horizontal -width $stripes_size -spacing 1.8 -number_of_sets 1 -area $area_stripe -start_from bottom -switch_layer_over_obs false -merge_stripes_value 10 -max_same_layer_jog_length 2 -pad_core_ring_top_layer_limit AP -pad_core_ring_bottom_layer_limit M1 -block_ring_top_layer_limit AP -block_ring_bottom_layer_limit M1 -use_wire_group 0 -snap_wire_center_to_grid none
                }

                #vertical between seq and swb
                set x1 [expr {$x_margin + $x_length * $i + $seq_width/2 - 3.4}]
                set y1 [expr {$y_margin + $y_length * $j + $swb_router_height - $y_offset}]
               set x2 [expr {$x1 + $x_offset * 2}]
                set y2 [expr {$y1 + $y_offset * 2}]
                set area_stripe [list \\
                    $x1 $y1 \\
                    $x2 $y1 \\
                    $x2 $y2 \\
                    $x1 $y2]
                add_stripes -nets {VDD VSS} -layer M6 -direction vertical -width $stripes_size -spacing 1.8 -number_of_sets 1 -area $area_stripe -start_from left -switch_layer_over_obs false -merge_stripes_value 10 -max_same_layer_jog_length 2 -pad_core_ring_top_layer_limit AP -pad_core_ring_bottom_layer_limit M1 -block_ring_top_layer_limit AP -block_ring_bottom_layer_limit M1 -use_wire_group 0 -snap_wire_center_to_grid none
            }
        }

    """))


    #vertical between resource rings
    tcl_file.write("#underneath resources with NO macros\n")
    tcl_file.write(textwrap.dedent("""\
        for {set i 0} {$i < $columns} {incr i} {
            for {set j 0} {$j < $rows} {incr j} {
                for {set k 0} {$k < 16} {incr k} {
    """))

    coords_with_macros = [(r, c) for (r, c), d in cell_coordinates.items() if d.get("slots_with_macros")]
    if_conditions = [f"($i == {c} && $j == {r})" for r, c in coords_with_macros]
    if_condition_str = " || ".join(if_conditions)

    if if_condition_str:
        tcl_file.write(f"            if {{ {if_condition_str} }} {{\n")
        for row, col in coords_with_macros:
            slots = cell_coordinates[(row, col)]["slots_with_macros"]
            k_conditions = " && ".join([f"($k+1) != {val}" for val in slots])
            tcl_file.write(f"                if {{ $i == {col} && $j == {row} && {k_conditions} }} {{\n")
            tcl_file.write("""\
                    set_db add_stripes_ignore_block_check true ; set_db add_stripes_break_at none ; set_db add_stripes_route_over_rows_only false ; set_db add_stripes_rows_without_stripes_only false ; set_db add_stripes_extend_to_closest_target none ; set_db add_stripes_stop_at_last_wire_for_area true ; set_db add_stripes_partial_set_through_domain false ; set_db add_stripes_ignore_non_default_domains false ; set_db add_stripes_trim_antenna_back_to_shape block_ring ; set_db add_stripes_spacing_type edge_to_edge ; set_db add_stripes_spacing_from_block 0 ; set_db add_stripes_stripe_min_length stripe_width ; set_db add_stripes_stacked_via_top_layer AP ; set_db add_stripes_stacked_via_bottom_layer M1 ; set_db add_stripes_via_using_exact_crossover_size false ; set_db add_stripes_split_vias false ; set_db add_stripes_orthogonal_only true ; set_db add_stripes_allow_jog { padcore_ring  block_ring } ; set_db add_stripes_skip_via_on_pin {  standardcell } ; set_db add_stripes_skip_via_on_wire_shape {  noshape   }

                    set x1 [expr {$x_length * $i + $x_margin + $seq_width + $x_offset}]
                    set y1 [expr {$y_length * $j + $y_margin + $swb_router_height + $resource_height * $k - $y_offset}]
                    set x2 [expr {$x1 + $resource_width - $x_offset*2}]
                    set y2 [expr {$y1 + $y_offset*2}]
                    set area_stripe [list \\
                        $x1 $y1 \\
                        $x2 $y1 \\
                        $x2 $y2 \\
                        $x1 $y2]
                    add_stripes -nets {VDD VSS} -layer M6 -direction vertical -width $stripes_size -spacing 1.8 -set_to_set_distance $distance_stripes_between_rings -area $area_stripe -start_from left -switch_layer_over_obs false -merge_stripes_value 10 -max_same_layer_jog_length 2 -pad_core_ring_top_layer_limit AP -pad_core_ring_bottom_layer_limit M1 -block_ring_top_layer_limit AP -block_ring_bottom_layer_limit M1 -use_wire_group 0 -snap_wire_center_to_grid none
                }\n
""")

    tcl_file.write("            } else {\n")
    tcl_file.write("""\
                set_db add_stripes_ignore_block_check true ; set_db add_stripes_break_at none ; set_db add_stripes_route_over_rows_only false ; set_db add_stripes_rows_without_stripes_only false ; set_db add_stripes_extend_to_closest_target none ; set_db add_stripes_stop_at_last_wire_for_area true ; set_db add_stripes_partial_set_through_domain false ; set_db add_stripes_ignore_non_default_domains false ; set_db add_stripes_trim_antenna_back_to_shape block_ring ; set_db add_stripes_spacing_type edge_to_edge ; set_db add_stripes_spacing_from_block 0 ; set_db add_stripes_stripe_min_length stripe_width ; set_db add_stripes_stacked_via_top_layer AP ; set_db add_stripes_stacked_via_bottom_layer M1 ; set_db add_stripes_via_using_exact_crossover_size false ; set_db add_stripes_split_vias false ; set_db add_stripes_orthogonal_only true ; set_db add_stripes_allow_jog { padcore_ring  block_ring } ; set_db add_stripes_skip_via_on_pin {  standardcell } ; set_db add_stripes_skip_via_on_wire_shape {  noshape   }

                set x1 [expr {$x_length * $i + $x_margin + $seq_width + $x_offset}]
                set y1 [expr {$y_length * $j + $y_margin + $swb_router_height + $resource_height * $k - $y_offset}]
                set x2 [expr {$x1 + $resource_width - $x_offset*2}]
                set y2 [expr {$y1 + $y_offset*2}]
                set area_stripe [list \\
                    $x1 $y1 \\
                    $x2 $y1 \\
                    $x2 $y2 \\
                    $x1 $y2]
                add_stripes -nets {VDD VSS} -layer M6 -direction vertical -width $stripes_size -spacing 1.8 -set_to_set_distance $distance_stripes_between_rings -area $area_stripe -start_from left -switch_layer_over_obs false -merge_stripes_value 10 -max_same_layer_jog_length 2 -pad_core_ring_top_layer_limit AP -pad_core_ring_bottom_layer_limit M1 -block_ring_top_layer_limit AP -block_ring_bottom_layer_limit M1 -use_wire_group 0 -snap_wire_center_to_grid none
            }
        }
    }
}

""")

    tcl_file.write("#underneath resources with macros\n")
    for coord_key, cell_data in cell_coordinates.items():
        row, col = coord_key
        for resource in cell_data["resources"].values():
            if resource["macros"]:
                tcl_file.write(textwrap.dedent(f"""\
                    set_db add_stripes_ignore_block_check true ; set_db add_stripes_break_at none ; set_db add_stripes_route_over_rows_only false ; set_db add_stripes_rows_without_stripes_only false ; set_db add_stripes_extend_to_closest_target none ; set_db add_stripes_stop_at_last_wire_for_area true ; set_db add_stripes_partial_set_through_domain false ; set_db add_stripes_ignore_non_default_domains false ; set_db add_stripes_trim_antenna_back_to_shape block_ring ; set_db add_stripes_spacing_type edge_to_edge ; set_db add_stripes_spacing_from_block 0 ; set_db add_stripes_stripe_min_length stripe_width ; set_db add_stripes_stacked_via_top_layer AP ; set_db add_stripes_stacked_via_bottom_layer M1 ; set_db add_stripes_via_using_exact_crossover_size false ; set_db add_stripes_split_vias false ; set_db add_stripes_orthogonal_only true ; set_db add_stripes_allow_jog {{ padcore_ring  block_ring }} ; set_db add_stripes_skip_via_on_pin {{  standardcell }} ; set_db add_stripes_skip_via_on_wire_shape {{  noshape   }}
                    set x1 [expr {{$x_length * {col} + $x_margin + $seq_width + $x_offset}}]
                    set y1 [expr {{$y_length * {row} + $y_margin + $swb_router_height + $resource_height * {resource["slot"] - 1} - $y_offset}}]
                    set x2 [expr {{$x1 + $resource_width - $x_offset*2}}]
                    set y2 [expr {{$y1 + $y_offset*2}}]
                    set area_stripe [list \\
                    $x1 $y1 \\
                    $x2 $y1 \\
                    $x2 $y2 \\
                    $x1 $y2]
                    add_stripes -nets {{VDD VSS}} -layer M6 -direction vertical -width $stripes_size -spacing 1.8 -set_to_set_distance $distance_stripes_between_rings -area $area_stripe -start_from left -switch_layer_over_obs false -merge_stripes_value 10 -max_same_layer_jog_length 2 -pad_core_ring_top_layer_limit AP -pad_core_ring_bottom_layer_limit M1 -block_ring_top_layer_limit AP -block_ring_bottom_layer_limit M1 -use_wire_group 0 -snap_wire_center_to_grid none             
    
    """))

    tcl_file.write("\n\n\n")

    #stripes between different cells
    tcl_file.write("#stripes between different cells\n")
    tcl_file.write(textwrap.dedent("""\
        set_db add_stripes_ignore_block_check true ; set_db add_stripes_break_at none ; set_db add_stripes_route_over_rows_only false ; set_db add_stripes_rows_without_stripes_only false ; set_db add_stripes_extend_to_closest_target none ; set_db add_stripes_stop_at_last_wire_for_area true ; set_db add_stripes_partial_set_through_domain false ; set_db add_stripes_ignore_non_default_domains false ; set_db add_stripes_trim_antenna_back_to_shape block_ring ; set_db add_stripes_spacing_type edge_to_edge ; set_db add_stripes_spacing_from_block 0 ; set_db add_stripes_stripe_min_length stripe_width ; set_db add_stripes_stacked_via_top_layer AP ; set_db add_stripes_stacked_via_bottom_layer M1 ; set_db add_stripes_via_using_exact_crossover_size false ; set_db add_stripes_split_vias false ; set_db add_stripes_orthogonal_only true ; set_db add_stripes_allow_jog { padcore_ring  block_ring } ; set_db add_stripes_skip_via_on_pin {  standardcell } ; set_db add_stripes_skip_via_on_wire_shape {  noshape   }

        for {set i 0} {$i < $columns} {incr i} {
            for {set j 0} {$j < $rows-1} {incr j} {
                #between lower sequencer and upper swb
                set x1 [expr {$x_margin + $x_length * $i + $x_offset}]
                set y1 [expr {$y_margin + $y_length * ($j+1) - $y_offset}]
                set x2 [expr {$x1 + $seq_width - $x_offset * 2}]
                set y2 [expr {$y1 + $y_offset * 2}]
                set area_stripe [list \\
                    $x1 $y1 \\
                    $x2 $y1 \\
                    $x2 $y2 \\
                    $x1 $y2]
                add_stripes -nets {VDD VSS} -layer M6 -direction vertical -width $stripes_size -spacing 1.8 -set_to_set_distance $distance_stripes_between_rings -area $area_stripe -start_from left -switch_layer_over_obs false -merge_stripes_value 10 -max_same_layer_jog_length 2 -pad_core_ring_top_layer_limit AP -pad_core_ring_bottom_layer_limit M1 -block_ring_top_layer_limit AP -block_ring_bottom_layer_limit M1 -use_wire_group 0 -snap_wire_center_to_grid none

                #between lower resource and upper swb
                set x1 [expr {$x_margin + $x_length * $i + $seq_width + $x_offset}]
                set y1 [expr {$y_margin + $y_length * ($j+1) - $y_offset}]
                set x2 [expr {$x1 + $resource_width - $x_offset * 2}]
                set y2 [expr {$y1 + $y_offset * 2}]
                set area_stripe [list \\
                    $x1 $y1 \\
                    $x2 $y1 \\
                    $x2 $y2 \\
                    $x1 $y2]
                add_stripes -nets {VDD VSS} -layer M6 -direction vertical -width $stripes_size -spacing 1.8 -set_to_set_distance $distance_stripes_between_rings -area $area_stripe -start_from left -switch_layer_over_obs false -merge_stripes_value 10 -max_same_layer_jog_length 2 -pad_core_ring_top_layer_limit AP -pad_core_ring_bottom_layer_limit M1 -block_ring_top_layer_limit AP -block_ring_bottom_layer_limit M1 -use_wire_group 0 -snap_wire_center_to_grid none

                #between lower swb and upper swb
                set x1 [expr {$x_margin + $x_length * $i + $seq_width + $resource_width + $x_offset}]
                set y1 [expr {$y_margin + $y_length * ($j+1) - $y_offset}]
                set x2 [expr {$x1 + $swb_router_width - $x_offset * 2}]
                set y2 [expr {$y1 + $y_offset * 2}]
                set area_stripe [list \\
                    $x1 $y1 \\
                    $x2 $y1 \\
                    $x2 $y2 \\
                    $x1 $y2]
                add_stripes -nets {VDD VSS} -layer M6 -direction vertical -width $stripes_size -spacing 1.8 -set_to_set_distance $distance_stripes_between_rings -area $area_stripe -start_from left -switch_layer_over_obs false -merge_stripes_value 10 -max_same_layer_jog_length 2 -pad_core_ring_top_layer_limit AP -pad_core_ring_bottom_layer_limit M1 -block_ring_top_layer_limit AP -block_ring_bottom_layer_limit M1 -use_wire_group 0 -snap_wire_center_to_grid none
            }
        }   

        for {set i 0} {$i < $rows} {incr i} {
            for {set j 0} {$j < $columns-1} {incr j} {
                #between left swb and right swb
                set x1 [expr {$x_margin + $x_length * ($j+1) - $x_offset}]
                set y1 [expr {$y_margin + $y_length * $i + $y_offset}]
                set x2 [expr {$x1 + $x_offset * 2}]
                set y2 [expr {$y1 + $swb_router_height - $y_offset * 2}]
                set area_stripe [list \\
                    $x1 $y1 \\
                    $x2 $y1 \\
                    $x2 $y2 \\
                    $x1 $y2]
                add_stripes -nets {VDD VSS} -layer M7 -direction horizontal -width $stripes_size -spacing 1.8 -set_to_set_distance $distance_stripes_between_rings -area $area_stripe -start_from bottom -switch_layer_over_obs false -merge_stripes_value 10 -max_same_layer_jog_length 2 -pad_core_ring_top_layer_limit AP -pad_core_ring_bottom_layer_limit M1 -block_ring_top_layer_limit AP -block_ring_bottom_layer_limit M1 -use_wire_group 0 -snap_wire_center_to_grid none

                #between left swb and right seq
                set x1 [expr {$x_margin + $x_length * ($j+1) - $x_offset}]
                set y1 [expr {$y_margin + $y_length * $i + $swb_router_height + $y_offset}]
                set x2 [expr {$x1 + $x_offset * 2}]
                set y2 [expr {$y1 + $seq_height - $y_offset * 2}]
                set area_stripe [list \\
                    $x1 $y1 \\
                    $x2 $y1 \\
                    $x2 $y2 \\
                    $x1 $y2]
                add_stripes -nets {VDD VSS} -layer M7 -direction horizontal -width $stripes_size -spacing 1.8 -set_to_set_distance $distance_stripes_between_rings -area $area_stripe -start_from bottom -switch_layer_over_obs false -merge_stripes_value 10 -max_same_layer_jog_length 2 -pad_core_ring_top_layer_limit AP -pad_core_ring_bottom_layer_limit M1 -block_ring_top_layer_limit AP -block_ring_bottom_layer_limit M1 -use_wire_group 0 -snap_wire_center_to_grid none
            }
        }

    """))     

    tcl_file.write("\n\n")

    #stripes core rings to inner rings
    tcl_file.write("#stripes core rings to inner rings\n")
    tcl_file.write(textwrap.dedent("""\
        set_db add_stripes_ignore_block_check false ; set_db add_stripes_break_at {  block_ring  } ; set_db add_stripes_route_over_rows_only false ; set_db add_stripes_rows_without_stripes_only false ; set_db add_stripes_extend_to_closest_target ring ; set_db add_stripes_stop_at_last_wire_for_area true ; set_db add_stripes_partial_set_through_domain false ; set_db add_stripes_ignore_non_default_domains false ; set_db add_stripes_trim_antenna_back_to_shape block_ring ; set_db add_stripes_spacing_type edge_to_edge ; set_db add_stripes_spacing_from_block 0 ; set_db add_stripes_stripe_min_length stripe_width ; set_db add_stripes_stacked_via_top_layer AP ; set_db add_stripes_stacked_via_bottom_layer M1 ; set_db add_stripes_via_using_exact_crossover_size false ; set_db add_stripes_split_vias false ; set_db add_stripes_orthogonal_only true ; set_db add_stripes_allow_jog { padcore_ring  block_ring } ; set_db add_stripes_skip_via_on_pin {  standardcell } ; set_db add_stripes_skip_via_on_wire_shape {  noshape   }
        
        for {set j 0} {$j < $rows} {incr j} {
            #left side
            set x1 0
            set y1 [expr {$y_margin + $y_offset + $y_length * $j}]
            set x2 [expr {$x1 + $x_margin + $x_offset}]
            set y2 [expr {$y1 + $swb_router_height - $y_offset * 2}]
            set area_stripe [list \\
                $x1 $y1 \\
                $x2 $y1 \\
                $x2 $y2 \\
                $x1 $y2]
            add_stripes -nets {VDD VSS} -layer M7 -direction horizontal -width $stripes_size -spacing 1.8 -set_to_set_distance $distance_stripes_between_rings -area $area_stripe -start_from bottom -switch_layer_over_obs false -merge_stripes_value 10 -max_same_layer_jog_length 2 -pad_core_ring_top_layer_limit AP -pad_core_ring_bottom_layer_limit M1 -block_ring_top_layer_limit AP -block_ring_bottom_layer_limit M1 -use_wire_group 0 -snap_wire_center_to_grid none

            set x1 0
            set y1 [expr {$y_margin + $y_offset + $y_length * $j + $swb_router_height}]
            set x2 [expr {$x1 + $x_margin + $x_offset}]
            set y2 [expr {$y1 + $seq_height - $y_offset * 2}]
            set area_stripe [list \\
                $x1 $y1 \\
                $x2 $y1 \\
                $x2 $y2 \\
                $x1 $y2]
            add_stripes -nets {VDD VSS} -layer M7 -direction horizontal -width $stripes_size -spacing 1.8 -set_to_set_distance $distance_stripes_between_rings -area $area_stripe -start_from bottom -switch_layer_over_obs false -merge_stripes_value 10 -max_same_layer_jog_length 2 -pad_core_ring_top_layer_limit AP -pad_core_ring_bottom_layer_limit M1 -block_ring_top_layer_limit AP -block_ring_bottom_layer_limit M1 -use_wire_group 0 -snap_wire_center_to_grid none

            #right side
            set x1 [expr {$x_margin + $x_length * $columns - $x_offset}]
            set y1 [expr {$y_margin + $y_offset + $y_length * $j}]
            set x2 [expr {$x1 + $x_margin + $x_offset}]
            set y2 [expr {$y1 + $swb_router_height + $seq_height - $y_offset * 2}]
            set area_stripe [list \\
                $x1 $y1 \\
                $x2 $y1 \\
                $x2 $y2 \\
                $x1 $y2]
            add_stripes -nets {VDD VSS} -layer M7 -direction horizontal -width $stripes_size -spacing 1.8 -set_to_set_distance $distance_stripes_between_rings -area $area_stripe -start_from bottom -switch_layer_over_obs false -merge_stripes_value 10 -max_same_layer_jog_length 2 -pad_core_ring_top_layer_limit AP -pad_core_ring_bottom_layer_limit M1 -block_ring_top_layer_limit AP -block_ring_bottom_layer_limit M1 -use_wire_group 0 -snap_wire_center_to_grid none
        }

        for {set i 0} {$i < $columns} {incr i} {
            #bottom side
            set x1 [expr {$x_margin + $x_offset + $x_length *$i}]
            set y1 0
            set x2 [expr {$x1 + $seq_width + $resource_width + $swb_router_width -$x_offset * 2}]
            set y2 [expr {$y1 + $y_margin + $y_offset}]
            set area_stripe [list \\
                $x1 $y1 \\
                $x2 $y1 \\
                $x2 $y2 \\
                $x1 $y2]
            add_stripes -nets {VDD VSS} -layer M6 -direction vertical -width $stripes_size -spacing 1.8 -set_to_set_distance $distance_stripes_between_rings -area $area_stripe -start_from left -switch_layer_over_obs false -merge_stripes_value 10 -max_same_layer_jog_length 2 -pad_core_ring_top_layer_limit AP -pad_core_ring_bottom_layer_limit M1 -block_ring_top_layer_limit AP -block_ring_bottom_layer_limit M1 -use_wire_group 0 -snap_wire_center_to_grid none

            #top side
            set x1 [expr {$x_margin + $x_offset + $x_length *$i}]
            set y1 [expr {$y_margin + $y_length * $rows - $y_offset}]
            set x2 [expr {$x1 + $seq_width -$x_offset * 2}]
            set y2 [expr {$y1 + $y_margin + $y_offset}]
            set area_stripe [list \\
                $x1 $y1 \\
                $x2 $y1 \\
                $x2 $y2 \\
                $x1 $y2]
            add_stripes -nets {VDD VSS} -layer M6 -direction vertical -width $stripes_size -spacing 1.8 -set_to_set_distance $distance_stripes_between_rings -area $area_stripe -start_from left -switch_layer_over_obs false -merge_stripes_value 10 -max_same_layer_jog_length 2 -pad_core_ring_top_layer_limit AP -pad_core_ring_bottom_layer_limit M1 -block_ring_top_layer_limit AP -block_ring_bottom_layer_limit M1 -use_wire_group 0 -snap_wire_center_to_grid none

            set x1 [expr {$x_margin + $seq_width + $x_offset + $x_length *$i}]
            set y1 [expr {$y_margin + $y_length * $rows - $y_offset}]
            set x2 [expr {$x1 + $resource_width - $x_offset * 2}]
            set y2 [expr {$y1 + $y_margin + $y_offset}]
            set area_stripe [list \\
                $x1 $y1 \\
                $x2 $y1 \\
                $x2 $y2 \\
                $x1 $y2]
            add_stripes -nets {VDD VSS} -layer M6 -direction vertical -width $stripes_size -spacing 1.8 -set_to_set_distance $distance_stripes_between_rings -area $area_stripe -start_from left -switch_layer_over_obs false -merge_stripes_value 10 -max_same_layer_jog_length 2 -pad_core_ring_top_layer_limit AP -pad_core_ring_bottom_layer_limit M1 -block_ring_top_layer_limit AP -block_ring_bottom_layer_limit M1 -use_wire_group 0 -snap_wire_center_to_grid none

            set x1 [expr {$x_margin + $seq_width + $resource_width + $x_offset + $x_length *$i}]
            set y1 [expr {$y_margin + $y_length * $rows - $y_offset}]
            set x2 [expr {$x1 + $swb_router_width - $x_offset * 2}]
            set y2 [expr {$y1 + $y_margin + $y_offset}]
            set area_stripe [list \\
                $x1 $y1 \\
                $x2 $y1 \\
                $x2 $y2 \\
                $x1 $y2]
            add_stripes -nets {VDD VSS} -layer M6 -direction vertical -width $stripes_size -spacing 1.8 -set_to_set_distance $distance_stripes_between_rings -area $area_stripe -start_from left -switch_layer_over_obs false -merge_stripes_value 10 -max_same_layer_jog_length 2 -pad_core_ring_top_layer_limit AP -pad_core_ring_bottom_layer_limit M1 -block_ring_top_layer_limit AP -block_ring_bottom_layer_limit M1 -use_wire_group 0 -snap_wire_center_to_grid none
        }
    """))       

    tcl_file.write("\n\n\n")  

    # final special route
    tcl_file.write(textwrap.dedent("""\
        #final special route for cells' pins
        reset_db -category route_special
        set_db route_special_endcap_as_core true

        route_special \\
        -nets { VDD VSS } \\
        -connect {core_pin floating_stripe} \\
        -allow_layer_change 1 \\
        -layer_change_range { M1(1) AP(10) } \\
        -allow_jogging 1 \\
        -crossover_via_layer_range { M1(1) AP(10) } \\
        -core_pin_target { none }
    """))       

    tcl_file.write("\n\n\n")

    #to fix missing vias
    tcl_file.write("#to fix missing vias\n")
    tcl_file.write("update_power_vias -skip_via_on_pin standardcell -bottom_layer M1 -nets {VDD VSS} -add_vias 1 -top_layer AP\n")
      
print("✅ Power planning TCL script successfully generated as 'power_planning.tcl'!")



###################################################################################################################################################################################



#pins_constraints.tcl
bulk_bitwidth = 256
layer_out_horiz = "M2"
layer_in_horiz = "M4"
layer_out_vert = "M3"
layer_in_vert = "M5"

layer_in_north = "M2"
layer_out_south = "M2"
layer_in_south = "M4"
layer_out_north = "M4"

layer_in_west = "M3"
layer_out_east = "M3"
layer_in_east = "M5"
layer_out_west = "M5"



layer_bulk_intracell_out = "M3"
layer_bulk_intracell_in = "M5"
layer_word_out = "M3"
layer_word_in = "M5"
pin_margin = 1.5
pin_pitch1 = 0.28
pin_pitch2 = 0.2
pin_pitch3 = 0.4

with open(pins_constraints_tcl_file_path, "w") as tcl_file:

    tcl_file.write("# Define pins constraints variables\n")
    tcl_file.write(f"set bulk_bitwidth {bulk_bitwidth}\n")
    tcl_file.write(f"set layer_in_north {layer_in_north}\n")
    tcl_file.write(f"set layer_out_south {layer_out_south}\n")
    tcl_file.write(f"set layer_in_south {layer_in_south}\n")
    tcl_file.write(f"set layer_out_north {layer_out_north}\n")
    tcl_file.write(f"set layer_in_west {layer_in_west}\n")
    tcl_file.write(f"set layer_out_east {layer_out_east}\n")
    tcl_file.write(f"set layer_in_east {layer_in_east}\n")
    tcl_file.write(f"set layer_out_west {layer_out_west}\n")
    tcl_file.write(f"set layer_bulk_intracell_out {layer_bulk_intracell_out}\n")
    tcl_file.write(f"set layer_bulk_intracell_in {layer_bulk_intracell_in}\n")
    tcl_file.write(f"set layer_word_out {layer_word_out}\n")
    tcl_file.write(f"set layer_word_in {layer_word_in}\n")
    tcl_file.write(f"set pin_margin {pin_margin}\n")
    tcl_file.write(f"set pin_pitch1 {pin_pitch1}\n")
    tcl_file.write(f"set pin_pitch2 {pin_pitch2}\n")
    tcl_file.write(f"set pin_pitch3 {pin_pitch3}\n\n")

    tcl_file.write("#constraints for N,S,W,E pins for switchbox/router partition\n")
    tcl_file.write("for {set i 0} {$i < $bulk_bitwidth} {incr i} {\n")

    for coord_key, cell_data in cell_coordinates.items():
        for resource in cell_data["resources"].values():
            if(resource["resource_type"] == "swb_impl"):
                resource_fingerprint = resource["resource_fingerprint"]
                tcl_file.write(f"    set_pin_constraint -cell {resource_fingerprint} -pins \"bulk_intercell_w_out[$i]\" -location [list 0 [expr {{$pin_margin + $pin_pitch2 * $i}}] $layer_out_west]\n")
                tcl_file.write(f"    set_pin_constraint -cell {resource_fingerprint} -pins \"bulk_intercell_w_in[$i]\" -location [list 0 [expr {{$pin_margin + $pin_pitch2 * $i}}] $layer_in_west]\n")
                tcl_file.write(f"    set_pin_constraint -cell {resource_fingerprint} -pins \"bulk_intercell_n_out[$i]\" -location [list [expr {{$seq_width + $resource_width + $swb_router_width - $pin_margin - $pin_pitch2 * $i}}] [expr {{$swb_router_height + $seq_height}}] $layer_out_north]\n")
                tcl_file.write(f"    set_pin_constraint -cell {resource_fingerprint} -pins \"bulk_intercell_n_in[$i]\" -location [list [expr {{$seq_width + $resource_width + $swb_router_width - $pin_margin - $pin_pitch1 * $i}}] [expr {{$swb_router_height + $seq_height}}] $layer_in_north]\n")
                tcl_file.write(f"    set_pin_constraint -cell {resource_fingerprint} -pins \"bulk_intercell_e_out[$i]\" -location [list [expr {{$seq_width + $resource_width + $swb_router_width}}] [expr {{$pin_margin + $pin_pitch2 * $i}}] $layer_out_east]\n")
                tcl_file.write(f"    set_pin_constraint -cell {resource_fingerprint} -pins \"bulk_intercell_e_in[$i]\" -location [list [expr {{$seq_width + $resource_width + $swb_router_width}}] [expr {{$pin_margin + $pin_pitch2 * $i}}] $layer_in_east]\n")
                tcl_file.write(f"    set_pin_constraint -cell {resource_fingerprint} -pins \"bulk_intercell_s_out[$i]\" -location [list [expr {{$seq_width + $resource_width + $swb_router_width - $pin_margin - $pin_pitch1 * $i}}] 0 $layer_out_south]\n")
                tcl_file.write(f"    set_pin_constraint -cell {resource_fingerprint} -pins \"bulk_intercell_s_in[$i]\" -location [list [expr {{$seq_width + $resource_width + $swb_router_width - $pin_margin - $pin_pitch2 * $i}}] 0 $layer_in_south]\n")

    tcl_file.write("}\n\n\n\n")

    tcl_file.write("#constraints for intracell connections for switchbox/router partition (between switchbox/router and resources' slots)\n")
    tcl_file.write("for {set z 0} {$z < 15} {incr z} {\n")
    tcl_file.write("    for {set i 0} {$i < $bulk_bitwidth} {incr i} {\n")
    for coord_key, cell_data in cell_coordinates.items():
        for resource in cell_data["resources"].values():
            if(resource["resource_type"] == "swb_impl"):
                resource_fingerprint = resource["resource_fingerprint"]
                tcl_file.write(f"    set_pin_constraint -cell {resource_fingerprint} -pins \"bulk_intracell_out[[expr {{$z + 1}}]][$i]\" -location [list [expr {{$seq_width + $resource_width}}] [expr {{$swb_router_height + $resource_height * $z + $pin_margin + $pin_pitch2 * $i}}] $layer_bulk_intracell_out]\n")
                tcl_file.write(f"    set_pin_constraint -cell {resource_fingerprint} -pins \"bulk_intracell_in[[expr {{$z + 1}}]][$i]\" -location [list [expr {{$seq_width + $resource_width}}] [expr {{$swb_router_height + $resource_height * $z + $pin_margin + $pin_pitch2 * $i}}] $layer_bulk_intracell_in]\n")

    tcl_file.write("    }\n")
    tcl_file.write("}\n\n")

    tcl_file.write("for {set z 0} {$z < 15} {incr z} {\n")
    tcl_file.write("    for {set i 0} {$i < 16} {incr i} {\n")
    for coord_key, cell_data in cell_coordinates.items():
        for resource in cell_data["resources"].values():
            if(resource["resource_type"] == "swb_impl"):
                resource_fingerprint = resource["resource_fingerprint"]
                tcl_file.write(f"    set_pin_constraint -cell {resource_fingerprint} -pins \"word_channels_out[[expr {{$z + 1}}]][$i]\" -location [list [expr {{$seq_width + $resource_width}}] [expr {{$swb_router_height + $resource_height * $z + $pin_margin + $pin_pitch3 * $i}}] M7]\n")
                tcl_file.write(f"    set_pin_constraint -cell {resource_fingerprint} -pins \"word_channels_in[[expr {{$z + 1}}]][$i]\" -location [list [expr {{$seq_width + $resource_width}}] [expr {{$swb_router_height + $resource_height * ($z + 1) - $pin_margin - $pin_pitch3 * $i}}] M7]\n")

    tcl_file.write("    }\n")
    tcl_file.write("}\n\n\n\n")


    tcl_file.write("#constraints for instruction bus to resources from sequencer\n")
    tcl_file.write("for {set z 0} {$z < 15} {incr z} {\n")
    tcl_file.write("    for {set i 0} {$i < 27} {incr i} {\n")
    for coord_key, cell_data in cell_coordinates.items():
        controller_fingerprint = cell_data["controller"]["fingerprint"]
        tcl_file.write(f"    set_pin_constraint -cell {controller_fingerprint} -pins \"instr_[expr {{$z + 1}}][$i]\" -location [list [expr {{$seq_width}}] [expr {{$resource_height * $z + $pin_margin + $pin_pitch2 * $i }}] M3]\n")
      
    tcl_file.write("    }\n")
    tcl_file.write("}\n\n\n\n")


    tcl_file.write("#constraints for clk/rst/activate to resources from sequencer\n")
    tcl_file.write("for {set z 0} {$z < 15} {incr z} {\n")
    for coord_key, cell_data in cell_coordinates.items():
        controller_fingerprint = cell_data["controller"]["fingerprint"]
        tcl_file.write(f"    set_pin_constraint -cell {controller_fingerprint} -pins \"clk_[expr {{$z + 1}}]\" -location [list [expr {{$seq_width}}] [expr {{$resource_height * $z + $pin_margin + $pin_pitch2 * 27 }}] M3]\n")
        tcl_file.write(f"    set_pin_constraint -cell {controller_fingerprint} -pins \"rst_n_[expr {{$z + 1}}]\" -location [list [expr {{$seq_width}}] [expr {{$resource_height * $z + $pin_margin + $pin_pitch2 * 28 }}] M3]\n")
        tcl_file.write(f"    set_pin_constraint -cell {controller_fingerprint} -pins \"activate_[expr {{$z + 1}}][0]\" -location [list [expr {{$seq_width}}] [expr {{$resource_height * $z + $pin_margin + $pin_pitch2 * 29 }}] M3]\n")
        tcl_file.write(f"    set_pin_constraint -cell {controller_fingerprint} -pins \"activate_[expr {{$z + 1}}][1]\" -location [list [expr {{$seq_width}}] [expr {{$resource_height * $z + $pin_margin + $pin_pitch2 * 30 }}] M3]\n")
        tcl_file.write(f"    set_pin_constraint -cell {controller_fingerprint} -pins \"activate_[expr {{$z + 1}}][2]\" -location [list [expr {{$seq_width}}] [expr {{$resource_height * $z + $pin_margin + $pin_pitch2 * 31 }}] M3]\n")
        tcl_file.write(f"    set_pin_constraint -cell {controller_fingerprint} -pins \"activate_[expr {{$z + 1}}][3]\" -location [list [expr {{$seq_width}}] [expr {{$resource_height * $z + $pin_margin + $pin_pitch2 * 32 }}] M3]\n")
        tcl_file.write(f"    set_pin_constraint -cell {controller_fingerprint} -pins \"instr_valid_[expr {{$z + 1}}]\" -location [list [expr {{$seq_width}}] [expr {{$resource_height * $z + $pin_margin + $pin_pitch2 * 33 }}] M3]\n")

    tcl_file.write("}\n\n\n\n")


    tcl_file.write("#constraints for instruction bus to swb from sequencer\n")
    tcl_file.write("for {set i 0} {$i < 27} {incr i} {\n")
    for coord_key, cell_data in cell_coordinates.items():
        controller_fingerprint = cell_data["controller"]["fingerprint"]
        tcl_file.write(f"    set_pin_constraint -cell {controller_fingerprint} -pins \"instr_0[$i]\" -location [list [expr {{$pin_margin + $pin_pitch2 * $i}}] 0 M4]\n")

    tcl_file.write("}\n\n\n\n")

    tcl_file.write("#constraints for clk/rst/activate to swb from sequencer\n")
    for coord_key, cell_data in cell_coordinates.items():
        controller_fingerprint = cell_data["controller"]["fingerprint"]
        tcl_file.write(f"set_pin_constraint -cell {controller_fingerprint} -pins \"clk_0\" -location [list [expr {{$pin_margin + $pin_pitch2 * 27}}] 0 M4]\n")
        tcl_file.write(f"set_pin_constraint -cell {controller_fingerprint} -pins \"rst_n_0\" -location [list [expr {{$pin_margin + $pin_pitch2 * 28}}] 0 M4]\n")
        tcl_file.write(f"set_pin_constraint -cell {controller_fingerprint} -pins \"activate_0[0]\" -location [list [expr {{$pin_margin + $pin_pitch2 * 29}}] 0 M4]\n")
        tcl_file.write(f"set_pin_constraint -cell {controller_fingerprint} -pins \"activate_0[1]\" -location [list [expr {{$pin_margin + $pin_pitch2 * 30}}] 0 M4]\n")
        tcl_file.write(f"set_pin_constraint -cell {controller_fingerprint} -pins \"activate_0[2]\" -location [list [expr {{$pin_margin + $pin_pitch2 * 31}}] 0 M4]\n")
        tcl_file.write(f"set_pin_constraint -cell {controller_fingerprint} -pins \"activate_0[3]\" -location [list [expr {{$pin_margin + $pin_pitch2 * 32}}] 0 M4]\n")
        tcl_file.write(f"set_pin_constraint -cell {controller_fingerprint} -pins \"instr_valid_0\" -location [list [expr {{$pin_margin + $pin_pitch2 * 33}}] 0 M4]\n")
    tcl_file.write("\n\n\n\n")

print("✅ Pins constraints script successfully generated as 'pins_constraints.tcl'!")

