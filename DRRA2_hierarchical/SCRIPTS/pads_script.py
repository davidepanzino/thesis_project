"""
------------------------------------------------------------------------------
Pad Source Generation Script for Rail Analysis
Author: Davide Finazzi
Project: Backend Automation for DRRA2 - Automating Floorplanning and Power Planning in the SiLago Framework
------------------------------------------------------------------------------

Description:
------------
This script generates the placement coordinates of VDD and VSS source 
pads for DRRA2-based layouts. The pads are intended for IR drop and 
rail connectivity analysis in Cadence Innovus or other physical design tools.

The DRRA2 fabric is organized as a grid of (rows x columns) cells. Power stripes 
run across each row and column on separate metal layers (M7 for vertical, M8 for 
horizontal). VDD and VSS sources are symmetrically placed along the chip 
boundaries (top, bottom, left, and right), with spacing defined by the number of 
power stripe pairs.

The generated files list pad names, coordinates, and the target metal layer.

Inputs:
-------
- Grid parameters (rows, columns)
- Block dimensions and margins
- Stripe count and spacing (vertical_pairs, horizontal_pairs)

Outputs:
--------
- vdd_sources.pp: List of all VDD pad positions and associated metal layers
- vss_sources.pp: List of all VSS pad positions and associated metal layers

Each file is formatted with:
*vsrc_name   x   y   layer_name

Usage:
------
Simply run the script in a Python 3 environment. The output files will be written 
to the current working directory.

Notes:
------
- VDD and VSS pads are staggered vertically/horizontally to reflect stripe locations.
- Coordinates are computed based on layout regularity assumptions.
- Modify the initial parameters to adapt to larger grid sizes or different margins.

"""


rows = 3
columns = 3

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

x_length = seq_width + resource_width + swb_router_width
y_length = swb_router_height + seq_height

vertical_pairs = 4
horizontal_pairs = 2
vertical_distance = int((seq_height + swb_router_height) / (vertical_pairs + 1))
horizontal_distance = int((seq_width + resource_width + swb_router_width) / (horizontal_pairs + 1))
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
for j in range(rows):
    y1_base = y_margin + vertical_distance + y_length * j
    for k in range(num_stripes_per_row):
        y_coord = y1_base + k * vertical_distance + 2.5

        # Left side
        x_left = 0.0
        vdd_list.append((f"VDDvsrc{vdd_counter}", x_left, y_coord, "M7"))
        vdd_counter += 1

        # Right side
        x_right = x_margin * 2 + x_length * columns
        vdd_list.append((f"VDDvsrc{vdd_counter}", x_right, y_coord, "M7"))
        vdd_counter += 1

# M8 Pads (bottom and top sides)
for i in range(columns):
    x1_base = x_margin + horizontal_distance + x_length * i
    for k in range(num_stripes_per_column):
        x_coord = x1_base + k * horizontal_distance + 2.5

        # Bottom side
        y_bottom = 0.0
        vdd_list.append((f"VDDvsrc{vdd_counter}", x_coord, y_bottom, "M8"))
        vdd_counter += 1

        # Top side
        y_top = y_margin * 2 + y_length * rows
        vdd_list.append((f"VDDvsrc{vdd_counter}", x_coord, y_top, "M8"))
        vdd_counter += 1

# === VSSvsrc Pads ===

# M7 Pads (left and right sides)
for j in range(rows):
    y1_base = y_margin + vertical_distance + y_length * j
    for k in range(num_stripes_per_row):
        y_coord_vss = y1_base + k * vertical_distance + 2.5 + 6.8  # +5 on y

        # Left side
        x_left = 0.0
        vss_list.append((f"VSSvsrc{vss_counter}", x_left, y_coord_vss, "M7"))
        vss_counter += 1

        # Right side
        x_right = x_margin * 2 + x_length * columns
        vss_list.append((f"VSSvsrc{vss_counter}", x_right, y_coord_vss, "M7"))
        vss_counter += 1

# M8 Pads (bottom and top sides)
for i in range(columns):
    x1_base = x_margin + horizontal_distance + x_length * i
    for k in range(num_stripes_per_column):
        x_coord_vss = x1_base + k * horizontal_distance + 2.5 + 6.8  # +5 on x

        # Bottom side
        y_bottom = 0.0
        vss_list.append((f"VSSvsrc{vss_counter}", x_coord_vss, y_bottom, "M8"))
        vss_counter += 1

        # Top side
        y_top = y_margin * 2 + y_length * rows
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

