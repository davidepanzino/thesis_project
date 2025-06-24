# X should be multiple of 5.6
# Y should be multiple of 9.0

set side 749.7
set x_side 627.2
set y_side [expr {$x_side * 2}]
set x_sram_macro 50
set y_sram_macro 31.4
set distance_sram_macros_x 45
set distance_sram_macros_y 30
set macro_coords_list {}
create_floorplan -core_margins_by io -site core -core_size [expr {$x_side}] [expr {$y_side}] 0 0 0 0

# Cell cell_0_0_inst at (row: 2, col: 0)

#Resource's Macros placement
set x3 [expr {$x_sram_macro}]
set y3 [expr {$y_sram_macro}]
place_inst cell_0_0_inst/resource_1_inst/sram_inst/sram_256x64.sram_macro_0 $x3 $y3
set bbox0 [get_db inst:cell_0_0_inst/resource_1_inst/sram_inst/sram_256x64.sram_macro_0 .bbox]
lappend macro_coords_list [concat {*}$bbox0]

set prev_macro_width [get_db inst:cell_0_0_inst/resource_1_inst/sram_inst/sram_256x64.sram_macro_0 .bbox.width]
set x3 [expr {$x3 + $prev_macro_width + $distance_sram_macros_x}]
place_inst cell_0_0_inst/resource_1_inst/sram_inst/sram_256x64.sram_macro_1 $x3 $y3
set bbox0 [get_db inst:cell_0_0_inst/resource_1_inst/sram_inst/sram_256x64.sram_macro_1 .bbox]
lappend macro_coords_list [concat {*}$bbox0]

set prev_macro_width [get_db inst:cell_0_0_inst/resource_1_inst/sram_inst/sram_256x64.sram_macro_1 .bbox.width]
set x3 [expr {$x3 + $prev_macro_width + $distance_sram_macros_x}]
place_inst cell_0_0_inst/resource_1_inst/sram_inst/sram_256x64.sram_macro_2 $x3 $y3
set bbox0 [get_db inst:cell_0_0_inst/resource_1_inst/sram_inst/sram_256x64.sram_macro_2 .bbox]
lappend macro_coords_list [concat {*}$bbox0]

set prev_macro_width [get_db inst:cell_0_0_inst/resource_1_inst/sram_inst/sram_256x64.sram_macro_2 .bbox.width]
set x3 [expr {$x3 + $prev_macro_width + $distance_sram_macros_x}]
place_inst cell_0_0_inst/resource_1_inst/sram_inst/sram_256x64.sram_macro_3 $x3 $y3
set bbox0 [get_db inst:cell_0_0_inst/resource_1_inst/sram_inst/sram_256x64.sram_macro_3 .bbox]
lappend macro_coords_list [concat {*}$bbox0]


# Cell cell_0_1_inst at (row: 2, col: 1)

#Resource's Macros placement
set prev_macro_width [get_db inst:cell_0_1_inst/resource_1_inst/sram_inst/sram_256x64.sram_macro_3 .bbox.width]
set x3 [expr {$x_sram_macro + $prev_macro_width*4 + $distance_sram_macros_x*4}]
set y3 [expr {$y_sram_macro}]
place_inst cell_0_1_inst/resource_1_inst/sram_inst/sram_256x64.sram_macro_0 $x3 $y3
set bbox0 [get_db inst:cell_0_1_inst/resource_1_inst/sram_inst/sram_256x64.sram_macro_0 .bbox]
lappend macro_coords_list [concat {*}$bbox0]

set prev_macro_width [get_db inst:cell_0_1_inst/resource_1_inst/sram_inst/sram_256x64.sram_macro_0 .bbox.width]
set x3 [expr {$x3 + $prev_macro_width + $distance_sram_macros_x}]
place_inst cell_0_1_inst/resource_1_inst/sram_inst/sram_256x64.sram_macro_1 $x3 $y3
set bbox0 [get_db inst:cell_0_1_inst/resource_1_inst/sram_inst/sram_256x64.sram_macro_1 .bbox]
lappend macro_coords_list [concat {*}$bbox0]

set x3 [expr {$x_sram_macro}]
set macro_height [get_db inst:cell_0_1_inst/resource_1_inst/sram_inst/sram_256x64.sram_macro_1 .bbox.length]
set y3 [expr {$y_sram_macro + $macro_height + $distance_sram_macros_y}]
place_inst cell_0_1_inst/resource_1_inst/sram_inst/sram_256x64.sram_macro_2 $x3 $y3
set bbox0 [get_db inst:cell_0_1_inst/resource_1_inst/sram_inst/sram_256x64.sram_macro_2 .bbox]
lappend macro_coords_list [concat {*}$bbox0]

set prev_macro_width [get_db inst:cell_0_1_inst/resource_1_inst/sram_inst/sram_256x64.sram_macro_2 .bbox.width]
set x3 [expr {$x3 + $prev_macro_width + $distance_sram_macros_x}]
place_inst cell_0_1_inst/resource_1_inst/sram_inst/sram_256x64.sram_macro_3 $x3 $y3
set bbox0 [get_db inst:cell_0_1_inst/resource_1_inst/sram_inst/sram_256x64.sram_macro_3 .bbox]
lappend macro_coords_list [concat {*}$bbox0]


# Cell cell_0_2_inst at (row: 2, col: 2)

#Resource's Macros placement
set prev_macro_width [get_db inst:cell_0_2_inst/resource_1_inst/sram_inst/sram_256x64.sram_macro_3 .bbox.width]
set x3 [expr {$x_sram_macro + $prev_macro_width*2 + $distance_sram_macros_x*2}]
set macro_height [get_db inst:cell_0_2_inst/resource_1_inst/sram_inst/sram_256x64.sram_macro_3 .bbox.length]
set y3 [expr {$y_sram_macro + $macro_height + $distance_sram_macros_y}]
place_inst cell_0_2_inst/resource_1_inst/sram_inst/sram_256x64.sram_macro_0 $x3 $y3
set bbox0 [get_db inst:cell_0_2_inst/resource_1_inst/sram_inst/sram_256x64.sram_macro_0 .bbox]
lappend macro_coords_list [concat {*}$bbox0]

set prev_macro_width [get_db inst:cell_0_2_inst/resource_1_inst/sram_inst/sram_256x64.sram_macro_0 .bbox.width]
set x3 [expr {$x3 + $prev_macro_width + $distance_sram_macros_x}]
place_inst cell_0_2_inst/resource_1_inst/sram_inst/sram_256x64.sram_macro_1 $x3 $y3
set bbox0 [get_db inst:cell_0_2_inst/resource_1_inst/sram_inst/sram_256x64.sram_macro_1 .bbox]
lappend macro_coords_list [concat {*}$bbox0]

set prev_macro_width [get_db inst:cell_0_2_inst/resource_1_inst/sram_inst/sram_256x64.sram_macro_1 .bbox.width]
set x3 [expr {$x3 + $prev_macro_width + $distance_sram_macros_x}]
place_inst cell_0_2_inst/resource_1_inst/sram_inst/sram_256x64.sram_macro_2 $x3 $y3
set bbox0 [get_db inst:cell_0_2_inst/resource_1_inst/sram_inst/sram_256x64.sram_macro_2 .bbox]
lappend macro_coords_list [concat {*}$bbox0]

set prev_macro_width [get_db inst:cell_0_2_inst/resource_1_inst/sram_inst/sram_256x64.sram_macro_2 .bbox.width]
set x3 [expr {$x3 + $prev_macro_width + $distance_sram_macros_x}]
place_inst cell_0_2_inst/resource_1_inst/sram_inst/sram_256x64.sram_macro_3 $x3 $y3
set bbox0 [get_db inst:cell_0_2_inst/resource_1_inst/sram_inst/sram_256x64.sram_macro_3 .bbox]
lappend macro_coords_list [concat {*}$bbox0]


# Cell cell_1_0_inst at (row: 1, col: 0)

# Cell cell_1_1_inst at (row: 1, col: 1)

# Cell cell_1_2_inst at (row: 1, col: 2)

# Cell cell_2_0_inst at (row: 0, col: 0)

#Resource's Macros placement
set x3 [expr {$x_sram_macro}]
set macro_height [get_db inst:cell_2_0_inst/resource_1_inst/sram_inst/sram_256x64.sram_macro_3 .bbox.length]
set y3 [expr {$y_side - $macro_height - $y_sram_macro}]
place_inst cell_2_0_inst/resource_1_inst/sram_inst/sram_256x64.sram_macro_0 $x3 $y3
set bbox0 [get_db inst:cell_2_0_inst/resource_1_inst/sram_inst/sram_256x64.sram_macro_0 .bbox]
lappend macro_coords_list [concat {*}$bbox0]

set prev_macro_width [get_db inst:cell_2_0_inst/resource_1_inst/sram_inst/sram_256x64.sram_macro_0 .bbox.width]
set x3 [expr {$x3 + $prev_macro_width + $distance_sram_macros_x}]
place_inst cell_2_0_inst/resource_1_inst/sram_inst/sram_256x64.sram_macro_1 $x3 $y3
set bbox0 [get_db inst:cell_2_0_inst/resource_1_inst/sram_inst/sram_256x64.sram_macro_1 .bbox]
lappend macro_coords_list [concat {*}$bbox0]

set prev_macro_width [get_db inst:cell_2_0_inst/resource_1_inst/sram_inst/sram_256x64.sram_macro_1 .bbox.width]
set x3 [expr {$x3 + $prev_macro_width + $distance_sram_macros_x}]
place_inst cell_2_0_inst/resource_1_inst/sram_inst/sram_256x64.sram_macro_2 $x3 $y3
set bbox0 [get_db inst:cell_2_0_inst/resource_1_inst/sram_inst/sram_256x64.sram_macro_2 .bbox]
lappend macro_coords_list [concat {*}$bbox0]

set prev_macro_width [get_db inst:cell_2_0_inst/resource_1_inst/sram_inst/sram_256x64.sram_macro_2 .bbox.width]
set x3 [expr {$x3 + $prev_macro_width + $distance_sram_macros_x}]
place_inst cell_2_0_inst/resource_1_inst/sram_inst/sram_256x64.sram_macro_3 $x3 $y3
set bbox0 [get_db inst:cell_2_0_inst/resource_1_inst/sram_inst/sram_256x64.sram_macro_3 .bbox]
lappend macro_coords_list [concat {*}$bbox0]


# Cell cell_2_1_inst at (row: 0, col: 1)

#Resource's Macros placement
set prev_macro_width [get_db inst:cell_2_1_inst/resource_1_inst/sram_inst/sram_256x64.sram_macro_3 .bbox.width]
set x3 [expr {$x_sram_macro + $prev_macro_width*4 + $distance_sram_macros_x*4}]
set macro_height [get_db inst:cell_2_1_inst/resource_1_inst/sram_inst/sram_256x64.sram_macro_3 .bbox.length]
set y3 [expr {$y_side - $macro_height - $y_sram_macro}]
place_inst cell_2_1_inst/resource_1_inst/sram_inst/sram_256x64.sram_macro_0 $x3 $y3
set bbox0 [get_db inst:cell_2_1_inst/resource_1_inst/sram_inst/sram_256x64.sram_macro_0 .bbox]
lappend macro_coords_list [concat {*}$bbox0]

set prev_macro_width [get_db inst:cell_2_1_inst/resource_1_inst/sram_inst/sram_256x64.sram_macro_0 .bbox.width]
set x3 [expr {$x3 + $prev_macro_width + $distance_sram_macros_x}]
place_inst cell_2_1_inst/resource_1_inst/sram_inst/sram_256x64.sram_macro_1 $x3 $y3
set bbox0 [get_db inst:cell_2_1_inst/resource_1_inst/sram_inst/sram_256x64.sram_macro_1 .bbox]
lappend macro_coords_list [concat {*}$bbox0]

set x3 [expr {$x_sram_macro}]
set macro_height [get_db inst:cell_2_1_inst/resource_1_inst/sram_inst/sram_256x64.sram_macro_1 .bbox.length]
set y3 [expr {$y_side - ($y_sram_macro + $macro_height*2 + $distance_sram_macros_y)}]
place_inst cell_2_1_inst/resource_1_inst/sram_inst/sram_256x64.sram_macro_2 $x3 $y3
set bbox0 [get_db inst:cell_2_1_inst/resource_1_inst/sram_inst/sram_256x64.sram_macro_2 .bbox]
lappend macro_coords_list [concat {*}$bbox0]

set prev_macro_width [get_db inst:cell_2_1_inst/resource_1_inst/sram_inst/sram_256x64.sram_macro_2 .bbox.width]
set x3 [expr {$x3 + $prev_macro_width + $distance_sram_macros_x}]
place_inst cell_2_1_inst/resource_1_inst/sram_inst/sram_256x64.sram_macro_3 $x3 $y3
set bbox0 [get_db inst:cell_2_1_inst/resource_1_inst/sram_inst/sram_256x64.sram_macro_3 .bbox]
lappend macro_coords_list [concat {*}$bbox0]


# Cell cell_2_2_inst at (row: 0, col: 2)

#Resource's Macros placement
set prev_macro_width [get_db inst:cell_2_2_inst/resource_1_inst/sram_inst/sram_256x64.sram_macro_3 .bbox.width]
set x3 [expr {$x_sram_macro + $prev_macro_width*2 + $distance_sram_macros_x*2}]
set macro_height [get_db inst:cell_2_2_inst/resource_1_inst/sram_inst/sram_256x64.sram_macro_3 .bbox.length]
set y3 [expr {$y_side - ($y_sram_macro + $macro_height*2 + $distance_sram_macros_y)}]
place_inst cell_2_2_inst/resource_1_inst/sram_inst/sram_256x64.sram_macro_0 $x3 $y3
set bbox0 [get_db inst:cell_2_2_inst/resource_1_inst/sram_inst/sram_256x64.sram_macro_0 .bbox]
lappend macro_coords_list [concat {*}$bbox0]

set prev_macro_width [get_db inst:cell_2_2_inst/resource_1_inst/sram_inst/sram_256x64.sram_macro_0 .bbox.width]
set x3 [expr {$x3 + $prev_macro_width + $distance_sram_macros_x}]
place_inst cell_2_2_inst/resource_1_inst/sram_inst/sram_256x64.sram_macro_1 $x3 $y3
set bbox0 [get_db inst:cell_2_2_inst/resource_1_inst/sram_inst/sram_256x64.sram_macro_1 .bbox]
lappend macro_coords_list [concat {*}$bbox0]

set prev_macro_width [get_db inst:cell_2_2_inst/resource_1_inst/sram_inst/sram_256x64.sram_macro_1 .bbox.width]
set x3 [expr {$x3 + $prev_macro_width + $distance_sram_macros_x}]
place_inst cell_2_2_inst/resource_1_inst/sram_inst/sram_256x64.sram_macro_2 $x3 $y3
set bbox0 [get_db inst:cell_2_2_inst/resource_1_inst/sram_inst/sram_256x64.sram_macro_2 .bbox]
lappend macro_coords_list [concat {*}$bbox0]

set prev_macro_width [get_db inst:cell_2_2_inst/resource_1_inst/sram_inst/sram_256x64.sram_macro_2 .bbox.width]
set x3 [expr {$x3 + $prev_macro_width + $distance_sram_macros_x}]
place_inst cell_2_2_inst/resource_1_inst/sram_inst/sram_256x64.sram_macro_3 $x3 $y3
set bbox0 [get_db inst:cell_2_2_inst/resource_1_inst/sram_inst/sram_256x64.sram_macro_3 .bbox]
lappend macro_coords_list [concat {*}$bbox0]


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

set x_offset 16.8
set y_offset 16.8
set x1 0
set y1 0
set x2 [expr {$x1 + $x_side}]
set y2 [expr {$y_offset}]

set area_blockage [list \
    $x1 $y1 \
    $x2 $y2]
create_place_blockage -area $area_blockage

set x1 [expr {$x_side - $x_offset}]
set y1 0
set x2 [expr {$x1 + $x_offset}]
set y2 [expr {$y1 + $y_side}]

set area_blockage [list \
    $x1 $y1 \
    $x2 $y2]
create_place_blockage -area $area_blockage

set x1 0
set y1 [expr {$y_side - $y_offset}]
set x2 [expr {$x1 + $x_side}]
set y2 [expr {$y1 + $y_offset}]

set area_blockage [list \
    $x1 $y1 \
    $x2 $y2]
create_place_blockage -area $area_blockage

set x1 0
set y1 0
set x2 [expr {$x1 + $x_offset}]
set y2 [expr {$y1 + $y_side}]

set area_blockage [list \
    $x1 $y1 \
    $x2 $y2]
create_place_blockage -area $area_blockage

# add endcaps
set_db add_endcaps_right_edge BOUNDARY_RIGHTBWP30P140
set_db add_endcaps_left_edge BOUNDARY_LEFTBWP30P140
add_endcaps

# add well taps
add_well_taps -checker_board -cell_interval 30 -cell TAPCELLBWP30P140


# Floorplan generation complete

