"""
------------------------------------------------------------------------------
DRRA2 Physical Design Automation Script (Flat Implementation)
Author: Davide Finazzi
Project: Backend Automation for DRRA2 - Automating Floorplanning and Power Planning in the SiLago Framework
------------------------------------------------------------------------------

Description:
------------
This script generates a TCL floorplan for a flat (non-hierarchical) implementation 
of the DRRA2 fabric. It serves as a reference baseline for comparison against 
the hierarchical floorplan generated using SiLago-style abutment and cell-level fencing.

The flat design does not enforce physical hierarchy or modular partitioning.
All macros and standard cells are placed globally within a single monolithic floorplan.
This setup is useful to evaluate trade-offs in:
  - Area efficiency
  - Wirelength and congestion
  - Power grid continuity
  - Routing complexity
  - Timing and IR drop behavior

Inputs:
-------
- arch.json: Describes DRRA2 grid dimensions, resource types, and layout rules
- fabric.v: Verilog netlist from logic synthesis

Outputs:
--------
- floorplan.tcl: A TCL script that defines the full flat core region,
  macro placement, floorplan constraints, and blockages for Cadence Innovus.

Usage:
------
Simply run the script in a Python 3 environment. The output file will be written 
to the current working directory.

"""


import json
import re
from collections import defaultdict
import textwrap

# Define file paths
json_file_path = "arch.json"
netlist_file_path = "fabric.v"
floorplan_tcl_file_path = "floorplan.tcl"
design_variables_tcl_file_path = "design_variables.tcl"
power_planning_tcl_file_path = "power_planning.tcl"
pins_constraints_tcl_file_path = "pin_constraints.tcl"


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



#floorplan.tcl
x_margin = 28
y_margin = 27
resource_width = 291.2
resource_height = 63
swb_router_width = 106.4
swb_router_height = 63
seq_width = 67.2
seq_height = resource_height * 16
x_sram_macro = 50
y_sram_macro = 31.4
distance_sram_macros_x = 45
distance_sram_macros_y = 30

x_length = seq_width + resource_width + swb_router_width + x_margin * 2
y_length = swb_router_height + seq_height + y_margin * 2

with open(floorplan_tcl_file_path, "w") as tcl_file:
    tcl_file.write("# X should be multiple of 5.6\n")
    tcl_file.write("# Y should be multiple of 9.0\n\n")

    # Define TCL variables
    tcl_file.write(f"set side 749.7\n")
    tcl_file.write(f"set x_side 627.2\n")
    tcl_file.write("set y_side [expr {$x_side * 2}]\n")
    tcl_file.write(f"set x_sram_macro {x_sram_macro}\n")
    tcl_file.write(f"set y_sram_macro {y_sram_macro}\n")
    tcl_file.write(f"set distance_sram_macros_x {distance_sram_macros_x}\n")
    tcl_file.write(f"set distance_sram_macros_y {distance_sram_macros_y}\n")
    tcl_file.write("set macro_coords_list {}\n")

    tcl_file.write("create_floorplan -core_margins_by io -site core -core_size [expr {$x_side}] [expr {$y_side}] 0 0 0 0\n")

    for coord_key, cell_data in cell_coordinates.items():
        row, col = coord_key
        cell_instance = cell_data["cell_instance"]
        tcl_file.write(f"\n# Cell {cell_instance} at (row: {row}, col: {col})\n")

        # Resource Placement
        prev_size = 0
        swb_instance_name = None

        for resource in cell_data["resources"].values():
            module_name = resource["resource_fingerprint"]
            instance_name = resource["instance_name"]
            if resource["macros"]:
                tcl_file.write("\n#Resource's Macros placement\n")
                macro_num = 0
                for macro in resource["macros"]:
                    if row == 2 and col == 0 and macro_num == 0:
                        tcl_file.write("set x3 [expr {$x_sram_macro}]\n")
                        tcl_file.write("set y3 [expr {$y_sram_macro}]\n")
                        tcl_file.write(f"place_inst {cell_instance}/{instance_name}/{macro} $x3 $y3\n")
                        tcl_file.write(f"set bbox0 [get_db inst:{cell_instance}/{instance_name}/{macro} .bbox]\n")
                        tcl_file.write("lappend macro_coords_list [concat {*}$bbox0]\n\n")
                    elif row == 2 and col == 1 and macro_num == 0:
                        tcl_file.write(f"set prev_macro_width [get_db inst:{cell_instance}/{instance_name}/{prev_macro} .bbox.width]\n")     
                        tcl_file.write("set x3 [expr {$x_sram_macro + $prev_macro_width*4 + $distance_sram_macros_x*4}]\n")
                        tcl_file.write("set y3 [expr {$y_sram_macro}]\n")         
                        tcl_file.write(f"place_inst {cell_instance}/{instance_name}/{macro} $x3 $y3\n")
                        tcl_file.write(f"set bbox0 [get_db inst:{cell_instance}/{instance_name}/{macro} .bbox]\n")
                        tcl_file.write("lappend macro_coords_list [concat {*}$bbox0]\n\n")
                    elif row == 2 and col == 1 and macro_num == 2:
                        tcl_file.write("set x3 [expr {$x_sram_macro}]\n")
                        tcl_file.write(f"set macro_height [get_db inst:{cell_instance}/{instance_name}/{prev_macro} .bbox.length]\n")
                        tcl_file.write("set y3 [expr {$y_sram_macro + $macro_height + $distance_sram_macros_y}]\n")
                        tcl_file.write(f"place_inst {cell_instance}/{instance_name}/{macro} $x3 $y3\n")
                        tcl_file.write(f"set bbox0 [get_db inst:{cell_instance}/{instance_name}/{macro} .bbox]\n")
                        tcl_file.write("lappend macro_coords_list [concat {*}$bbox0]\n\n")
                    elif row == 2 and col == 2 and macro_num == 0:
                        tcl_file.write(f"set prev_macro_width [get_db inst:{cell_instance}/{instance_name}/{prev_macro} .bbox.width]\n")     
                        tcl_file.write("set x3 [expr {$x_sram_macro + $prev_macro_width*2 + $distance_sram_macros_x*2}]\n")
                        tcl_file.write(f"set macro_height [get_db inst:{cell_instance}/{instance_name}/{prev_macro} .bbox.length]\n") 
                        tcl_file.write("set y3 [expr {$y_sram_macro + $macro_height + $distance_sram_macros_y}]\n")         
                        tcl_file.write(f"place_inst {cell_instance}/{instance_name}/{macro} $x3 $y3\n")
                        tcl_file.write(f"set bbox0 [get_db inst:{cell_instance}/{instance_name}/{macro} .bbox]\n")
                        tcl_file.write("lappend macro_coords_list [concat {*}$bbox0]\n\n")
                    elif row == 0 and col == 0 and macro_num == 0:
                        tcl_file.write("set x3 [expr {$x_sram_macro}]\n")
                        tcl_file.write(f"set macro_height [get_db inst:{cell_instance}/{instance_name}/{prev_macro} .bbox.length]\n") 
                        tcl_file.write("set y3 [expr {$y_side - $macro_height - $y_sram_macro}]\n")
                        tcl_file.write(f"place_inst {cell_instance}/{instance_name}/{macro} $x3 $y3\n")
                        tcl_file.write(f"set bbox0 [get_db inst:{cell_instance}/{instance_name}/{macro} .bbox]\n")
                        tcl_file.write("lappend macro_coords_list [concat {*}$bbox0]\n\n")
                    elif row == 0 and col == 1 and macro_num == 0:       
                        tcl_file.write(f"set prev_macro_width [get_db inst:{cell_instance}/{instance_name}/{prev_macro} .bbox.width]\n")     
                        tcl_file.write("set x3 [expr {$x_sram_macro + $prev_macro_width*4 + $distance_sram_macros_x*4}]\n")
                        tcl_file.write(f"set macro_height [get_db inst:{cell_instance}/{instance_name}/{prev_macro} .bbox.length]\n") 
                        tcl_file.write("set y3 [expr {$y_side - $macro_height - $y_sram_macro}]\n")      
                        tcl_file.write(f"place_inst {cell_instance}/{instance_name}/{macro} $x3 $y3\n")
                        tcl_file.write(f"set bbox0 [get_db inst:{cell_instance}/{instance_name}/{macro} .bbox]\n")
                        tcl_file.write("lappend macro_coords_list [concat {*}$bbox0]\n\n")
                    elif row == 0 and col == 1 and macro_num == 2:        
                        tcl_file.write("set x3 [expr {$x_sram_macro}]\n")
                        tcl_file.write(f"set macro_height [get_db inst:{cell_instance}/{instance_name}/{prev_macro} .bbox.length]\n") 
                        tcl_file.write("set y3 [expr {$y_side - ($y_sram_macro + $macro_height*2 + $distance_sram_macros_y)}]\n")           
                        tcl_file.write(f"place_inst {cell_instance}/{instance_name}/{macro} $x3 $y3\n")
                        tcl_file.write(f"set bbox0 [get_db inst:{cell_instance}/{instance_name}/{macro} .bbox]\n")
                        tcl_file.write("lappend macro_coords_list [concat {*}$bbox0]\n\n")
                    elif row == 0 and col == 2 and macro_num == 0:       
                        tcl_file.write(f"set prev_macro_width [get_db inst:{cell_instance}/{instance_name}/{prev_macro} .bbox.width]\n")     
                        tcl_file.write("set x3 [expr {$x_sram_macro + $prev_macro_width*2 + $distance_sram_macros_x*2}]\n")
                        tcl_file.write(f"set macro_height [get_db inst:{cell_instance}/{instance_name}/{prev_macro} .bbox.length]\n") 
                        tcl_file.write("set y3 [expr {$y_side - ($y_sram_macro + $macro_height*2 + $distance_sram_macros_y)}]\n")        
                        tcl_file.write(f"place_inst {cell_instance}/{instance_name}/{macro} $x3 $y3\n")
                        tcl_file.write(f"set bbox0 [get_db inst:{cell_instance}/{instance_name}/{macro} .bbox]\n")
                        tcl_file.write("lappend macro_coords_list [concat {*}$bbox0]\n\n")
                    else:
                        tcl_file.write(f"set prev_macro_width [get_db inst:{cell_instance}/{instance_name}/{prev_macro} .bbox.width]\n")     
                        tcl_file.write("set x3 [expr {$x3 + $prev_macro_width + $distance_sram_macros_x}]\n")         
                        tcl_file.write(f"place_inst {cell_instance}/{instance_name}/{macro} $x3 $y3\n")
                        tcl_file.write(f"set bbox0 [get_db inst:{cell_instance}/{instance_name}/{macro} .bbox]\n")
                        tcl_file.write("lappend macro_coords_list [concat {*}$bbox0]\n\n")

                    prev_macro = macro
                    macro_num += 1

    tcl_file.write("\n")

    tcl_file.write(textwrap.dedent("""\
        #placement blockage below and above macros

        set updated_macro_coords_list {}

        foreach bbox $macro_coords_list {
            lassign $bbox x_min y_min x_max y_max

            # Modify y_min/y_max (option 1: shift)
            set y_min [expr {$y_min - 1.8}]
            set y_max [expr {$y_max + 1.8}]

            # Append updated bbox to new list
            lappend updated_macro_coords_list [list $x_min $y_min $x_max $y_max]
        }

        create_place_blockage -rects $updated_macro_coords_list

    """))

    tcl_file.write(textwrap.dedent("""\
        set x_offset 16.8
        set y_offset 16.8
        set x1 0
        set y1 0
        set x2 [expr {$x1 + $x_side}]
        set y2 [expr {$y_offset}]

        set area_blockage [list \\
            $x1 $y1 \\
            $x2 $y2]
        create_place_blockage -area $area_blockage

        set x1 [expr {$x_side - $x_offset}]
        set y1 0
        set x2 [expr {$x1 + $x_offset}]
        set y2 [expr {$y1 + $y_side}]

        set area_blockage [list \\
            $x1 $y1 \\
            $x2 $y2]
        create_place_blockage -area $area_blockage

        set x1 0
        set y1 [expr {$y_side - $y_offset}]
        set x2 [expr {$x1 + $x_side}]
        set y2 [expr {$y1 + $y_offset}]

        set area_blockage [list \\
            $x1 $y1 \\
            $x2 $y2]
        create_place_blockage -area $area_blockage

        set x1 0
        set y1 0
        set x2 [expr {$x1 + $x_offset}]
        set y2 [expr {$y1 + $y_side}]

        set area_blockage [list \\
            $x1 $y1 \\
            $x2 $y2]
        create_place_blockage -area $area_blockage

    """))

    tcl_file.write(textwrap.dedent("""\
        # add endcaps
        set_db add_endcaps_right_edge BOUNDARY_RIGHTBWP30P140
        set_db add_endcaps_left_edge BOUNDARY_LEFTBWP30P140
        add_endcaps

        # add well taps
        add_well_taps -checker_board -cell_interval 30 -cell TAPCELLBWP30P140

    """))

    tcl_file.write("\n# Floorplan generation complete\n")

print("✅ Floorplan TCL script successfully generated as 'floorplan.tcl'")
