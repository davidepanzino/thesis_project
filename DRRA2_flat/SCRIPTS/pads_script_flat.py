"""
------------------------------------------------------------------------------
VDD/VSS Pad Generation Script (Flat Implementation)
Author: Davide Finazzi
Project: Backend Automation for DRRA2 - Automating Floorplanning and Power Planning in the SiLago Framework
------------------------------------------------------------------------------

Description:
------------
This script generates the VDD and VSS pad coordinate files for the flat 
(non-hierarchical) implementation of the DRRA2 fabric. These pads represent 
external voltage sources placed along the boundary of the layout to enable 
accurate power and rail analysis in Cadence Innovus.

Pads are placed uniformly along:
  - Left and right sides of the core on the M7 layer (vertical power stripes)
  - Top and bottom sides of the core on the M8 layer (horizontal power stripes)

Outputs:
--------
- vdd_sources.pp: Contains VDD pad positions with the format:
      *vsrc_name   x   y   layer_name
- vss_sources.pp: Contains VSS pad positions with the same format

Usage:
------
Simply run the script in a Python 3 environment. The output files will be written 
to the current working directory.

"""

rows = 3
columns = 3

side = 749.7
x_side = 627.2
y_side = 1254.4
x_sram_macro = 50
y_sram_macro = 31.4
distance_sram_macros_x = 30
distance_sram_macros_y = 30

vertical_pairs = 6
horizontal_pairs = 3
vertical_distance = y_side/(vertical_pairs + 1)
horizontal_distance = x_side/(horizontal_pairs + 1)
x_offset = 8.0
y_offset = 8.0

num_stripes_per_row = vertical_pairs
num_stripes_per_column = horizontal_pairs

vdd_list = []
vss_list = []
vdd_counter = 1
vss_counter = 1

# === VDDvsrc Pads ===

# M7 Pads (left and right sides)

for k in range(num_stripes_per_row):
    y_coord = vertical_distance * (k+1) + 2.5

    # Left side
    x_left = 0.0
    vdd_list.append((f"VDDvsrc{vdd_counter}", x_left, y_coord, "M7"))
    vdd_counter += 1

    # Right side
    x_right = x_side
    vdd_list.append((f"VDDvsrc{vdd_counter}", x_right, y_coord, "M7"))
    vdd_counter += 1

# M8 Pads (bottom and top sides)

for k in range(num_stripes_per_column):
    x_coord = horizontal_distance * (k+1) + 2.5

    # Bottom side
    y_bottom = 0.0
    vdd_list.append((f"VDDvsrc{vdd_counter}", x_coord, y_bottom, "M8"))
    vdd_counter += 1

    # Top side
    y_top = y_side
    vdd_list.append((f"VDDvsrc{vdd_counter}", x_coord, y_top, "M8"))
    vdd_counter += 1

# === VSSvsrc Pads ===

# M7 Pads (left and right sides)

for k in range(num_stripes_per_row):
    y_coord_vss = vertical_distance * (k+1) + 2.5 + 6.8  # +6.8 on y

    # Left side
    x_left = 0.0
    vss_list.append((f"VSSvsrc{vss_counter}", x_left, y_coord_vss, "M7"))
    vss_counter += 1

    # Right side
    x_right = x_side
    vss_list.append((f"VSSvsrc{vss_counter}", x_right, y_coord_vss, "M7"))
    vss_counter += 1

# M8 Pads (bottom and top sides)

for k in range(num_stripes_per_column):
    x_coord_vss = horizontal_distance * (k+1) + 2.5 + 6.8  # +6.8 on x

    # Bottom side
    y_bottom = 0.0
    vss_list.append((f"VSSvsrc{vss_counter}", x_coord_vss, y_bottom, "M8"))
    vss_counter += 1

    # Top side
    y_top = y_side
    vss_list.append((f"VSSvsrc{vss_counter}", x_coord_vss, y_top, "M8"))
    vss_counter += 1

# === Write to files ===

def write_pad_file(filename, pad_entries):
    with open(filename, "w") as f:
        f.write("*vsrc_name   x   y   layer_name\n")
        for name, x, y, layer in pad_entries:
            f.write(f"{name} {x:.3f} {y:.3f} {layer}\n")

write_pad_file("vdd_sources.pp", vdd_list)
write_pad_file("vss_sources.pp", vss_list)

