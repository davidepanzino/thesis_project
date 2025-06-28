# Define floorplanning variables
# X should be multiple of 5.6
# Y should be multiple of 9.0

set x_margin 28
set y_margin 27
set resource_width 347.2
set resource_height 54
set swb_router_width 78.4
set swb_router_height 54
set seq_width 28
set seq_height [expr {$resource_height * 16}]
set x_sram_macro 30
set y_sram_macro 23.395
set distance_sram_macros 30
set columns 3
set rows 3
set macro_coords_list {}

set x_length [expr {$seq_width + $resource_width + $swb_router_width}]
set y_length [expr {$swb_router_height + $seq_height}]

create_floorplan -core_margins_by io -site core -core_size [expr {$x_length * $columns + $x_margin*2}] [expr {$y_length * $rows + $y_margin*2}] 0 0 0 0


# Cell cell_0_0_inst at (row: 2, col: 0)
# Controller
set x1 [expr {$x_length * 0 + $x_margin}]
set y1 [expr {$y_length * 2 + $y_margin + $swb_router_height}]
set x2 [expr {$x1 + $seq_width}]
set y2 [expr {$y1 + $seq_height}]
create_boundary_constraint -type fence -hinst cell_0_0_inst/controller_inst -rects [list [list $x1 $y1 $x2 $y2]]

# Switchbox & Router
set x1 [expr {$x_length * 0 + $x_margin}]
set y1 [expr {$y_length * 2 + $y_margin}]
set x2 [expr {$x1 + $seq_width + $resource_width + $swb_router_width}]
set y2 [expr {$y1 + $swb_router_height}]
set x3 [expr {$x1 + $seq_width + $resource_width}]
set y3 $y2
set x4 $x2
set y4 [expr {$y3 + $seq_height}]
create_boundary_constraint -type fence -hinst cell_0_0_inst/resource_0_inst -rects [list [list $x1 $y1 $x2 $y2] [list $x3 $y3 $x4 $y4]]

# Resources
set resource_y_start [expr {$y_margin + $swb_router_height}]
set x1 [expr {$x_length * 0 + $x_margin + $seq_width}]
set y1 [expr {$y_length * 2 + $resource_y_start}]
set x2 [expr {$x1 + $resource_width}]
set y2 [expr {$y1 + $resource_height * 4}]
create_boundary_constraint -type fence -hinst cell_0_0_inst/resource_1_inst -rects [list [list $x1 $y1 $x2 $y2]]

#Resource's Macros placement
set x3 [expr {$x1 + $x_sram_macro}]
set y3 [expr {$y1 + $y_sram_macro}]
place_inst cell_0_0_inst/resource_1_inst/sram_inst/sram_256x64.sram_macro_0 $x3 $y3
set bbox0 [get_db inst:cell_0_0_inst/resource_1_inst/sram_inst/sram_256x64.sram_macro_0 .bbox]
lappend macro_coords_list [concat {*}$bbox0]

set prev_macro_width [get_db inst:cell_0_0_inst/resource_1_inst/sram_inst/sram_256x64.sram_macro_0 .bbox.width]
set x3 [expr {$x3 + $prev_macro_width + $distance_sram_macros}]
place_inst cell_0_0_inst/resource_1_inst/sram_inst/sram_256x64.sram_macro_1 $x3 $y3
set bbox0 [get_db inst:cell_0_0_inst/resource_1_inst/sram_inst/sram_256x64.sram_macro_1 .bbox]
lappend macro_coords_list [concat {*}$bbox0]

set prev_macro_width [get_db inst:cell_0_0_inst/resource_1_inst/sram_inst/sram_256x64.sram_macro_1 .bbox.width]
set x3 [expr {$x3 + $prev_macro_width + $distance_sram_macros}]
place_inst cell_0_0_inst/resource_1_inst/sram_inst/sram_256x64.sram_macro_2 $x3 $y3
set bbox0 [get_db inst:cell_0_0_inst/resource_1_inst/sram_inst/sram_256x64.sram_macro_2 .bbox]
lappend macro_coords_list [concat {*}$bbox0]

set prev_macro_width [get_db inst:cell_0_0_inst/resource_1_inst/sram_inst/sram_256x64.sram_macro_2 .bbox.width]
set x3 [expr {$x3 + $prev_macro_width + $distance_sram_macros}]
place_inst cell_0_0_inst/resource_1_inst/sram_inst/sram_256x64.sram_macro_3 $x3 $y3
set bbox0 [get_db inst:cell_0_0_inst/resource_1_inst/sram_inst/sram_256x64.sram_macro_3 .bbox]
lappend macro_coords_list [concat {*}$bbox0]



# Cell cell_0_1_inst at (row: 2, col: 1)
# Controller
set x1 [expr {$x_length * 1 + $x_margin}]
set y1 [expr {$y_length * 2 + $y_margin + $swb_router_height}]
set x2 [expr {$x1 + $seq_width}]
set y2 [expr {$y1 + $seq_height}]
create_boundary_constraint -type fence -hinst cell_0_1_inst/controller_inst -rects [list [list $x1 $y1 $x2 $y2]]

# Switchbox & Router
set x1 [expr {$x_length * 1 + $x_margin}]
set y1 [expr {$y_length * 2 + $y_margin}]
set x2 [expr {$x1 + $seq_width + $resource_width + $swb_router_width}]
set y2 [expr {$y1 + $swb_router_height}]
set x3 [expr {$x1 + $seq_width + $resource_width}]
set y3 $y2
set x4 $x2
set y4 [expr {$y3 + $seq_height}]
create_boundary_constraint -type fence -hinst cell_0_1_inst/resource_0_inst -rects [list [list $x1 $y1 $x2 $y2] [list $x3 $y3 $x4 $y4]]

# Resources
set resource_y_start [expr {$y_margin + $swb_router_height}]
set x1 [expr {$x_length * 1 + $x_margin + $seq_width}]
set y1 [expr {$y_length * 2 + $resource_y_start}]
set x2 [expr {$x1 + $resource_width}]
set y2 [expr {$y1 + $resource_height * 4}]
create_boundary_constraint -type fence -hinst cell_0_1_inst/resource_1_inst -rects [list [list $x1 $y1 $x2 $y2]]

#Resource's Macros placement
set x3 [expr {$x1 + $x_sram_macro}]
set y3 [expr {$y1 + $y_sram_macro}]
place_inst cell_0_1_inst/resource_1_inst/sram_inst/sram_256x64.sram_macro_0 $x3 $y3
set bbox0 [get_db inst:cell_0_1_inst/resource_1_inst/sram_inst/sram_256x64.sram_macro_0 .bbox]
lappend macro_coords_list [concat {*}$bbox0]

set prev_macro_width [get_db inst:cell_0_1_inst/resource_1_inst/sram_inst/sram_256x64.sram_macro_0 .bbox.width]
set x3 [expr {$x3 + $prev_macro_width + $distance_sram_macros}]
place_inst cell_0_1_inst/resource_1_inst/sram_inst/sram_256x64.sram_macro_1 $x3 $y3
set bbox0 [get_db inst:cell_0_1_inst/resource_1_inst/sram_inst/sram_256x64.sram_macro_1 .bbox]
lappend macro_coords_list [concat {*}$bbox0]

set prev_macro_width [get_db inst:cell_0_1_inst/resource_1_inst/sram_inst/sram_256x64.sram_macro_1 .bbox.width]
set x3 [expr {$x3 + $prev_macro_width + $distance_sram_macros}]
place_inst cell_0_1_inst/resource_1_inst/sram_inst/sram_256x64.sram_macro_2 $x3 $y3
set bbox0 [get_db inst:cell_0_1_inst/resource_1_inst/sram_inst/sram_256x64.sram_macro_2 .bbox]
lappend macro_coords_list [concat {*}$bbox0]

set prev_macro_width [get_db inst:cell_0_1_inst/resource_1_inst/sram_inst/sram_256x64.sram_macro_2 .bbox.width]
set x3 [expr {$x3 + $prev_macro_width + $distance_sram_macros}]
place_inst cell_0_1_inst/resource_1_inst/sram_inst/sram_256x64.sram_macro_3 $x3 $y3
set bbox0 [get_db inst:cell_0_1_inst/resource_1_inst/sram_inst/sram_256x64.sram_macro_3 .bbox]
lappend macro_coords_list [concat {*}$bbox0]



# Cell cell_0_2_inst at (row: 2, col: 2)
# Controller
set x1 [expr {$x_length * 2 + $x_margin}]
set y1 [expr {$y_length * 2 + $y_margin + $swb_router_height}]
set x2 [expr {$x1 + $seq_width}]
set y2 [expr {$y1 + $seq_height}]
create_boundary_constraint -type fence -hinst cell_0_2_inst/controller_inst -rects [list [list $x1 $y1 $x2 $y2]]

# Switchbox & Router
set x1 [expr {$x_length * 2 + $x_margin}]
set y1 [expr {$y_length * 2 + $y_margin}]
set x2 [expr {$x1 + $seq_width + $resource_width + $swb_router_width}]
set y2 [expr {$y1 + $swb_router_height}]
set x3 [expr {$x1 + $seq_width + $resource_width}]
set y3 $y2
set x4 $x2
set y4 [expr {$y3 + $seq_height}]
create_boundary_constraint -type fence -hinst cell_0_2_inst/resource_0_inst -rects [list [list $x1 $y1 $x2 $y2] [list $x3 $y3 $x4 $y4]]

# Resources
set resource_y_start [expr {$y_margin + $swb_router_height}]
set x1 [expr {$x_length * 2 + $x_margin + $seq_width}]
set y1 [expr {$y_length * 2 + $resource_y_start}]
set x2 [expr {$x1 + $resource_width}]
set y2 [expr {$y1 + $resource_height * 4}]
create_boundary_constraint -type fence -hinst cell_0_2_inst/resource_1_inst -rects [list [list $x1 $y1 $x2 $y2]]

#Resource's Macros placement
set x3 [expr {$x1 + $x_sram_macro}]
set y3 [expr {$y1 + $y_sram_macro}]
place_inst cell_0_2_inst/resource_1_inst/sram_inst/sram_256x64.sram_macro_0 $x3 $y3
set bbox0 [get_db inst:cell_0_2_inst/resource_1_inst/sram_inst/sram_256x64.sram_macro_0 .bbox]
lappend macro_coords_list [concat {*}$bbox0]

set prev_macro_width [get_db inst:cell_0_2_inst/resource_1_inst/sram_inst/sram_256x64.sram_macro_0 .bbox.width]
set x3 [expr {$x3 + $prev_macro_width + $distance_sram_macros}]
place_inst cell_0_2_inst/resource_1_inst/sram_inst/sram_256x64.sram_macro_1 $x3 $y3
set bbox0 [get_db inst:cell_0_2_inst/resource_1_inst/sram_inst/sram_256x64.sram_macro_1 .bbox]
lappend macro_coords_list [concat {*}$bbox0]

set prev_macro_width [get_db inst:cell_0_2_inst/resource_1_inst/sram_inst/sram_256x64.sram_macro_1 .bbox.width]
set x3 [expr {$x3 + $prev_macro_width + $distance_sram_macros}]
place_inst cell_0_2_inst/resource_1_inst/sram_inst/sram_256x64.sram_macro_2 $x3 $y3
set bbox0 [get_db inst:cell_0_2_inst/resource_1_inst/sram_inst/sram_256x64.sram_macro_2 .bbox]
lappend macro_coords_list [concat {*}$bbox0]

set prev_macro_width [get_db inst:cell_0_2_inst/resource_1_inst/sram_inst/sram_256x64.sram_macro_2 .bbox.width]
set x3 [expr {$x3 + $prev_macro_width + $distance_sram_macros}]
place_inst cell_0_2_inst/resource_1_inst/sram_inst/sram_256x64.sram_macro_3 $x3 $y3
set bbox0 [get_db inst:cell_0_2_inst/resource_1_inst/sram_inst/sram_256x64.sram_macro_3 .bbox]
lappend macro_coords_list [concat {*}$bbox0]



# Cell cell_1_0_inst at (row: 1, col: 0)
# Controller
set x1 [expr {$x_length * 0 + $x_margin}]
set y1 [expr {$y_length * 1 + $y_margin + $swb_router_height}]
set x2 [expr {$x1 + $seq_width}]
set y2 [expr {$y1 + $seq_height}]
create_boundary_constraint -type fence -hinst cell_1_0_inst/controller_inst -rects [list [list $x1 $y1 $x2 $y2]]

# Switchbox & Router
set x1 [expr {$x_length * 0 + $x_margin}]
set y1 [expr {$y_length * 1 + $y_margin}]
set x2 [expr {$x1 + $seq_width + $resource_width + $swb_router_width}]
set y2 [expr {$y1 + $swb_router_height}]
set x3 [expr {$x1 + $seq_width + $resource_width}]
set y3 $y2
set x4 $x2
set y4 [expr {$y3 + $seq_height}]
create_boundary_constraint -type fence -hinst cell_1_0_inst/resource_0_inst -rects [list [list $x1 $y1 $x2 $y2] [list $x3 $y3 $x4 $y4]]

# Resources
set resource_y_start [expr {$y_margin + $swb_router_height}]
set x1 [expr {$x_length * 0 + $x_margin + $seq_width}]
set y1 [expr {$y_length * 1 + $resource_y_start}]
set x2 [expr {$x1 + $resource_width}]
set y2 [expr {$y1 + $resource_height * 1}]
create_boundary_constraint -type fence -hinst cell_1_0_inst/resource_1_inst -rects [list [list $x1 $y1 $x2 $y2]]

set resource_y_start [expr {$resource_y_start + $resource_height * 1}]
set x1 [expr {$x_length * 0 + $x_margin + $seq_width}]
set y1 [expr {$y_length * 1 + $resource_y_start}]
set x2 [expr {$x1 + $resource_width}]
set y2 [expr {$y1 + $resource_height * 1}]
create_boundary_constraint -type fence -hinst cell_1_0_inst/resource_2_inst -rects [list [list $x1 $y1 $x2 $y2]]

set resource_y_start [expr {$resource_y_start + $resource_height * 1}]
set x1 [expr {$x_length * 0 + $x_margin + $seq_width}]
set y1 [expr {$y_length * 1 + $resource_y_start}]
set x2 [expr {$x1 + $resource_width}]
set y2 [expr {$y1 + $resource_height * 1}]
create_boundary_constraint -type fence -hinst cell_1_0_inst/resource_3_inst -rects [list [list $x1 $y1 $x2 $y2]]

set resource_y_start [expr {$resource_y_start + $resource_height * 1}]
set x1 [expr {$x_length * 0 + $x_margin + $seq_width}]
set y1 [expr {$y_length * 1 + $resource_y_start}]
set x2 [expr {$x1 + $resource_width}]
set y2 [expr {$y1 + $resource_height * 2}]
create_boundary_constraint -type fence -hinst cell_1_0_inst/resource_4_inst -rects [list [list $x1 $y1 $x2 $y2]]



# Cell cell_1_1_inst at (row: 1, col: 1)
# Controller
set x1 [expr {$x_length * 1 + $x_margin}]
set y1 [expr {$y_length * 1 + $y_margin + $swb_router_height}]
set x2 [expr {$x1 + $seq_width}]
set y2 [expr {$y1 + $seq_height}]
create_boundary_constraint -type fence -hinst cell_1_1_inst/controller_inst -rects [list [list $x1 $y1 $x2 $y2]]

# Switchbox & Router
set x1 [expr {$x_length * 1 + $x_margin}]
set y1 [expr {$y_length * 1 + $y_margin}]
set x2 [expr {$x1 + $seq_width + $resource_width + $swb_router_width}]
set y2 [expr {$y1 + $swb_router_height}]
set x3 [expr {$x1 + $seq_width + $resource_width}]
set y3 $y2
set x4 $x2
set y4 [expr {$y3 + $seq_height}]
create_boundary_constraint -type fence -hinst cell_1_1_inst/resource_0_inst -rects [list [list $x1 $y1 $x2 $y2] [list $x3 $y3 $x4 $y4]]

# Resources
set resource_y_start [expr {$y_margin + $swb_router_height}]
set x1 [expr {$x_length * 1 + $x_margin + $seq_width}]
set y1 [expr {$y_length * 1 + $resource_y_start}]
set x2 [expr {$x1 + $resource_width}]
set y2 [expr {$y1 + $resource_height * 1}]
create_boundary_constraint -type fence -hinst cell_1_1_inst/resource_1_inst -rects [list [list $x1 $y1 $x2 $y2]]

set resource_y_start [expr {$resource_y_start + $resource_height * 1}]
set x1 [expr {$x_length * 1 + $x_margin + $seq_width}]
set y1 [expr {$y_length * 1 + $resource_y_start}]
set x2 [expr {$x1 + $resource_width}]
set y2 [expr {$y1 + $resource_height * 1}]
create_boundary_constraint -type fence -hinst cell_1_1_inst/resource_2_inst -rects [list [list $x1 $y1 $x2 $y2]]

set resource_y_start [expr {$resource_y_start + $resource_height * 1}]
set x1 [expr {$x_length * 1 + $x_margin + $seq_width}]
set y1 [expr {$y_length * 1 + $resource_y_start}]
set x2 [expr {$x1 + $resource_width}]
set y2 [expr {$y1 + $resource_height * 1}]
create_boundary_constraint -type fence -hinst cell_1_1_inst/resource_3_inst -rects [list [list $x1 $y1 $x2 $y2]]

set resource_y_start [expr {$resource_y_start + $resource_height * 1}]
set x1 [expr {$x_length * 1 + $x_margin + $seq_width}]
set y1 [expr {$y_length * 1 + $resource_y_start}]
set x2 [expr {$x1 + $resource_width}]
set y2 [expr {$y1 + $resource_height * 2}]
create_boundary_constraint -type fence -hinst cell_1_1_inst/resource_4_inst -rects [list [list $x1 $y1 $x2 $y2]]



# Cell cell_1_2_inst at (row: 1, col: 2)
# Controller
set x1 [expr {$x_length * 2 + $x_margin}]
set y1 [expr {$y_length * 1 + $y_margin + $swb_router_height}]
set x2 [expr {$x1 + $seq_width}]
set y2 [expr {$y1 + $seq_height}]
create_boundary_constraint -type fence -hinst cell_1_2_inst/controller_inst -rects [list [list $x1 $y1 $x2 $y2]]

# Switchbox & Router
set x1 [expr {$x_length * 2 + $x_margin}]
set y1 [expr {$y_length * 1 + $y_margin}]
set x2 [expr {$x1 + $seq_width + $resource_width + $swb_router_width}]
set y2 [expr {$y1 + $swb_router_height}]
set x3 [expr {$x1 + $seq_width + $resource_width}]
set y3 $y2
set x4 $x2
set y4 [expr {$y3 + $seq_height}]
create_boundary_constraint -type fence -hinst cell_1_2_inst/resource_0_inst -rects [list [list $x1 $y1 $x2 $y2] [list $x3 $y3 $x4 $y4]]

# Resources
set resource_y_start [expr {$y_margin + $swb_router_height}]
set x1 [expr {$x_length * 2 + $x_margin + $seq_width}]
set y1 [expr {$y_length * 1 + $resource_y_start}]
set x2 [expr {$x1 + $resource_width}]
set y2 [expr {$y1 + $resource_height * 1}]
create_boundary_constraint -type fence -hinst cell_1_2_inst/resource_1_inst -rects [list [list $x1 $y1 $x2 $y2]]

set resource_y_start [expr {$resource_y_start + $resource_height * 1}]
set x1 [expr {$x_length * 2 + $x_margin + $seq_width}]
set y1 [expr {$y_length * 1 + $resource_y_start}]
set x2 [expr {$x1 + $resource_width}]
set y2 [expr {$y1 + $resource_height * 1}]
create_boundary_constraint -type fence -hinst cell_1_2_inst/resource_2_inst -rects [list [list $x1 $y1 $x2 $y2]]

set resource_y_start [expr {$resource_y_start + $resource_height * 1}]
set x1 [expr {$x_length * 2 + $x_margin + $seq_width}]
set y1 [expr {$y_length * 1 + $resource_y_start}]
set x2 [expr {$x1 + $resource_width}]
set y2 [expr {$y1 + $resource_height * 1}]
create_boundary_constraint -type fence -hinst cell_1_2_inst/resource_3_inst -rects [list [list $x1 $y1 $x2 $y2]]

set resource_y_start [expr {$resource_y_start + $resource_height * 1}]
set x1 [expr {$x_length * 2 + $x_margin + $seq_width}]
set y1 [expr {$y_length * 1 + $resource_y_start}]
set x2 [expr {$x1 + $resource_width}]
set y2 [expr {$y1 + $resource_height * 2}]
create_boundary_constraint -type fence -hinst cell_1_2_inst/resource_4_inst -rects [list [list $x1 $y1 $x2 $y2]]



# Cell cell_2_0_inst at (row: 0, col: 0)
# Controller
set x1 [expr {$x_length * 0 + $x_margin}]
set y1 [expr {$y_length * 0 + $y_margin + $swb_router_height}]
set x2 [expr {$x1 + $seq_width}]
set y2 [expr {$y1 + $seq_height}]
create_boundary_constraint -type fence -hinst cell_2_0_inst/controller_inst -rects [list [list $x1 $y1 $x2 $y2]]

# Switchbox & Router
set x1 [expr {$x_length * 0 + $x_margin}]
set y1 [expr {$y_length * 0 + $y_margin}]
set x2 [expr {$x1 + $seq_width + $resource_width + $swb_router_width}]
set y2 [expr {$y1 + $swb_router_height}]
set x3 [expr {$x1 + $seq_width + $resource_width}]
set y3 $y2
set x4 $x2
set y4 [expr {$y3 + $seq_height}]
create_boundary_constraint -type fence -hinst cell_2_0_inst/resource_0_inst -rects [list [list $x1 $y1 $x2 $y2] [list $x3 $y3 $x4 $y4]]

# Resources
set resource_y_start [expr {$y_margin + $swb_router_height}]
set x1 [expr {$x_length * 0 + $x_margin + $seq_width}]
set y1 [expr {$y_length * 0 + $resource_y_start}]
set x2 [expr {$x1 + $resource_width}]
set y2 [expr {$y1 + $resource_height * 4}]
create_boundary_constraint -type fence -hinst cell_2_0_inst/resource_1_inst -rects [list [list $x1 $y1 $x2 $y2]]

#Resource's Macros placement
set x3 [expr {$x1 + $x_sram_macro}]
set y3 [expr {$y1 + $y_sram_macro}]
place_inst cell_2_0_inst/resource_1_inst/sram_inst/sram_256x64.sram_macro_0 $x3 $y3
set bbox0 [get_db inst:cell_2_0_inst/resource_1_inst/sram_inst/sram_256x64.sram_macro_0 .bbox]
lappend macro_coords_list [concat {*}$bbox0]

set prev_macro_width [get_db inst:cell_2_0_inst/resource_1_inst/sram_inst/sram_256x64.sram_macro_0 .bbox.width]
set x3 [expr {$x3 + $prev_macro_width + $distance_sram_macros}]
place_inst cell_2_0_inst/resource_1_inst/sram_inst/sram_256x64.sram_macro_1 $x3 $y3
set bbox0 [get_db inst:cell_2_0_inst/resource_1_inst/sram_inst/sram_256x64.sram_macro_1 .bbox]
lappend macro_coords_list [concat {*}$bbox0]

set prev_macro_width [get_db inst:cell_2_0_inst/resource_1_inst/sram_inst/sram_256x64.sram_macro_1 .bbox.width]
set x3 [expr {$x3 + $prev_macro_width + $distance_sram_macros}]
place_inst cell_2_0_inst/resource_1_inst/sram_inst/sram_256x64.sram_macro_2 $x3 $y3
set bbox0 [get_db inst:cell_2_0_inst/resource_1_inst/sram_inst/sram_256x64.sram_macro_2 .bbox]
lappend macro_coords_list [concat {*}$bbox0]

set prev_macro_width [get_db inst:cell_2_0_inst/resource_1_inst/sram_inst/sram_256x64.sram_macro_2 .bbox.width]
set x3 [expr {$x3 + $prev_macro_width + $distance_sram_macros}]
place_inst cell_2_0_inst/resource_1_inst/sram_inst/sram_256x64.sram_macro_3 $x3 $y3
set bbox0 [get_db inst:cell_2_0_inst/resource_1_inst/sram_inst/sram_256x64.sram_macro_3 .bbox]
lappend macro_coords_list [concat {*}$bbox0]



# Cell cell_2_1_inst at (row: 0, col: 1)
# Controller
set x1 [expr {$x_length * 1 + $x_margin}]
set y1 [expr {$y_length * 0 + $y_margin + $swb_router_height}]
set x2 [expr {$x1 + $seq_width}]
set y2 [expr {$y1 + $seq_height}]
create_boundary_constraint -type fence -hinst cell_2_1_inst/controller_inst -rects [list [list $x1 $y1 $x2 $y2]]

# Switchbox & Router
set x1 [expr {$x_length * 1 + $x_margin}]
set y1 [expr {$y_length * 0 + $y_margin}]
set x2 [expr {$x1 + $seq_width + $resource_width + $swb_router_width}]
set y2 [expr {$y1 + $swb_router_height}]
set x3 [expr {$x1 + $seq_width + $resource_width}]
set y3 $y2
set x4 $x2
set y4 [expr {$y3 + $seq_height}]
create_boundary_constraint -type fence -hinst cell_2_1_inst/resource_0_inst -rects [list [list $x1 $y1 $x2 $y2] [list $x3 $y3 $x4 $y4]]

# Resources
set resource_y_start [expr {$y_margin + $swb_router_height}]
set x1 [expr {$x_length * 1 + $x_margin + $seq_width}]
set y1 [expr {$y_length * 0 + $resource_y_start}]
set x2 [expr {$x1 + $resource_width}]
set y2 [expr {$y1 + $resource_height * 4}]
create_boundary_constraint -type fence -hinst cell_2_1_inst/resource_1_inst -rects [list [list $x1 $y1 $x2 $y2]]

#Resource's Macros placement
set x3 [expr {$x1 + $x_sram_macro}]
set y3 [expr {$y1 + $y_sram_macro}]
place_inst cell_2_1_inst/resource_1_inst/sram_inst/sram_256x64.sram_macro_0 $x3 $y3
set bbox0 [get_db inst:cell_2_1_inst/resource_1_inst/sram_inst/sram_256x64.sram_macro_0 .bbox]
lappend macro_coords_list [concat {*}$bbox0]

set prev_macro_width [get_db inst:cell_2_1_inst/resource_1_inst/sram_inst/sram_256x64.sram_macro_0 .bbox.width]
set x3 [expr {$x3 + $prev_macro_width + $distance_sram_macros}]
place_inst cell_2_1_inst/resource_1_inst/sram_inst/sram_256x64.sram_macro_1 $x3 $y3
set bbox0 [get_db inst:cell_2_1_inst/resource_1_inst/sram_inst/sram_256x64.sram_macro_1 .bbox]
lappend macro_coords_list [concat {*}$bbox0]

set prev_macro_width [get_db inst:cell_2_1_inst/resource_1_inst/sram_inst/sram_256x64.sram_macro_1 .bbox.width]
set x3 [expr {$x3 + $prev_macro_width + $distance_sram_macros}]
place_inst cell_2_1_inst/resource_1_inst/sram_inst/sram_256x64.sram_macro_2 $x3 $y3
set bbox0 [get_db inst:cell_2_1_inst/resource_1_inst/sram_inst/sram_256x64.sram_macro_2 .bbox]
lappend macro_coords_list [concat {*}$bbox0]

set prev_macro_width [get_db inst:cell_2_1_inst/resource_1_inst/sram_inst/sram_256x64.sram_macro_2 .bbox.width]
set x3 [expr {$x3 + $prev_macro_width + $distance_sram_macros}]
place_inst cell_2_1_inst/resource_1_inst/sram_inst/sram_256x64.sram_macro_3 $x3 $y3
set bbox0 [get_db inst:cell_2_1_inst/resource_1_inst/sram_inst/sram_256x64.sram_macro_3 .bbox]
lappend macro_coords_list [concat {*}$bbox0]



# Cell cell_2_2_inst at (row: 0, col: 2)
# Controller
set x1 [expr {$x_length * 2 + $x_margin}]
set y1 [expr {$y_length * 0 + $y_margin + $swb_router_height}]
set x2 [expr {$x1 + $seq_width}]
set y2 [expr {$y1 + $seq_height}]
create_boundary_constraint -type fence -hinst cell_2_2_inst/controller_inst -rects [list [list $x1 $y1 $x2 $y2]]

# Switchbox & Router
set x1 [expr {$x_length * 2 + $x_margin}]
set y1 [expr {$y_length * 0 + $y_margin}]
set x2 [expr {$x1 + $seq_width + $resource_width + $swb_router_width}]
set y2 [expr {$y1 + $swb_router_height}]
set x3 [expr {$x1 + $seq_width + $resource_width}]
set y3 $y2
set x4 $x2
set y4 [expr {$y3 + $seq_height}]
create_boundary_constraint -type fence -hinst cell_2_2_inst/resource_0_inst -rects [list [list $x1 $y1 $x2 $y2] [list $x3 $y3 $x4 $y4]]

# Resources
set resource_y_start [expr {$y_margin + $swb_router_height}]
set x1 [expr {$x_length * 2 + $x_margin + $seq_width}]
set y1 [expr {$y_length * 0 + $resource_y_start}]
set x2 [expr {$x1 + $resource_width}]
set y2 [expr {$y1 + $resource_height * 4}]
create_boundary_constraint -type fence -hinst cell_2_2_inst/resource_1_inst -rects [list [list $x1 $y1 $x2 $y2]]

#Resource's Macros placement
set x3 [expr {$x1 + $x_sram_macro}]
set y3 [expr {$y1 + $y_sram_macro}]
place_inst cell_2_2_inst/resource_1_inst/sram_inst/sram_256x64.sram_macro_0 $x3 $y3
set bbox0 [get_db inst:cell_2_2_inst/resource_1_inst/sram_inst/sram_256x64.sram_macro_0 .bbox]
lappend macro_coords_list [concat {*}$bbox0]

set prev_macro_width [get_db inst:cell_2_2_inst/resource_1_inst/sram_inst/sram_256x64.sram_macro_0 .bbox.width]
set x3 [expr {$x3 + $prev_macro_width + $distance_sram_macros}]
place_inst cell_2_2_inst/resource_1_inst/sram_inst/sram_256x64.sram_macro_1 $x3 $y3
set bbox0 [get_db inst:cell_2_2_inst/resource_1_inst/sram_inst/sram_256x64.sram_macro_1 .bbox]
lappend macro_coords_list [concat {*}$bbox0]

set prev_macro_width [get_db inst:cell_2_2_inst/resource_1_inst/sram_inst/sram_256x64.sram_macro_1 .bbox.width]
set x3 [expr {$x3 + $prev_macro_width + $distance_sram_macros}]
place_inst cell_2_2_inst/resource_1_inst/sram_inst/sram_256x64.sram_macro_2 $x3 $y3
set bbox0 [get_db inst:cell_2_2_inst/resource_1_inst/sram_inst/sram_256x64.sram_macro_2 .bbox]
lappend macro_coords_list [concat {*}$bbox0]

set prev_macro_width [get_db inst:cell_2_2_inst/resource_1_inst/sram_inst/sram_256x64.sram_macro_2 .bbox.width]
set x3 [expr {$x3 + $prev_macro_width + $distance_sram_macros}]
place_inst cell_2_2_inst/resource_1_inst/sram_inst/sram_256x64.sram_macro_3 $x3 $y3
set bbox0 [get_db inst:cell_2_2_inst/resource_1_inst/sram_inst/sram_256x64.sram_macro_3 .bbox]
lappend macro_coords_list [concat {*}$bbox0]


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

# add endcaps
set_db add_endcaps_right_edge BOUNDARY_RIGHTBWP30P140
set_db add_endcaps_left_edge BOUNDARY_LEFTBWP30P140
add_endcaps

# add well taps
add_well_taps -checker_board -cell_interval 30 -cell TAPCELLBWP30P140

