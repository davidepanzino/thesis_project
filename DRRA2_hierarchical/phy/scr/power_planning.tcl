#rings around the whole fabric
add_rings -nets {VDD VSS} -type core_rings -follow io -layer {top M7 bottom M7 left M8 right M8} -width {top 5 bottom 5 left 5 right 5} -spacing {top 1.8 bottom 1.8 left 1.8 right 1.8} -offset {top 5 bottom 5 left 5 right 5} -center 0 -threshold 0 -jog_distance 0 -snap_wire_center_to_grid none



#stripes to outer world
set vertical_pairs 4
set horizontal_pairs 2
set vertical_distance [expr {($seq_height + $swb_router_height)/($vertical_pairs + 1)}]
set horizontal_distance [expr {($seq_width + $resource_width + $swb_router_width)/($horizontal_pairs + 1)}]
set x_offset 8.0
set y_offset 8.0

set_db add_stripes_ignore_block_check false ; set_db add_stripes_break_at none ; set_db add_stripes_route_over_rows_only false ; set_db add_stripes_rows_without_stripes_only false ; set_db add_stripes_extend_to_closest_target ring ; set_db add_stripes_stop_at_last_wire_for_area false ; set_db add_stripes_partial_set_through_domain false ; set_db add_stripes_ignore_non_default_domains true ; set_db add_stripes_trim_antenna_back_to_shape block_ring ; set_db add_stripes_spacing_type edge_to_edge ; set_db add_stripes_spacing_from_block 0 ; set_db add_stripes_stripe_min_length stripe_width ; set_db add_stripes_stacked_via_top_layer AP ; set_db add_stripes_stacked_via_bottom_layer M1 ; set_db add_stripes_via_using_exact_crossover_size true ; set_db add_stripes_split_vias false ; set_db add_stripes_orthogonal_only true ; set_db add_stripes_allow_jog { padcore_ring  block_ring } ; set_db add_stripes_skip_via_on_pin {  standardcell } ; set_db add_stripes_skip_via_on_wire_shape {  noshape   }
for {set j 0} {$j < $rows} {incr j} {
    #left side
    set x1 0
    set y1 [expr {$y_margin + $vertical_distance + $y_length * $j}]
    set x2 [expr {$x_offset}]
    set y2 [expr {$y1 + $y_length - $vertical_distance}]
    set area_stripe [list \
        $x1 $y1 \
        $x2 $y1 \
        $x2 $y2 \
        $x1 $y2]
    add_stripes -nets {VDD VSS} -layer M7 -direction horizontal -width 5 -spacing 1.8 -set_to_set_distance $vertical_distance -area $area_stripe -start_from bottom -switch_layer_over_obs false -max_same_layer_jog_length 2 -pad_core_ring_top_layer_limit AP -pad_core_ring_bottom_layer_limit M1 -block_ring_top_layer_limit AP -block_ring_bottom_layer_limit M1 -use_wire_group 0 -snap_wire_center_to_grid none

    #right side
    set x1 [expr {$x_margin * 2 + $x_length*$columns - $x_offset}]
    set y1 [expr {$y_margin + $vertical_distance + $y_length * $j}]
    set x2 [expr {$x1 + $x_offset}]
    set y2 [expr {$y1 + $y_length - $vertical_distance}]
    set area_stripe [list \
        $x1 $y1 \
        $x2 $y1 \
        $x2 $y2 \
        $x1 $y2]
    add_stripes -nets {VDD VSS} -layer M7 -direction horizontal -width 5 -spacing 1.8 -set_to_set_distance $vertical_distance -area $area_stripe -start_from bottom -switch_layer_over_obs false -max_same_layer_jog_length 2 -pad_core_ring_top_layer_limit AP -pad_core_ring_bottom_layer_limit M1 -block_ring_top_layer_limit AP -block_ring_bottom_layer_limit M1 -use_wire_group 0 -snap_wire_center_to_grid none
}

for {set i 0} {$i < $columns} {incr i} {
    #bottom side
    set x1 [expr {$x_margin + $horizontal_distance + $x_length *$i}]
    set y1 0
    set x2 [expr {$x1 + $x_length - $horizontal_distance}]
    set y2 [expr {$y_offset}]
    set area_stripe [list \
        $x1 $y1 \
        $x2 $y1 \
        $x2 $y2 \
        $x1 $y2]
    add_stripes -nets {VDD VSS} -layer M8 -direction vertical -width 5 -spacing 1.8 -set_to_set_distance $horizontal_distance -area $area_stripe -start_from left -switch_layer_over_obs false -merge_stripes_value 10 -max_same_layer_jog_length 2 -pad_core_ring_top_layer_limit AP -pad_core_ring_bottom_layer_limit M1 -block_ring_top_layer_limit AP -block_ring_bottom_layer_limit M1 -use_wire_group 0 -snap_wire_center_to_grid none

    #top side
    set x1 [expr {$x_margin + $horizontal_distance + $x_length *$i}]
    set y1 [expr {$y_margin*2 + $y_length * $rows - $y_offset}]
    set x2 [expr {$x1 + $x_length - $horizontal_distance}]
    set y2 [expr {$y1 + $y_offset}]
    set area_stripe [list \
        $x1 $y1 \
        $x2 $y1 \
        $x2 $y2 \
        $x1 $y2]
    add_stripes -nets {VDD VSS} -layer M8 -direction vertical -width 5 -spacing 1.8 -set_to_set_distance $horizontal_distance -area $area_stripe -start_from left -switch_layer_over_obs false -merge_stripes_value 10 -max_same_layer_jog_length 2 -pad_core_ring_top_layer_limit AP -pad_core_ring_bottom_layer_limit M1 -block_ring_top_layer_limit AP -block_ring_bottom_layer_limit M1 -use_wire_group 0 -snap_wire_center_to_grid none
}



#rings for partitions with no macros
for {set i 0} {$i < $columns} {incr i} {
    for {set j 0} {$j < $rows} {incr j} {
        #controller
        set x1 [expr {$x_length * $i + $x_margin}]
        set y1 [expr {$y_length * $j + $y_margin + $swb_router_height}]
        set x2 [expr {$x1 + $seq_width}]
        set y2 [expr {$y1 + $seq_height}]
        set coordinates [list \
            $x1 $y1 \
            $x2 $y1 \
            $x2 $y2 \
            $x1 $y2]
        set new_coordinates [list \
            [expr {[lindex $coordinates 0] + $x_offset}] \
            [expr {[lindex $coordinates 1] + $y_offset}] \
            [expr {[lindex $coordinates 2] - $x_offset}] \
            [expr {[lindex $coordinates 3] + $y_offset}] \
            [expr {[lindex $coordinates 4] - $x_offset}] \
            [expr {[lindex $coordinates 5] - $y_offset}] \
            [expr {[lindex $coordinates 6] + $x_offset}] \
            [expr {[lindex $coordinates 7] - $y_offset}]]
        add_rings -nets {VDD VSS} -around user_defined -user_defined_region $new_coordinates \
            -type block_rings \
            -layer {top M7 bottom M7 left M8 right M8} \
            -width {top 1.8 bottom 1.8 left 1.8 right 1.8} \
            -spacing {top 1.8 bottom 1.8 left 1.8 right 1.8} \
            -offset {top 1.8 bottom 1.8 left 1.8 right 1.8} \
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
        set coordinates [list \
            $x1 $y1 \
            $x2 $y1 \
            $x4 $y4 \
            $x3 $y4 \
            $x3 $y3 \
            $x1 $y2]
        set new_coordinates [list \
            [expr {[lindex $coordinates 0] + $x_offset}] \
            [expr {[lindex $coordinates 1] + $y_offset}] \
            [expr {[lindex $coordinates 2] - $x_offset}] \
            [expr {[lindex $coordinates 3] + $y_offset}] \
            [expr {[lindex $coordinates 4] - $x_offset}] \
            [expr {[lindex $coordinates 5] - $y_offset}] \
            [expr {[lindex $coordinates 6] + $x_offset}] \
            [expr {[lindex $coordinates 7] - $y_offset}] \
            [expr {[lindex $coordinates 8] + $x_offset}] \
            [expr {[lindex $coordinates 9] - $y_offset}] \
            [expr {[lindex $coordinates 10] + $x_offset}] \
            [expr {[lindex $coordinates 11] - $y_offset}]]
        add_rings -nets {VDD VSS} -around user_defined -user_defined_region $new_coordinates \
            -type block_rings \
            -layer {top M7 bottom M7 left M8 right M8} \
            -width {top 1.8 bottom 1.8 left 1.8 right 1.8} \
            -spacing {top 1.8 bottom 1.8 left 1.8 right 1.8} \
            -offset {top 1.8 bottom 1.8 left 1.8 right 1.8} \
            -center 0 -threshold 0 -jog_distance 0 -snap_wire_center_to_grid none

        #resources
        for {set k 0} {$k < 16} {incr k} {
            if { ($i == 0 && $j == 2) || ($i == 1 && $j == 2) || ($i == 2 && $j == 2) || ($i == 0 && $j == 0) || ($i == 1 && $j == 0) || ($i == 2 && $j == 0) } {
                if { $i == 0 && $j == 2 && ($k+1) != 1 && ($k+1) != 2 && ($k+1) != 3 && ($k+1) != 4 && ($k+1) != 5 && ($k+1) != 6 } {
                    set x1 [expr {$x_length * $i + $x_margin + $seq_width}]
                    set y1 [expr {$y_length * $j + $y_margin + $swb_router_height + $resource_height * $k}]
                    set x2 [expr {$x1 + $resource_width}]
                    set y2 [expr {$y1 + $resource_height}]
                    set coordinates [list \
                        $x1 $y1 \
                        $x2 $y1 \
                        $x2 $y2 \
                        $x1 $y2]
                    set new_coordinates [list \
                        [expr {[lindex $coordinates 0] + $x_offset}] \
                        [expr {[lindex $coordinates 1] + $y_offset}] \
                        [expr {[lindex $coordinates 2] - $x_offset}] \
                        [expr {[lindex $coordinates 3] + $y_offset}] \
                        [expr {[lindex $coordinates 4] - $x_offset}] \
                        [expr {[lindex $coordinates 5] - $y_offset}] \
                        [expr {[lindex $coordinates 6] + $x_offset}] \
                        [expr {[lindex $coordinates 7] - $y_offset}]]
                    add_rings -nets {VDD VSS} -around user_defined -user_defined_region $new_coordinates \
                        -type block_rings \
                        -layer {top M7 bottom M7 left M8 right M8} \
                        -width {top 1.8 bottom 1.8 left 1.8 right 1.8} \
                        -spacing {top 1.8 bottom 1.8 left 1.8 right 1.8} \
                        -offset {top 1.8 bottom 1.8 left 1.8 right 1.8} \
                        -center 0 -threshold 0 -jog_distance 0 -snap_wire_center_to_grid none
                }

                if { $i == 1 && $j == 2 && ($k+1) != 1 && ($k+1) != 2 && ($k+1) != 3 && ($k+1) != 4 && ($k+1) != 5 && ($k+1) != 6 } {
                    set x1 [expr {$x_length * $i + $x_margin + $seq_width}]
                    set y1 [expr {$y_length * $j + $y_margin + $swb_router_height + $resource_height * $k}]
                    set x2 [expr {$x1 + $resource_width}]
                    set y2 [expr {$y1 + $resource_height}]
                    set coordinates [list \
                        $x1 $y1 \
                        $x2 $y1 \
                        $x2 $y2 \
                        $x1 $y2]
                    set new_coordinates [list \
                        [expr {[lindex $coordinates 0] + $x_offset}] \
                        [expr {[lindex $coordinates 1] + $y_offset}] \
                        [expr {[lindex $coordinates 2] - $x_offset}] \
                        [expr {[lindex $coordinates 3] + $y_offset}] \
                        [expr {[lindex $coordinates 4] - $x_offset}] \
                        [expr {[lindex $coordinates 5] - $y_offset}] \
                        [expr {[lindex $coordinates 6] + $x_offset}] \
                        [expr {[lindex $coordinates 7] - $y_offset}]]
                    add_rings -nets {VDD VSS} -around user_defined -user_defined_region $new_coordinates \
                        -type block_rings \
                        -layer {top M7 bottom M7 left M8 right M8} \
                        -width {top 1.8 bottom 1.8 left 1.8 right 1.8} \
                        -spacing {top 1.8 bottom 1.8 left 1.8 right 1.8} \
                        -offset {top 1.8 bottom 1.8 left 1.8 right 1.8} \
                        -center 0 -threshold 0 -jog_distance 0 -snap_wire_center_to_grid none
                }

                if { $i == 2 && $j == 2 && ($k+1) != 1 && ($k+1) != 2 && ($k+1) != 3 && ($k+1) != 4 && ($k+1) != 5 && ($k+1) != 6 } {
                    set x1 [expr {$x_length * $i + $x_margin + $seq_width}]
                    set y1 [expr {$y_length * $j + $y_margin + $swb_router_height + $resource_height * $k}]
                    set x2 [expr {$x1 + $resource_width}]
                    set y2 [expr {$y1 + $resource_height}]
                    set coordinates [list \
                        $x1 $y1 \
                        $x2 $y1 \
                        $x2 $y2 \
                        $x1 $y2]
                    set new_coordinates [list \
                        [expr {[lindex $coordinates 0] + $x_offset}] \
                        [expr {[lindex $coordinates 1] + $y_offset}] \
                        [expr {[lindex $coordinates 2] - $x_offset}] \
                        [expr {[lindex $coordinates 3] + $y_offset}] \
                        [expr {[lindex $coordinates 4] - $x_offset}] \
                        [expr {[lindex $coordinates 5] - $y_offset}] \
                        [expr {[lindex $coordinates 6] + $x_offset}] \
                        [expr {[lindex $coordinates 7] - $y_offset}]]
                    add_rings -nets {VDD VSS} -around user_defined -user_defined_region $new_coordinates \
                        -type block_rings \
                        -layer {top M7 bottom M7 left M8 right M8} \
                        -width {top 1.8 bottom 1.8 left 1.8 right 1.8} \
                        -spacing {top 1.8 bottom 1.8 left 1.8 right 1.8} \
                        -offset {top 1.8 bottom 1.8 left 1.8 right 1.8} \
                        -center 0 -threshold 0 -jog_distance 0 -snap_wire_center_to_grid none
                }

                if { $i == 0 && $j == 0 && ($k+1) != 1 && ($k+1) != 2 && ($k+1) != 3 && ($k+1) != 4 && ($k+1) != 5 && ($k+1) != 6 } {
                    set x1 [expr {$x_length * $i + $x_margin + $seq_width}]
                    set y1 [expr {$y_length * $j + $y_margin + $swb_router_height + $resource_height * $k}]
                    set x2 [expr {$x1 + $resource_width}]
                    set y2 [expr {$y1 + $resource_height}]
                    set coordinates [list \
                        $x1 $y1 \
                        $x2 $y1 \
                        $x2 $y2 \
                        $x1 $y2]
                    set new_coordinates [list \
                        [expr {[lindex $coordinates 0] + $x_offset}] \
                        [expr {[lindex $coordinates 1] + $y_offset}] \
                        [expr {[lindex $coordinates 2] - $x_offset}] \
                        [expr {[lindex $coordinates 3] + $y_offset}] \
                        [expr {[lindex $coordinates 4] - $x_offset}] \
                        [expr {[lindex $coordinates 5] - $y_offset}] \
                        [expr {[lindex $coordinates 6] + $x_offset}] \
                        [expr {[lindex $coordinates 7] - $y_offset}]]
                    add_rings -nets {VDD VSS} -around user_defined -user_defined_region $new_coordinates \
                        -type block_rings \
                        -layer {top M7 bottom M7 left M8 right M8} \
                        -width {top 1.8 bottom 1.8 left 1.8 right 1.8} \
                        -spacing {top 1.8 bottom 1.8 left 1.8 right 1.8} \
                        -offset {top 1.8 bottom 1.8 left 1.8 right 1.8} \
                        -center 0 -threshold 0 -jog_distance 0 -snap_wire_center_to_grid none
                }

                if { $i == 1 && $j == 0 && ($k+1) != 1 && ($k+1) != 2 && ($k+1) != 3 && ($k+1) != 4 && ($k+1) != 5 && ($k+1) != 6 } {
                    set x1 [expr {$x_length * $i + $x_margin + $seq_width}]
                    set y1 [expr {$y_length * $j + $y_margin + $swb_router_height + $resource_height * $k}]
                    set x2 [expr {$x1 + $resource_width}]
                    set y2 [expr {$y1 + $resource_height}]
                    set coordinates [list \
                        $x1 $y1 \
                        $x2 $y1 \
                        $x2 $y2 \
                        $x1 $y2]
                    set new_coordinates [list \
                        [expr {[lindex $coordinates 0] + $x_offset}] \
                        [expr {[lindex $coordinates 1] + $y_offset}] \
                        [expr {[lindex $coordinates 2] - $x_offset}] \
                        [expr {[lindex $coordinates 3] + $y_offset}] \
                        [expr {[lindex $coordinates 4] - $x_offset}] \
                        [expr {[lindex $coordinates 5] - $y_offset}] \
                        [expr {[lindex $coordinates 6] + $x_offset}] \
                        [expr {[lindex $coordinates 7] - $y_offset}]]
                    add_rings -nets {VDD VSS} -around user_defined -user_defined_region $new_coordinates \
                        -type block_rings \
                        -layer {top M7 bottom M7 left M8 right M8} \
                        -width {top 1.8 bottom 1.8 left 1.8 right 1.8} \
                        -spacing {top 1.8 bottom 1.8 left 1.8 right 1.8} \
                        -offset {top 1.8 bottom 1.8 left 1.8 right 1.8} \
                        -center 0 -threshold 0 -jog_distance 0 -snap_wire_center_to_grid none
                }

                if { $i == 2 && $j == 0 && ($k+1) != 1 && ($k+1) != 2 && ($k+1) != 3 && ($k+1) != 4 && ($k+1) != 5 && ($k+1) != 6 } {
                    set x1 [expr {$x_length * $i + $x_margin + $seq_width}]
                    set y1 [expr {$y_length * $j + $y_margin + $swb_router_height + $resource_height * $k}]
                    set x2 [expr {$x1 + $resource_width}]
                    set y2 [expr {$y1 + $resource_height}]
                    set coordinates [list \
                        $x1 $y1 \
                        $x2 $y1 \
                        $x2 $y2 \
                        $x1 $y2]
                    set new_coordinates [list \
                        [expr {[lindex $coordinates 0] + $x_offset}] \
                        [expr {[lindex $coordinates 1] + $y_offset}] \
                        [expr {[lindex $coordinates 2] - $x_offset}] \
                        [expr {[lindex $coordinates 3] + $y_offset}] \
                        [expr {[lindex $coordinates 4] - $x_offset}] \
                        [expr {[lindex $coordinates 5] - $y_offset}] \
                        [expr {[lindex $coordinates 6] + $x_offset}] \
                        [expr {[lindex $coordinates 7] - $y_offset}]]
                    add_rings -nets {VDD VSS} -around user_defined -user_defined_region $new_coordinates \
                        -type block_rings \
                        -layer {top M7 bottom M7 left M8 right M8} \
                        -width {top 1.8 bottom 1.8 left 1.8 right 1.8} \
                        -spacing {top 1.8 bottom 1.8 left 1.8 right 1.8} \
                        -offset {top 1.8 bottom 1.8 left 1.8 right 1.8} \
                        -center 0 -threshold 0 -jog_distance 0 -snap_wire_center_to_grid none
                }

            } else {
                set x1 [expr {$x_length * $i + $x_margin + $seq_width}]
                set y1 [expr {$y_length * $j + $y_margin + $swb_router_height + $resource_height * $k}]
                set x2 [expr {$x1 + $resource_width}]
                set y2 [expr {$y1 + $resource_height}]
                set coordinates [list \
                    $x1 $y1 \
                    $x2 $y1 \
                    $x2 $y2 \
                    $x1 $y2]
                set new_coordinates [list \
                    [expr {[lindex $coordinates 0] + $x_offset}] \
                    [expr {[lindex $coordinates 1] + $y_offset}] \
                    [expr {[lindex $coordinates 2] - $x_offset}] \
                    [expr {[lindex $coordinates 3] + $y_offset}] \
                    [expr {[lindex $coordinates 4] - $x_offset}] \
                    [expr {[lindex $coordinates 5] - $y_offset}] \
                    [expr {[lindex $coordinates 6] + $x_offset}] \
                    [expr {[lindex $coordinates 7] - $y_offset}]]
                add_rings -nets {VDD VSS} -around user_defined -user_defined_region $new_coordinates \
                    -type block_rings \
                    -layer {top M7 bottom M7 left M8 right M8} \
                    -width {top 1.8 bottom 1.8 left 1.8 right 1.8} \
                    -spacing {top 1.8 bottom 1.8 left 1.8 right 1.8} \
                    -offset {top 1.8 bottom 1.8 left 1.8 right 1.8} \
                    -center 0 -threshold 0 -jog_distance 0 -snap_wire_center_to_grid none
            }
        }
    }
}



#rings for partitions with macros
set x1 [expr {$x_length * 0 + $x_margin + $seq_width}]
set y1 [expr {$y_length * 2 + $y_margin + $swb_router_height + $resource_height * 0}]
set x2 [expr {$x1 + $resource_width}]
set y2 [expr {$y1 + $resource_height * 6}]
set coordinates [list \
    $x1 $y1 \
    $x2 $y1 \
    $x2 $y2 \
    $x1 $y2]
set new_coordinates [list \
    [expr {[lindex $coordinates 0] + $x_offset}] \
    [expr {[lindex $coordinates 1] + $y_offset}] \
    [expr {[lindex $coordinates 2] - $x_offset}] \
    [expr {[lindex $coordinates 3] + $y_offset}] \
    [expr {[lindex $coordinates 4] - $x_offset}] \
    [expr {[lindex $coordinates 5] - $y_offset}] \
    [expr {[lindex $coordinates 6] + $x_offset}] \
    [expr {[lindex $coordinates 7] - $y_offset}]]
add_rings -nets {VDD VSS} -around user_defined -user_defined_region $new_coordinates \
    -type block_rings \
    -layer {top M7 bottom M7 left M8 right M8} \
    -width {top 1.8 bottom 1.8 left 1.8 right 1.8} \
    -spacing {top 1.8 bottom 1.8 left 1.8 right 1.8} \
    -offset {top 1.8 bottom 1.8 left 1.8 right 1.8} \
    -center 0 -threshold 0 -jog_distance 0 -snap_wire_center_to_grid none

set x1 [expr {$x_length * 1 + $x_margin + $seq_width}]
set y1 [expr {$y_length * 2 + $y_margin + $swb_router_height + $resource_height * 0}]
set x2 [expr {$x1 + $resource_width}]
set y2 [expr {$y1 + $resource_height * 6}]
set coordinates [list \
    $x1 $y1 \
    $x2 $y1 \
    $x2 $y2 \
    $x1 $y2]
set new_coordinates [list \
    [expr {[lindex $coordinates 0] + $x_offset}] \
    [expr {[lindex $coordinates 1] + $y_offset}] \
    [expr {[lindex $coordinates 2] - $x_offset}] \
    [expr {[lindex $coordinates 3] + $y_offset}] \
    [expr {[lindex $coordinates 4] - $x_offset}] \
    [expr {[lindex $coordinates 5] - $y_offset}] \
    [expr {[lindex $coordinates 6] + $x_offset}] \
    [expr {[lindex $coordinates 7] - $y_offset}]]
add_rings -nets {VDD VSS} -around user_defined -user_defined_region $new_coordinates \
    -type block_rings \
    -layer {top M7 bottom M7 left M8 right M8} \
    -width {top 1.8 bottom 1.8 left 1.8 right 1.8} \
    -spacing {top 1.8 bottom 1.8 left 1.8 right 1.8} \
    -offset {top 1.8 bottom 1.8 left 1.8 right 1.8} \
    -center 0 -threshold 0 -jog_distance 0 -snap_wire_center_to_grid none

set x1 [expr {$x_length * 2 + $x_margin + $seq_width}]
set y1 [expr {$y_length * 2 + $y_margin + $swb_router_height + $resource_height * 0}]
set x2 [expr {$x1 + $resource_width}]
set y2 [expr {$y1 + $resource_height * 6}]
set coordinates [list \
    $x1 $y1 \
    $x2 $y1 \
    $x2 $y2 \
    $x1 $y2]
set new_coordinates [list \
    [expr {[lindex $coordinates 0] + $x_offset}] \
    [expr {[lindex $coordinates 1] + $y_offset}] \
    [expr {[lindex $coordinates 2] - $x_offset}] \
    [expr {[lindex $coordinates 3] + $y_offset}] \
    [expr {[lindex $coordinates 4] - $x_offset}] \
    [expr {[lindex $coordinates 5] - $y_offset}] \
    [expr {[lindex $coordinates 6] + $x_offset}] \
    [expr {[lindex $coordinates 7] - $y_offset}]]
add_rings -nets {VDD VSS} -around user_defined -user_defined_region $new_coordinates \
    -type block_rings \
    -layer {top M7 bottom M7 left M8 right M8} \
    -width {top 1.8 bottom 1.8 left 1.8 right 1.8} \
    -spacing {top 1.8 bottom 1.8 left 1.8 right 1.8} \
    -offset {top 1.8 bottom 1.8 left 1.8 right 1.8} \
    -center 0 -threshold 0 -jog_distance 0 -snap_wire_center_to_grid none

set x1 [expr {$x_length * 0 + $x_margin + $seq_width}]
set y1 [expr {$y_length * 0 + $y_margin + $swb_router_height + $resource_height * 0}]
set x2 [expr {$x1 + $resource_width}]
set y2 [expr {$y1 + $resource_height * 6}]
set coordinates [list \
    $x1 $y1 \
    $x2 $y1 \
    $x2 $y2 \
    $x1 $y2]
set new_coordinates [list \
    [expr {[lindex $coordinates 0] + $x_offset}] \
    [expr {[lindex $coordinates 1] + $y_offset}] \
    [expr {[lindex $coordinates 2] - $x_offset}] \
    [expr {[lindex $coordinates 3] + $y_offset}] \
    [expr {[lindex $coordinates 4] - $x_offset}] \
    [expr {[lindex $coordinates 5] - $y_offset}] \
    [expr {[lindex $coordinates 6] + $x_offset}] \
    [expr {[lindex $coordinates 7] - $y_offset}]]
add_rings -nets {VDD VSS} -around user_defined -user_defined_region $new_coordinates \
    -type block_rings \
    -layer {top M7 bottom M7 left M8 right M8} \
    -width {top 1.8 bottom 1.8 left 1.8 right 1.8} \
    -spacing {top 1.8 bottom 1.8 left 1.8 right 1.8} \
    -offset {top 1.8 bottom 1.8 left 1.8 right 1.8} \
    -center 0 -threshold 0 -jog_distance 0 -snap_wire_center_to_grid none

set x1 [expr {$x_length * 1 + $x_margin + $seq_width}]
set y1 [expr {$y_length * 0 + $y_margin + $swb_router_height + $resource_height * 0}]
set x2 [expr {$x1 + $resource_width}]
set y2 [expr {$y1 + $resource_height * 6}]
set coordinates [list \
    $x1 $y1 \
    $x2 $y1 \
    $x2 $y2 \
    $x1 $y2]
set new_coordinates [list \
    [expr {[lindex $coordinates 0] + $x_offset}] \
    [expr {[lindex $coordinates 1] + $y_offset}] \
    [expr {[lindex $coordinates 2] - $x_offset}] \
    [expr {[lindex $coordinates 3] + $y_offset}] \
    [expr {[lindex $coordinates 4] - $x_offset}] \
    [expr {[lindex $coordinates 5] - $y_offset}] \
    [expr {[lindex $coordinates 6] + $x_offset}] \
    [expr {[lindex $coordinates 7] - $y_offset}]]
add_rings -nets {VDD VSS} -around user_defined -user_defined_region $new_coordinates \
    -type block_rings \
    -layer {top M7 bottom M7 left M8 right M8} \
    -width {top 1.8 bottom 1.8 left 1.8 right 1.8} \
    -spacing {top 1.8 bottom 1.8 left 1.8 right 1.8} \
    -offset {top 1.8 bottom 1.8 left 1.8 right 1.8} \
    -center 0 -threshold 0 -jog_distance 0 -snap_wire_center_to_grid none

set x1 [expr {$x_length * 2 + $x_margin + $seq_width}]
set y1 [expr {$y_length * 0 + $y_margin + $swb_router_height + $resource_height * 0}]
set x2 [expr {$x1 + $resource_width}]
set y2 [expr {$y1 + $resource_height * 6}]
set coordinates [list \
    $x1 $y1 \
    $x2 $y1 \
    $x2 $y2 \
    $x1 $y2]
set new_coordinates [list \
    [expr {[lindex $coordinates 0] + $x_offset}] \
    [expr {[lindex $coordinates 1] + $y_offset}] \
    [expr {[lindex $coordinates 2] - $x_offset}] \
    [expr {[lindex $coordinates 3] + $y_offset}] \
    [expr {[lindex $coordinates 4] - $x_offset}] \
    [expr {[lindex $coordinates 5] - $y_offset}] \
    [expr {[lindex $coordinates 6] + $x_offset}] \
    [expr {[lindex $coordinates 7] - $y_offset}]]
add_rings -nets {VDD VSS} -around user_defined -user_defined_region $new_coordinates \
    -type block_rings \
    -layer {top M7 bottom M7 left M8 right M8} \
    -width {top 1.8 bottom 1.8 left 1.8 right 1.8} \
    -spacing {top 1.8 bottom 1.8 left 1.8 right 1.8} \
    -offset {top 1.8 bottom 1.8 left 1.8 right 1.8} \
    -center 0 -threshold 0 -jog_distance 0 -snap_wire_center_to_grid none



#rings around macros
add_rings -nets {VDD VSS} -type block_rings -around each_block -layer {top M5 bottom M5 left M6 right M6} -width {top 2 bottom 2 left 2 right 2} -spacing {top 1.5 bottom 1.5 left 1.5 right 1.5} -offset {top 2 bottom 2 left 2 right 2} -center 0 -threshold 0 -jog_distance 0 -snap_wire_center_to_grid none



#to connect macros VDD and VSS
connect_global_net VDD -type pg_pin -pin_base_name VDD -inst_base_name * -hinst {} -override -verbose
connect_global_net VSS -type pg_pin -pin_base_name VSS -inst_base_name * -hinst {} -override -verbose
route_special -nets {VDD VSS} -connect {block_pin} -block_pin all -block_pin_target {block_ring stripe ring} -allow_layer_change 1 -allow_jogging 1



#stripes to macros

#stripes to macros in cell row 2, col 0, slot 1

#vertical to macro num 0
set_db add_stripes_ignore_block_check false ; set_db add_stripes_break_at {  block_ring  outside_ringmacro  } ; set_db add_stripes_route_over_rows_only false ; set_db add_stripes_rows_without_stripes_only false ; set_db add_stripes_extend_to_closest_target none ; set_db add_stripes_stop_at_last_wire_for_area true ; set_db add_stripes_partial_set_through_domain false ; set_db add_stripes_ignore_non_default_domains false ; set_db add_stripes_trim_antenna_back_to_shape block_ring ; set_db add_stripes_spacing_type edge_to_edge ; set_db add_stripes_spacing_from_block 0 ; set_db add_stripes_stripe_min_length stripe_width ; set_db add_stripes_stacked_via_top_layer AP ; set_db add_stripes_stacked_via_bottom_layer M1 ; set_db add_stripes_via_using_exact_crossover_size false ; set_db add_stripes_split_vias false ; set_db add_stripes_orthogonal_only true ; set_db add_stripes_allow_jog { padcore_ring  block_ring } ; set_db add_stripes_skip_via_on_pin {  standardcell } ; set_db add_stripes_skip_via_on_wire_shape {  noshape   }
set x1 [expr {$x_margin + $seq_width + $x_sram_macro + $x_length * 0}]
set y1 [expr {$y_margin + $swb_router_height  + $resource_height * 0 + $y_length * 2}]
set macro_width [get_db inst:cell_0_0_inst/resource_1_inst/sram_inst/sram_256x64.sram_macro_0 .bbox.width]
set x2 [expr {$x1 + $macro_width}]
set y2 [expr {$y1 + $resource_height * 6}]
set prev_end [expr {$x2}]
set area_stripe [list \
    $x1 $y1 \
    $x2 $y1 \
    $x2 $y2 \
    $x1 $y2]
add_stripes -nets {VDD VSS} -layer M8 -direction vertical -width 1.8 -spacing 1.8 -number_of_sets 3 -area $area_stripe -start_from left -switch_layer_over_obs false -max_same_layer_jog_length 2 -pad_core_ring_top_layer_limit AP -pad_core_ring_bottom_layer_limit M1 -block_ring_top_layer_limit AP -block_ring_bottom_layer_limit M1 -use_wire_group 0 -snap_wire_center_to_grid none

#vertical stripe between macro 1 and 2
set_db add_stripes_ignore_block_check false ; set_db add_stripes_break_at {  block_ring  outside_ringmacro  } ; set_db add_stripes_route_over_rows_only false ; set_db add_stripes_rows_without_stripes_only false ; set_db add_stripes_extend_to_closest_target none ; set_db add_stripes_stop_at_last_wire_for_area true ; set_db add_stripes_partial_set_through_domain false ; set_db add_stripes_ignore_non_default_domains false ; set_db add_stripes_trim_antenna_back_to_shape block_ring ; set_db add_stripes_spacing_type edge_to_edge ; set_db add_stripes_spacing_from_block 0 ; set_db add_stripes_stripe_min_length stripe_width ; set_db add_stripes_stacked_via_top_layer AP ; set_db add_stripes_stacked_via_bottom_layer M1 ; set_db add_stripes_via_using_exact_crossover_size false ; set_db add_stripes_split_vias false ; set_db add_stripes_orthogonal_only true ; set_db add_stripes_allow_jog { padcore_ring  block_ring } ; set_db add_stripes_skip_via_on_pin {  standardcell } ; set_db add_stripes_skip_via_on_wire_shape {  noshape   }
set x1 [expr {$prev_end}]
set y1 [expr {$y_margin + $swb_router_height  + $resource_height * 0 + $y_length * 2}]
set x2 [expr {$x1 + $distance_sram_macros}]
set y2 [expr {$y1 + $resource_height * 6}]
set area_stripe [list \
    $x1 $y1 \
    $x2 $y1 \
    $x2 $y2 \
    $x1 $y2]
add_stripes -nets {VDD VSS} -layer M8 -direction vertical -width 1.8 -spacing 1.8 -number_of_sets 1 -area $area_stripe -start_from left -start_offset [expr {$distance_sram_macros/2}] -switch_layer_over_obs false -max_same_layer_jog_length 2 -pad_core_ring_top_layer_limit AP -pad_core_ring_bottom_layer_limit M1 -block_ring_top_layer_limit AP -block_ring_bottom_layer_limit M1 -use_wire_group 0 -snap_wire_center_to_grid none

#vertical to macro num 1
set_db add_stripes_ignore_block_check false ; set_db add_stripes_break_at {  block_ring  outside_ringmacro  } ; set_db add_stripes_route_over_rows_only false ; set_db add_stripes_rows_without_stripes_only false ; set_db add_stripes_extend_to_closest_target none ; set_db add_stripes_stop_at_last_wire_for_area true ; set_db add_stripes_partial_set_through_domain false ; set_db add_stripes_ignore_non_default_domains false ; set_db add_stripes_trim_antenna_back_to_shape block_ring ; set_db add_stripes_spacing_type edge_to_edge ; set_db add_stripes_spacing_from_block 0 ; set_db add_stripes_stripe_min_length stripe_width ; set_db add_stripes_stacked_via_top_layer AP ; set_db add_stripes_stacked_via_bottom_layer M1 ; set_db add_stripes_via_using_exact_crossover_size false ; set_db add_stripes_split_vias false ; set_db add_stripes_orthogonal_only true ; set_db add_stripes_allow_jog { padcore_ring  block_ring } ; set_db add_stripes_skip_via_on_pin {  standardcell } ; set_db add_stripes_skip_via_on_wire_shape {  noshape   }
set x1 [expr {$prev_end + $distance_sram_macros}]
set y1 [expr {$y_margin + $swb_router_height  + $resource_height * 0 + $y_length * 2}]
set macro_width [get_db inst:cell_0_0_inst/resource_1_inst/sram_inst/sram_256x64.sram_macro_1 .bbox.width]
set x2 [expr {$x1 + $macro_width}]
set y2 [expr {$y1 + $resource_height * 6}]
set prev_end [expr {$x2}]
set area_stripe [list \
    $x1 $y1 \
    $x2 $y1 \
    $x2 $y2 \
    $x1 $y2]
add_stripes -nets {VDD VSS} -layer M8 -direction vertical -width 1.8 -spacing 1.8 -number_of_sets 3 -area $area_stripe -start_from left -switch_layer_over_obs false -max_same_layer_jog_length 2 -pad_core_ring_top_layer_limit AP -pad_core_ring_bottom_layer_limit M1 -block_ring_top_layer_limit AP -block_ring_bottom_layer_limit M1 -use_wire_group 0 -snap_wire_center_to_grid none

#stripes to macros in cell row 2, col 1, slot 1

#vertical to macro num 0
set_db add_stripes_ignore_block_check false ; set_db add_stripes_break_at {  block_ring  outside_ringmacro  } ; set_db add_stripes_route_over_rows_only false ; set_db add_stripes_rows_without_stripes_only false ; set_db add_stripes_extend_to_closest_target none ; set_db add_stripes_stop_at_last_wire_for_area true ; set_db add_stripes_partial_set_through_domain false ; set_db add_stripes_ignore_non_default_domains false ; set_db add_stripes_trim_antenna_back_to_shape block_ring ; set_db add_stripes_spacing_type edge_to_edge ; set_db add_stripes_spacing_from_block 0 ; set_db add_stripes_stripe_min_length stripe_width ; set_db add_stripes_stacked_via_top_layer AP ; set_db add_stripes_stacked_via_bottom_layer M1 ; set_db add_stripes_via_using_exact_crossover_size false ; set_db add_stripes_split_vias false ; set_db add_stripes_orthogonal_only true ; set_db add_stripes_allow_jog { padcore_ring  block_ring } ; set_db add_stripes_skip_via_on_pin {  standardcell } ; set_db add_stripes_skip_via_on_wire_shape {  noshape   }
set x1 [expr {$x_margin + $seq_width + $x_sram_macro + $x_length * 1}]
set y1 [expr {$y_margin + $swb_router_height  + $resource_height * 0 + $y_length * 2}]
set macro_width [get_db inst:cell_0_1_inst/resource_1_inst/sram_inst/sram_256x64.sram_macro_0 .bbox.width]
set x2 [expr {$x1 + $macro_width}]
set y2 [expr {$y1 + $resource_height * 6}]
set prev_end [expr {$x2}]
set area_stripe [list \
    $x1 $y1 \
    $x2 $y1 \
    $x2 $y2 \
    $x1 $y2]
add_stripes -nets {VDD VSS} -layer M8 -direction vertical -width 1.8 -spacing 1.8 -number_of_sets 3 -area $area_stripe -start_from left -switch_layer_over_obs false -max_same_layer_jog_length 2 -pad_core_ring_top_layer_limit AP -pad_core_ring_bottom_layer_limit M1 -block_ring_top_layer_limit AP -block_ring_bottom_layer_limit M1 -use_wire_group 0 -snap_wire_center_to_grid none

#vertical stripe between macro 1 and 2
set_db add_stripes_ignore_block_check false ; set_db add_stripes_break_at {  block_ring  outside_ringmacro  } ; set_db add_stripes_route_over_rows_only false ; set_db add_stripes_rows_without_stripes_only false ; set_db add_stripes_extend_to_closest_target none ; set_db add_stripes_stop_at_last_wire_for_area true ; set_db add_stripes_partial_set_through_domain false ; set_db add_stripes_ignore_non_default_domains false ; set_db add_stripes_trim_antenna_back_to_shape block_ring ; set_db add_stripes_spacing_type edge_to_edge ; set_db add_stripes_spacing_from_block 0 ; set_db add_stripes_stripe_min_length stripe_width ; set_db add_stripes_stacked_via_top_layer AP ; set_db add_stripes_stacked_via_bottom_layer M1 ; set_db add_stripes_via_using_exact_crossover_size false ; set_db add_stripes_split_vias false ; set_db add_stripes_orthogonal_only true ; set_db add_stripes_allow_jog { padcore_ring  block_ring } ; set_db add_stripes_skip_via_on_pin {  standardcell } ; set_db add_stripes_skip_via_on_wire_shape {  noshape   }
set x1 [expr {$prev_end}]
set y1 [expr {$y_margin + $swb_router_height  + $resource_height * 0 + $y_length * 2}]
set x2 [expr {$x1 + $distance_sram_macros}]
set y2 [expr {$y1 + $resource_height * 6}]
set area_stripe [list \
    $x1 $y1 \
    $x2 $y1 \
    $x2 $y2 \
    $x1 $y2]
add_stripes -nets {VDD VSS} -layer M8 -direction vertical -width 1.8 -spacing 1.8 -number_of_sets 1 -area $area_stripe -start_from left -start_offset [expr {$distance_sram_macros/2}] -switch_layer_over_obs false -max_same_layer_jog_length 2 -pad_core_ring_top_layer_limit AP -pad_core_ring_bottom_layer_limit M1 -block_ring_top_layer_limit AP -block_ring_bottom_layer_limit M1 -use_wire_group 0 -snap_wire_center_to_grid none

#vertical to macro num 1
set_db add_stripes_ignore_block_check false ; set_db add_stripes_break_at {  block_ring  outside_ringmacro  } ; set_db add_stripes_route_over_rows_only false ; set_db add_stripes_rows_without_stripes_only false ; set_db add_stripes_extend_to_closest_target none ; set_db add_stripes_stop_at_last_wire_for_area true ; set_db add_stripes_partial_set_through_domain false ; set_db add_stripes_ignore_non_default_domains false ; set_db add_stripes_trim_antenna_back_to_shape block_ring ; set_db add_stripes_spacing_type edge_to_edge ; set_db add_stripes_spacing_from_block 0 ; set_db add_stripes_stripe_min_length stripe_width ; set_db add_stripes_stacked_via_top_layer AP ; set_db add_stripes_stacked_via_bottom_layer M1 ; set_db add_stripes_via_using_exact_crossover_size false ; set_db add_stripes_split_vias false ; set_db add_stripes_orthogonal_only true ; set_db add_stripes_allow_jog { padcore_ring  block_ring } ; set_db add_stripes_skip_via_on_pin {  standardcell } ; set_db add_stripes_skip_via_on_wire_shape {  noshape   }
set x1 [expr {$prev_end + $distance_sram_macros}]
set y1 [expr {$y_margin + $swb_router_height  + $resource_height * 0 + $y_length * 2}]
set macro_width [get_db inst:cell_0_1_inst/resource_1_inst/sram_inst/sram_256x64.sram_macro_1 .bbox.width]
set x2 [expr {$x1 + $macro_width}]
set y2 [expr {$y1 + $resource_height * 6}]
set prev_end [expr {$x2}]
set area_stripe [list \
    $x1 $y1 \
    $x2 $y1 \
    $x2 $y2 \
    $x1 $y2]
add_stripes -nets {VDD VSS} -layer M8 -direction vertical -width 1.8 -spacing 1.8 -number_of_sets 3 -area $area_stripe -start_from left -switch_layer_over_obs false -max_same_layer_jog_length 2 -pad_core_ring_top_layer_limit AP -pad_core_ring_bottom_layer_limit M1 -block_ring_top_layer_limit AP -block_ring_bottom_layer_limit M1 -use_wire_group 0 -snap_wire_center_to_grid none

#stripes to macros in cell row 2, col 2, slot 1

#vertical to macro num 0
set_db add_stripes_ignore_block_check false ; set_db add_stripes_break_at {  block_ring  outside_ringmacro  } ; set_db add_stripes_route_over_rows_only false ; set_db add_stripes_rows_without_stripes_only false ; set_db add_stripes_extend_to_closest_target none ; set_db add_stripes_stop_at_last_wire_for_area true ; set_db add_stripes_partial_set_through_domain false ; set_db add_stripes_ignore_non_default_domains false ; set_db add_stripes_trim_antenna_back_to_shape block_ring ; set_db add_stripes_spacing_type edge_to_edge ; set_db add_stripes_spacing_from_block 0 ; set_db add_stripes_stripe_min_length stripe_width ; set_db add_stripes_stacked_via_top_layer AP ; set_db add_stripes_stacked_via_bottom_layer M1 ; set_db add_stripes_via_using_exact_crossover_size false ; set_db add_stripes_split_vias false ; set_db add_stripes_orthogonal_only true ; set_db add_stripes_allow_jog { padcore_ring  block_ring } ; set_db add_stripes_skip_via_on_pin {  standardcell } ; set_db add_stripes_skip_via_on_wire_shape {  noshape   }
set x1 [expr {$x_margin + $seq_width + $x_sram_macro + $x_length * 2}]
set y1 [expr {$y_margin + $swb_router_height  + $resource_height * 0 + $y_length * 2}]
set macro_width [get_db inst:cell_0_2_inst/resource_1_inst/sram_inst/sram_256x64.sram_macro_0 .bbox.width]
set x2 [expr {$x1 + $macro_width}]
set y2 [expr {$y1 + $resource_height * 6}]
set prev_end [expr {$x2}]
set area_stripe [list \
    $x1 $y1 \
    $x2 $y1 \
    $x2 $y2 \
    $x1 $y2]
add_stripes -nets {VDD VSS} -layer M8 -direction vertical -width 1.8 -spacing 1.8 -number_of_sets 3 -area $area_stripe -start_from left -switch_layer_over_obs false -max_same_layer_jog_length 2 -pad_core_ring_top_layer_limit AP -pad_core_ring_bottom_layer_limit M1 -block_ring_top_layer_limit AP -block_ring_bottom_layer_limit M1 -use_wire_group 0 -snap_wire_center_to_grid none

#vertical stripe between macro 1 and 2
set_db add_stripes_ignore_block_check false ; set_db add_stripes_break_at {  block_ring  outside_ringmacro  } ; set_db add_stripes_route_over_rows_only false ; set_db add_stripes_rows_without_stripes_only false ; set_db add_stripes_extend_to_closest_target none ; set_db add_stripes_stop_at_last_wire_for_area true ; set_db add_stripes_partial_set_through_domain false ; set_db add_stripes_ignore_non_default_domains false ; set_db add_stripes_trim_antenna_back_to_shape block_ring ; set_db add_stripes_spacing_type edge_to_edge ; set_db add_stripes_spacing_from_block 0 ; set_db add_stripes_stripe_min_length stripe_width ; set_db add_stripes_stacked_via_top_layer AP ; set_db add_stripes_stacked_via_bottom_layer M1 ; set_db add_stripes_via_using_exact_crossover_size false ; set_db add_stripes_split_vias false ; set_db add_stripes_orthogonal_only true ; set_db add_stripes_allow_jog { padcore_ring  block_ring } ; set_db add_stripes_skip_via_on_pin {  standardcell } ; set_db add_stripes_skip_via_on_wire_shape {  noshape   }
set x1 [expr {$prev_end}]
set y1 [expr {$y_margin + $swb_router_height  + $resource_height * 0 + $y_length * 2}]
set x2 [expr {$x1 + $distance_sram_macros}]
set y2 [expr {$y1 + $resource_height * 6}]
set area_stripe [list \
    $x1 $y1 \
    $x2 $y1 \
    $x2 $y2 \
    $x1 $y2]
add_stripes -nets {VDD VSS} -layer M8 -direction vertical -width 1.8 -spacing 1.8 -number_of_sets 1 -area $area_stripe -start_from left -start_offset [expr {$distance_sram_macros/2}] -switch_layer_over_obs false -max_same_layer_jog_length 2 -pad_core_ring_top_layer_limit AP -pad_core_ring_bottom_layer_limit M1 -block_ring_top_layer_limit AP -block_ring_bottom_layer_limit M1 -use_wire_group 0 -snap_wire_center_to_grid none

#vertical to macro num 1
set_db add_stripes_ignore_block_check false ; set_db add_stripes_break_at {  block_ring  outside_ringmacro  } ; set_db add_stripes_route_over_rows_only false ; set_db add_stripes_rows_without_stripes_only false ; set_db add_stripes_extend_to_closest_target none ; set_db add_stripes_stop_at_last_wire_for_area true ; set_db add_stripes_partial_set_through_domain false ; set_db add_stripes_ignore_non_default_domains false ; set_db add_stripes_trim_antenna_back_to_shape block_ring ; set_db add_stripes_spacing_type edge_to_edge ; set_db add_stripes_spacing_from_block 0 ; set_db add_stripes_stripe_min_length stripe_width ; set_db add_stripes_stacked_via_top_layer AP ; set_db add_stripes_stacked_via_bottom_layer M1 ; set_db add_stripes_via_using_exact_crossover_size false ; set_db add_stripes_split_vias false ; set_db add_stripes_orthogonal_only true ; set_db add_stripes_allow_jog { padcore_ring  block_ring } ; set_db add_stripes_skip_via_on_pin {  standardcell } ; set_db add_stripes_skip_via_on_wire_shape {  noshape   }
set x1 [expr {$prev_end + $distance_sram_macros}]
set y1 [expr {$y_margin + $swb_router_height  + $resource_height * 0 + $y_length * 2}]
set macro_width [get_db inst:cell_0_2_inst/resource_1_inst/sram_inst/sram_256x64.sram_macro_1 .bbox.width]
set x2 [expr {$x1 + $macro_width}]
set y2 [expr {$y1 + $resource_height * 6}]
set prev_end [expr {$x2}]
set area_stripe [list \
    $x1 $y1 \
    $x2 $y1 \
    $x2 $y2 \
    $x1 $y2]
add_stripes -nets {VDD VSS} -layer M8 -direction vertical -width 1.8 -spacing 1.8 -number_of_sets 3 -area $area_stripe -start_from left -switch_layer_over_obs false -max_same_layer_jog_length 2 -pad_core_ring_top_layer_limit AP -pad_core_ring_bottom_layer_limit M1 -block_ring_top_layer_limit AP -block_ring_bottom_layer_limit M1 -use_wire_group 0 -snap_wire_center_to_grid none

#stripes to macros in cell row 0, col 0, slot 1

#vertical to macro num 0
set_db add_stripes_ignore_block_check false ; set_db add_stripes_break_at {  block_ring  outside_ringmacro  } ; set_db add_stripes_route_over_rows_only false ; set_db add_stripes_rows_without_stripes_only false ; set_db add_stripes_extend_to_closest_target none ; set_db add_stripes_stop_at_last_wire_for_area true ; set_db add_stripes_partial_set_through_domain false ; set_db add_stripes_ignore_non_default_domains false ; set_db add_stripes_trim_antenna_back_to_shape block_ring ; set_db add_stripes_spacing_type edge_to_edge ; set_db add_stripes_spacing_from_block 0 ; set_db add_stripes_stripe_min_length stripe_width ; set_db add_stripes_stacked_via_top_layer AP ; set_db add_stripes_stacked_via_bottom_layer M1 ; set_db add_stripes_via_using_exact_crossover_size false ; set_db add_stripes_split_vias false ; set_db add_stripes_orthogonal_only true ; set_db add_stripes_allow_jog { padcore_ring  block_ring } ; set_db add_stripes_skip_via_on_pin {  standardcell } ; set_db add_stripes_skip_via_on_wire_shape {  noshape   }
set x1 [expr {$x_margin + $seq_width + $x_sram_macro + $x_length * 0}]
set y1 [expr {$y_margin + $swb_router_height  + $resource_height * 0 + $y_length * 0}]
set macro_width [get_db inst:cell_2_0_inst/resource_1_inst/sram_inst/sram_256x64.sram_macro_0 .bbox.width]
set x2 [expr {$x1 + $macro_width}]
set y2 [expr {$y1 + $resource_height * 6}]
set prev_end [expr {$x2}]
set area_stripe [list \
    $x1 $y1 \
    $x2 $y1 \
    $x2 $y2 \
    $x1 $y2]
add_stripes -nets {VDD VSS} -layer M8 -direction vertical -width 1.8 -spacing 1.8 -number_of_sets 3 -area $area_stripe -start_from left -switch_layer_over_obs false -max_same_layer_jog_length 2 -pad_core_ring_top_layer_limit AP -pad_core_ring_bottom_layer_limit M1 -block_ring_top_layer_limit AP -block_ring_bottom_layer_limit M1 -use_wire_group 0 -snap_wire_center_to_grid none

#vertical stripe between macro 1 and 2
set_db add_stripes_ignore_block_check false ; set_db add_stripes_break_at {  block_ring  outside_ringmacro  } ; set_db add_stripes_route_over_rows_only false ; set_db add_stripes_rows_without_stripes_only false ; set_db add_stripes_extend_to_closest_target none ; set_db add_stripes_stop_at_last_wire_for_area true ; set_db add_stripes_partial_set_through_domain false ; set_db add_stripes_ignore_non_default_domains false ; set_db add_stripes_trim_antenna_back_to_shape block_ring ; set_db add_stripes_spacing_type edge_to_edge ; set_db add_stripes_spacing_from_block 0 ; set_db add_stripes_stripe_min_length stripe_width ; set_db add_stripes_stacked_via_top_layer AP ; set_db add_stripes_stacked_via_bottom_layer M1 ; set_db add_stripes_via_using_exact_crossover_size false ; set_db add_stripes_split_vias false ; set_db add_stripes_orthogonal_only true ; set_db add_stripes_allow_jog { padcore_ring  block_ring } ; set_db add_stripes_skip_via_on_pin {  standardcell } ; set_db add_stripes_skip_via_on_wire_shape {  noshape   }
set x1 [expr {$prev_end}]
set y1 [expr {$y_margin + $swb_router_height  + $resource_height * 0 + $y_length * 0}]
set x2 [expr {$x1 + $distance_sram_macros}]
set y2 [expr {$y1 + $resource_height * 6}]
set area_stripe [list \
    $x1 $y1 \
    $x2 $y1 \
    $x2 $y2 \
    $x1 $y2]
add_stripes -nets {VDD VSS} -layer M8 -direction vertical -width 1.8 -spacing 1.8 -number_of_sets 1 -area $area_stripe -start_from left -start_offset [expr {$distance_sram_macros/2}] -switch_layer_over_obs false -max_same_layer_jog_length 2 -pad_core_ring_top_layer_limit AP -pad_core_ring_bottom_layer_limit M1 -block_ring_top_layer_limit AP -block_ring_bottom_layer_limit M1 -use_wire_group 0 -snap_wire_center_to_grid none

#vertical to macro num 1
set_db add_stripes_ignore_block_check false ; set_db add_stripes_break_at {  block_ring  outside_ringmacro  } ; set_db add_stripes_route_over_rows_only false ; set_db add_stripes_rows_without_stripes_only false ; set_db add_stripes_extend_to_closest_target none ; set_db add_stripes_stop_at_last_wire_for_area true ; set_db add_stripes_partial_set_through_domain false ; set_db add_stripes_ignore_non_default_domains false ; set_db add_stripes_trim_antenna_back_to_shape block_ring ; set_db add_stripes_spacing_type edge_to_edge ; set_db add_stripes_spacing_from_block 0 ; set_db add_stripes_stripe_min_length stripe_width ; set_db add_stripes_stacked_via_top_layer AP ; set_db add_stripes_stacked_via_bottom_layer M1 ; set_db add_stripes_via_using_exact_crossover_size false ; set_db add_stripes_split_vias false ; set_db add_stripes_orthogonal_only true ; set_db add_stripes_allow_jog { padcore_ring  block_ring } ; set_db add_stripes_skip_via_on_pin {  standardcell } ; set_db add_stripes_skip_via_on_wire_shape {  noshape   }
set x1 [expr {$prev_end + $distance_sram_macros}]
set y1 [expr {$y_margin + $swb_router_height  + $resource_height * 0 + $y_length * 0}]
set macro_width [get_db inst:cell_2_0_inst/resource_1_inst/sram_inst/sram_256x64.sram_macro_1 .bbox.width]
set x2 [expr {$x1 + $macro_width}]
set y2 [expr {$y1 + $resource_height * 6}]
set prev_end [expr {$x2}]
set area_stripe [list \
    $x1 $y1 \
    $x2 $y1 \
    $x2 $y2 \
    $x1 $y2]
add_stripes -nets {VDD VSS} -layer M8 -direction vertical -width 1.8 -spacing 1.8 -number_of_sets 3 -area $area_stripe -start_from left -switch_layer_over_obs false -max_same_layer_jog_length 2 -pad_core_ring_top_layer_limit AP -pad_core_ring_bottom_layer_limit M1 -block_ring_top_layer_limit AP -block_ring_bottom_layer_limit M1 -use_wire_group 0 -snap_wire_center_to_grid none

#stripes to macros in cell row 0, col 1, slot 1

#vertical to macro num 0
set_db add_stripes_ignore_block_check false ; set_db add_stripes_break_at {  block_ring  outside_ringmacro  } ; set_db add_stripes_route_over_rows_only false ; set_db add_stripes_rows_without_stripes_only false ; set_db add_stripes_extend_to_closest_target none ; set_db add_stripes_stop_at_last_wire_for_area true ; set_db add_stripes_partial_set_through_domain false ; set_db add_stripes_ignore_non_default_domains false ; set_db add_stripes_trim_antenna_back_to_shape block_ring ; set_db add_stripes_spacing_type edge_to_edge ; set_db add_stripes_spacing_from_block 0 ; set_db add_stripes_stripe_min_length stripe_width ; set_db add_stripes_stacked_via_top_layer AP ; set_db add_stripes_stacked_via_bottom_layer M1 ; set_db add_stripes_via_using_exact_crossover_size false ; set_db add_stripes_split_vias false ; set_db add_stripes_orthogonal_only true ; set_db add_stripes_allow_jog { padcore_ring  block_ring } ; set_db add_stripes_skip_via_on_pin {  standardcell } ; set_db add_stripes_skip_via_on_wire_shape {  noshape   }
set x1 [expr {$x_margin + $seq_width + $x_sram_macro + $x_length * 1}]
set y1 [expr {$y_margin + $swb_router_height  + $resource_height * 0 + $y_length * 0}]
set macro_width [get_db inst:cell_2_1_inst/resource_1_inst/sram_inst/sram_256x64.sram_macro_0 .bbox.width]
set x2 [expr {$x1 + $macro_width}]
set y2 [expr {$y1 + $resource_height * 6}]
set prev_end [expr {$x2}]
set area_stripe [list \
    $x1 $y1 \
    $x2 $y1 \
    $x2 $y2 \
    $x1 $y2]
add_stripes -nets {VDD VSS} -layer M8 -direction vertical -width 1.8 -spacing 1.8 -number_of_sets 3 -area $area_stripe -start_from left -switch_layer_over_obs false -max_same_layer_jog_length 2 -pad_core_ring_top_layer_limit AP -pad_core_ring_bottom_layer_limit M1 -block_ring_top_layer_limit AP -block_ring_bottom_layer_limit M1 -use_wire_group 0 -snap_wire_center_to_grid none

#vertical stripe between macro 1 and 2
set_db add_stripes_ignore_block_check false ; set_db add_stripes_break_at {  block_ring  outside_ringmacro  } ; set_db add_stripes_route_over_rows_only false ; set_db add_stripes_rows_without_stripes_only false ; set_db add_stripes_extend_to_closest_target none ; set_db add_stripes_stop_at_last_wire_for_area true ; set_db add_stripes_partial_set_through_domain false ; set_db add_stripes_ignore_non_default_domains false ; set_db add_stripes_trim_antenna_back_to_shape block_ring ; set_db add_stripes_spacing_type edge_to_edge ; set_db add_stripes_spacing_from_block 0 ; set_db add_stripes_stripe_min_length stripe_width ; set_db add_stripes_stacked_via_top_layer AP ; set_db add_stripes_stacked_via_bottom_layer M1 ; set_db add_stripes_via_using_exact_crossover_size false ; set_db add_stripes_split_vias false ; set_db add_stripes_orthogonal_only true ; set_db add_stripes_allow_jog { padcore_ring  block_ring } ; set_db add_stripes_skip_via_on_pin {  standardcell } ; set_db add_stripes_skip_via_on_wire_shape {  noshape   }
set x1 [expr {$prev_end}]
set y1 [expr {$y_margin + $swb_router_height  + $resource_height * 0 + $y_length * 0}]
set x2 [expr {$x1 + $distance_sram_macros}]
set y2 [expr {$y1 + $resource_height * 6}]
set area_stripe [list \
    $x1 $y1 \
    $x2 $y1 \
    $x2 $y2 \
    $x1 $y2]
add_stripes -nets {VDD VSS} -layer M8 -direction vertical -width 1.8 -spacing 1.8 -number_of_sets 1 -area $area_stripe -start_from left -start_offset [expr {$distance_sram_macros/2}] -switch_layer_over_obs false -max_same_layer_jog_length 2 -pad_core_ring_top_layer_limit AP -pad_core_ring_bottom_layer_limit M1 -block_ring_top_layer_limit AP -block_ring_bottom_layer_limit M1 -use_wire_group 0 -snap_wire_center_to_grid none

#vertical to macro num 1
set_db add_stripes_ignore_block_check false ; set_db add_stripes_break_at {  block_ring  outside_ringmacro  } ; set_db add_stripes_route_over_rows_only false ; set_db add_stripes_rows_without_stripes_only false ; set_db add_stripes_extend_to_closest_target none ; set_db add_stripes_stop_at_last_wire_for_area true ; set_db add_stripes_partial_set_through_domain false ; set_db add_stripes_ignore_non_default_domains false ; set_db add_stripes_trim_antenna_back_to_shape block_ring ; set_db add_stripes_spacing_type edge_to_edge ; set_db add_stripes_spacing_from_block 0 ; set_db add_stripes_stripe_min_length stripe_width ; set_db add_stripes_stacked_via_top_layer AP ; set_db add_stripes_stacked_via_bottom_layer M1 ; set_db add_stripes_via_using_exact_crossover_size false ; set_db add_stripes_split_vias false ; set_db add_stripes_orthogonal_only true ; set_db add_stripes_allow_jog { padcore_ring  block_ring } ; set_db add_stripes_skip_via_on_pin {  standardcell } ; set_db add_stripes_skip_via_on_wire_shape {  noshape   }
set x1 [expr {$prev_end + $distance_sram_macros}]
set y1 [expr {$y_margin + $swb_router_height  + $resource_height * 0 + $y_length * 0}]
set macro_width [get_db inst:cell_2_1_inst/resource_1_inst/sram_inst/sram_256x64.sram_macro_1 .bbox.width]
set x2 [expr {$x1 + $macro_width}]
set y2 [expr {$y1 + $resource_height * 6}]
set prev_end [expr {$x2}]
set area_stripe [list \
    $x1 $y1 \
    $x2 $y1 \
    $x2 $y2 \
    $x1 $y2]
add_stripes -nets {VDD VSS} -layer M8 -direction vertical -width 1.8 -spacing 1.8 -number_of_sets 3 -area $area_stripe -start_from left -switch_layer_over_obs false -max_same_layer_jog_length 2 -pad_core_ring_top_layer_limit AP -pad_core_ring_bottom_layer_limit M1 -block_ring_top_layer_limit AP -block_ring_bottom_layer_limit M1 -use_wire_group 0 -snap_wire_center_to_grid none

#stripes to macros in cell row 0, col 2, slot 1

#vertical to macro num 0
set_db add_stripes_ignore_block_check false ; set_db add_stripes_break_at {  block_ring  outside_ringmacro  } ; set_db add_stripes_route_over_rows_only false ; set_db add_stripes_rows_without_stripes_only false ; set_db add_stripes_extend_to_closest_target none ; set_db add_stripes_stop_at_last_wire_for_area true ; set_db add_stripes_partial_set_through_domain false ; set_db add_stripes_ignore_non_default_domains false ; set_db add_stripes_trim_antenna_back_to_shape block_ring ; set_db add_stripes_spacing_type edge_to_edge ; set_db add_stripes_spacing_from_block 0 ; set_db add_stripes_stripe_min_length stripe_width ; set_db add_stripes_stacked_via_top_layer AP ; set_db add_stripes_stacked_via_bottom_layer M1 ; set_db add_stripes_via_using_exact_crossover_size false ; set_db add_stripes_split_vias false ; set_db add_stripes_orthogonal_only true ; set_db add_stripes_allow_jog { padcore_ring  block_ring } ; set_db add_stripes_skip_via_on_pin {  standardcell } ; set_db add_stripes_skip_via_on_wire_shape {  noshape   }
set x1 [expr {$x_margin + $seq_width + $x_sram_macro + $x_length * 2}]
set y1 [expr {$y_margin + $swb_router_height  + $resource_height * 0 + $y_length * 0}]
set macro_width [get_db inst:cell_2_2_inst/resource_1_inst/sram_inst/sram_256x64.sram_macro_0 .bbox.width]
set x2 [expr {$x1 + $macro_width}]
set y2 [expr {$y1 + $resource_height * 6}]
set prev_end [expr {$x2}]
set area_stripe [list \
    $x1 $y1 \
    $x2 $y1 \
    $x2 $y2 \
    $x1 $y2]
add_stripes -nets {VDD VSS} -layer M8 -direction vertical -width 1.8 -spacing 1.8 -number_of_sets 3 -area $area_stripe -start_from left -switch_layer_over_obs false -max_same_layer_jog_length 2 -pad_core_ring_top_layer_limit AP -pad_core_ring_bottom_layer_limit M1 -block_ring_top_layer_limit AP -block_ring_bottom_layer_limit M1 -use_wire_group 0 -snap_wire_center_to_grid none

#vertical stripe between macro 1 and 2
set_db add_stripes_ignore_block_check false ; set_db add_stripes_break_at {  block_ring  outside_ringmacro  } ; set_db add_stripes_route_over_rows_only false ; set_db add_stripes_rows_without_stripes_only false ; set_db add_stripes_extend_to_closest_target none ; set_db add_stripes_stop_at_last_wire_for_area true ; set_db add_stripes_partial_set_through_domain false ; set_db add_stripes_ignore_non_default_domains false ; set_db add_stripes_trim_antenna_back_to_shape block_ring ; set_db add_stripes_spacing_type edge_to_edge ; set_db add_stripes_spacing_from_block 0 ; set_db add_stripes_stripe_min_length stripe_width ; set_db add_stripes_stacked_via_top_layer AP ; set_db add_stripes_stacked_via_bottom_layer M1 ; set_db add_stripes_via_using_exact_crossover_size false ; set_db add_stripes_split_vias false ; set_db add_stripes_orthogonal_only true ; set_db add_stripes_allow_jog { padcore_ring  block_ring } ; set_db add_stripes_skip_via_on_pin {  standardcell } ; set_db add_stripes_skip_via_on_wire_shape {  noshape   }
set x1 [expr {$prev_end}]
set y1 [expr {$y_margin + $swb_router_height  + $resource_height * 0 + $y_length * 0}]
set x2 [expr {$x1 + $distance_sram_macros}]
set y2 [expr {$y1 + $resource_height * 6}]
set area_stripe [list \
    $x1 $y1 \
    $x2 $y1 \
    $x2 $y2 \
    $x1 $y2]
add_stripes -nets {VDD VSS} -layer M8 -direction vertical -width 1.8 -spacing 1.8 -number_of_sets 1 -area $area_stripe -start_from left -start_offset [expr {$distance_sram_macros/2}] -switch_layer_over_obs false -max_same_layer_jog_length 2 -pad_core_ring_top_layer_limit AP -pad_core_ring_bottom_layer_limit M1 -block_ring_top_layer_limit AP -block_ring_bottom_layer_limit M1 -use_wire_group 0 -snap_wire_center_to_grid none

#vertical to macro num 1
set_db add_stripes_ignore_block_check false ; set_db add_stripes_break_at {  block_ring  outside_ringmacro  } ; set_db add_stripes_route_over_rows_only false ; set_db add_stripes_rows_without_stripes_only false ; set_db add_stripes_extend_to_closest_target none ; set_db add_stripes_stop_at_last_wire_for_area true ; set_db add_stripes_partial_set_through_domain false ; set_db add_stripes_ignore_non_default_domains false ; set_db add_stripes_trim_antenna_back_to_shape block_ring ; set_db add_stripes_spacing_type edge_to_edge ; set_db add_stripes_spacing_from_block 0 ; set_db add_stripes_stripe_min_length stripe_width ; set_db add_stripes_stacked_via_top_layer AP ; set_db add_stripes_stacked_via_bottom_layer M1 ; set_db add_stripes_via_using_exact_crossover_size false ; set_db add_stripes_split_vias false ; set_db add_stripes_orthogonal_only true ; set_db add_stripes_allow_jog { padcore_ring  block_ring } ; set_db add_stripes_skip_via_on_pin {  standardcell } ; set_db add_stripes_skip_via_on_wire_shape {  noshape   }
set x1 [expr {$prev_end + $distance_sram_macros}]
set y1 [expr {$y_margin + $swb_router_height  + $resource_height * 0 + $y_length * 0}]
set macro_width [get_db inst:cell_2_2_inst/resource_1_inst/sram_inst/sram_256x64.sram_macro_1 .bbox.width]
set x2 [expr {$x1 + $macro_width}]
set y2 [expr {$y1 + $resource_height * 6}]
set prev_end [expr {$x2}]
set area_stripe [list \
    $x1 $y1 \
    $x2 $y1 \
    $x2 $y2 \
    $x1 $y2]
add_stripes -nets {VDD VSS} -layer M8 -direction vertical -width 1.8 -spacing 1.8 -number_of_sets 3 -area $area_stripe -start_from left -switch_layer_over_obs false -max_same_layer_jog_length 2 -pad_core_ring_top_layer_limit AP -pad_core_ring_bottom_layer_limit M1 -block_ring_top_layer_limit AP -block_ring_bottom_layer_limit M1 -use_wire_group 0 -snap_wire_center_to_grid none



#stripes for partitions with NO macros
for {set i 0} {$i < $columns} {incr i} {
    for {set j 0} {$j < $rows} {incr j} {
        for {set k 0} {$k < 16} {incr k} {
            if { ($i == 0 && $j == 2) || ($i == 1 && $j == 2) || ($i == 2 && $j == 2) || ($i == 0 && $j == 0) || ($i == 1 && $j == 0) || ($i == 2 && $j == 0) } {
                if { $i == 0 && $j == 2 && ($k+1) != 1 && ($k+1) != 2 && ($k+1) != 3 && ($k+1) != 4 && ($k+1) != 5 && ($k+1) != 6 } {
                    set_db add_stripes_ignore_block_check false ; set_db add_stripes_break_at none ; set_db add_stripes_route_over_rows_only false ; set_db add_stripes_rows_without_stripes_only false ; set_db add_stripes_extend_to_closest_target none ; set_db add_stripes_stop_at_last_wire_for_area true ; set_db add_stripes_partial_set_through_domain false ; set_db add_stripes_ignore_non_default_domains false ; set_db add_stripes_trim_antenna_back_to_shape block_ring ; set_db add_stripes_spacing_type edge_to_edge ; set_db add_stripes_spacing_from_block 0 ; set_db add_stripes_stripe_min_length stripe_width ; set_db add_stripes_stacked_via_top_layer AP ; set_db add_stripes_stacked_via_bottom_layer M1 ; set_db add_stripes_via_using_exact_crossover_size false ; set_db add_stripes_split_vias false ; set_db add_stripes_orthogonal_only true ; set_db add_stripes_allow_jog { padcore_ring  block_ring } ; set_db add_stripes_skip_via_on_pin {  standardcell } ; set_db add_stripes_skip_via_on_wire_shape {  noshape   }
                    set x1 [expr {$x_length * $i + $x_margin + $seq_width + $resource_width/2}]
                    set y1 [expr {$y_length * $j + $y_margin + $swb_router_height + $resource_height * $k}]
                    set x2 [expr {$x1 + ($resource_width/2)*1}]
                    set y2 [expr {$y1 + $resource_height}]
                    set area_stripe [list \
                        $x1 $y1 \
                        $x2 $y1 \
                        $x2 $y2 \
                        $x1 $y2]
                    add_stripes -nets {VDD VSS} -layer M8 -direction vertical -width 1.8 -spacing 1.8 -number_of_sets 1 -area $area_stripe -start_from left -switch_layer_over_obs false -max_same_layer_jog_length 2 -pad_core_ring_top_layer_limit AP -pad_core_ring_bottom_layer_limit M1 -block_ring_top_layer_limit AP -block_ring_bottom_layer_limit M1 -use_wire_group 0 -snap_wire_center_to_grid none            
                }

                if { $i == 1 && $j == 2 && ($k+1) != 1 && ($k+1) != 2 && ($k+1) != 3 && ($k+1) != 4 && ($k+1) != 5 && ($k+1) != 6 } {
                    set_db add_stripes_ignore_block_check false ; set_db add_stripes_break_at none ; set_db add_stripes_route_over_rows_only false ; set_db add_stripes_rows_without_stripes_only false ; set_db add_stripes_extend_to_closest_target none ; set_db add_stripes_stop_at_last_wire_for_area true ; set_db add_stripes_partial_set_through_domain false ; set_db add_stripes_ignore_non_default_domains false ; set_db add_stripes_trim_antenna_back_to_shape block_ring ; set_db add_stripes_spacing_type edge_to_edge ; set_db add_stripes_spacing_from_block 0 ; set_db add_stripes_stripe_min_length stripe_width ; set_db add_stripes_stacked_via_top_layer AP ; set_db add_stripes_stacked_via_bottom_layer M1 ; set_db add_stripes_via_using_exact_crossover_size false ; set_db add_stripes_split_vias false ; set_db add_stripes_orthogonal_only true ; set_db add_stripes_allow_jog { padcore_ring  block_ring } ; set_db add_stripes_skip_via_on_pin {  standardcell } ; set_db add_stripes_skip_via_on_wire_shape {  noshape   }
                    set x1 [expr {$x_length * $i + $x_margin + $seq_width + $resource_width/2}]
                    set y1 [expr {$y_length * $j + $y_margin + $swb_router_height + $resource_height * $k}]
                    set x2 [expr {$x1 + ($resource_width/2)*1}]
                    set y2 [expr {$y1 + $resource_height}]
                    set area_stripe [list \
                        $x1 $y1 \
                        $x2 $y1 \
                        $x2 $y2 \
                        $x1 $y2]
                    add_stripes -nets {VDD VSS} -layer M8 -direction vertical -width 1.8 -spacing 1.8 -number_of_sets 1 -area $area_stripe -start_from left -switch_layer_over_obs false -max_same_layer_jog_length 2 -pad_core_ring_top_layer_limit AP -pad_core_ring_bottom_layer_limit M1 -block_ring_top_layer_limit AP -block_ring_bottom_layer_limit M1 -use_wire_group 0 -snap_wire_center_to_grid none            
                }

                if { $i == 2 && $j == 2 && ($k+1) != 1 && ($k+1) != 2 && ($k+1) != 3 && ($k+1) != 4 && ($k+1) != 5 && ($k+1) != 6 } {
                    set_db add_stripes_ignore_block_check false ; set_db add_stripes_break_at none ; set_db add_stripes_route_over_rows_only false ; set_db add_stripes_rows_without_stripes_only false ; set_db add_stripes_extend_to_closest_target none ; set_db add_stripes_stop_at_last_wire_for_area true ; set_db add_stripes_partial_set_through_domain false ; set_db add_stripes_ignore_non_default_domains false ; set_db add_stripes_trim_antenna_back_to_shape block_ring ; set_db add_stripes_spacing_type edge_to_edge ; set_db add_stripes_spacing_from_block 0 ; set_db add_stripes_stripe_min_length stripe_width ; set_db add_stripes_stacked_via_top_layer AP ; set_db add_stripes_stacked_via_bottom_layer M1 ; set_db add_stripes_via_using_exact_crossover_size false ; set_db add_stripes_split_vias false ; set_db add_stripes_orthogonal_only true ; set_db add_stripes_allow_jog { padcore_ring  block_ring } ; set_db add_stripes_skip_via_on_pin {  standardcell } ; set_db add_stripes_skip_via_on_wire_shape {  noshape   }
                    set x1 [expr {$x_length * $i + $x_margin + $seq_width + $resource_width/2}]
                    set y1 [expr {$y_length * $j + $y_margin + $swb_router_height + $resource_height * $k}]
                    set x2 [expr {$x1 + ($resource_width/2)*1}]
                    set y2 [expr {$y1 + $resource_height}]
                    set area_stripe [list \
                        $x1 $y1 \
                        $x2 $y1 \
                        $x2 $y2 \
                        $x1 $y2]
                    add_stripes -nets {VDD VSS} -layer M8 -direction vertical -width 1.8 -spacing 1.8 -number_of_sets 1 -area $area_stripe -start_from left -switch_layer_over_obs false -max_same_layer_jog_length 2 -pad_core_ring_top_layer_limit AP -pad_core_ring_bottom_layer_limit M1 -block_ring_top_layer_limit AP -block_ring_bottom_layer_limit M1 -use_wire_group 0 -snap_wire_center_to_grid none            
                }

                if { $i == 0 && $j == 0 && ($k+1) != 1 && ($k+1) != 2 && ($k+1) != 3 && ($k+1) != 4 && ($k+1) != 5 && ($k+1) != 6 } {
                    set_db add_stripes_ignore_block_check false ; set_db add_stripes_break_at none ; set_db add_stripes_route_over_rows_only false ; set_db add_stripes_rows_without_stripes_only false ; set_db add_stripes_extend_to_closest_target none ; set_db add_stripes_stop_at_last_wire_for_area true ; set_db add_stripes_partial_set_through_domain false ; set_db add_stripes_ignore_non_default_domains false ; set_db add_stripes_trim_antenna_back_to_shape block_ring ; set_db add_stripes_spacing_type edge_to_edge ; set_db add_stripes_spacing_from_block 0 ; set_db add_stripes_stripe_min_length stripe_width ; set_db add_stripes_stacked_via_top_layer AP ; set_db add_stripes_stacked_via_bottom_layer M1 ; set_db add_stripes_via_using_exact_crossover_size false ; set_db add_stripes_split_vias false ; set_db add_stripes_orthogonal_only true ; set_db add_stripes_allow_jog { padcore_ring  block_ring } ; set_db add_stripes_skip_via_on_pin {  standardcell } ; set_db add_stripes_skip_via_on_wire_shape {  noshape   }
                    set x1 [expr {$x_length * $i + $x_margin + $seq_width + $resource_width/2}]
                    set y1 [expr {$y_length * $j + $y_margin + $swb_router_height + $resource_height * $k}]
                    set x2 [expr {$x1 + ($resource_width/2)*1}]
                    set y2 [expr {$y1 + $resource_height}]
                    set area_stripe [list \
                        $x1 $y1 \
                        $x2 $y1 \
                        $x2 $y2 \
                        $x1 $y2]
                    add_stripes -nets {VDD VSS} -layer M8 -direction vertical -width 1.8 -spacing 1.8 -number_of_sets 1 -area $area_stripe -start_from left -switch_layer_over_obs false -max_same_layer_jog_length 2 -pad_core_ring_top_layer_limit AP -pad_core_ring_bottom_layer_limit M1 -block_ring_top_layer_limit AP -block_ring_bottom_layer_limit M1 -use_wire_group 0 -snap_wire_center_to_grid none            
                }

                if { $i == 1 && $j == 0 && ($k+1) != 1 && ($k+1) != 2 && ($k+1) != 3 && ($k+1) != 4 && ($k+1) != 5 && ($k+1) != 6 } {
                    set_db add_stripes_ignore_block_check false ; set_db add_stripes_break_at none ; set_db add_stripes_route_over_rows_only false ; set_db add_stripes_rows_without_stripes_only false ; set_db add_stripes_extend_to_closest_target none ; set_db add_stripes_stop_at_last_wire_for_area true ; set_db add_stripes_partial_set_through_domain false ; set_db add_stripes_ignore_non_default_domains false ; set_db add_stripes_trim_antenna_back_to_shape block_ring ; set_db add_stripes_spacing_type edge_to_edge ; set_db add_stripes_spacing_from_block 0 ; set_db add_stripes_stripe_min_length stripe_width ; set_db add_stripes_stacked_via_top_layer AP ; set_db add_stripes_stacked_via_bottom_layer M1 ; set_db add_stripes_via_using_exact_crossover_size false ; set_db add_stripes_split_vias false ; set_db add_stripes_orthogonal_only true ; set_db add_stripes_allow_jog { padcore_ring  block_ring } ; set_db add_stripes_skip_via_on_pin {  standardcell } ; set_db add_stripes_skip_via_on_wire_shape {  noshape   }
                    set x1 [expr {$x_length * $i + $x_margin + $seq_width + $resource_width/2}]
                    set y1 [expr {$y_length * $j + $y_margin + $swb_router_height + $resource_height * $k}]
                    set x2 [expr {$x1 + ($resource_width/2)*1}]
                    set y2 [expr {$y1 + $resource_height}]
                    set area_stripe [list \
                        $x1 $y1 \
                        $x2 $y1 \
                        $x2 $y2 \
                        $x1 $y2]
                    add_stripes -nets {VDD VSS} -layer M8 -direction vertical -width 1.8 -spacing 1.8 -number_of_sets 1 -area $area_stripe -start_from left -switch_layer_over_obs false -max_same_layer_jog_length 2 -pad_core_ring_top_layer_limit AP -pad_core_ring_bottom_layer_limit M1 -block_ring_top_layer_limit AP -block_ring_bottom_layer_limit M1 -use_wire_group 0 -snap_wire_center_to_grid none            
                }

                if { $i == 2 && $j == 0 && ($k+1) != 1 && ($k+1) != 2 && ($k+1) != 3 && ($k+1) != 4 && ($k+1) != 5 && ($k+1) != 6 } {
                    set_db add_stripes_ignore_block_check false ; set_db add_stripes_break_at none ; set_db add_stripes_route_over_rows_only false ; set_db add_stripes_rows_without_stripes_only false ; set_db add_stripes_extend_to_closest_target none ; set_db add_stripes_stop_at_last_wire_for_area true ; set_db add_stripes_partial_set_through_domain false ; set_db add_stripes_ignore_non_default_domains false ; set_db add_stripes_trim_antenna_back_to_shape block_ring ; set_db add_stripes_spacing_type edge_to_edge ; set_db add_stripes_spacing_from_block 0 ; set_db add_stripes_stripe_min_length stripe_width ; set_db add_stripes_stacked_via_top_layer AP ; set_db add_stripes_stacked_via_bottom_layer M1 ; set_db add_stripes_via_using_exact_crossover_size false ; set_db add_stripes_split_vias false ; set_db add_stripes_orthogonal_only true ; set_db add_stripes_allow_jog { padcore_ring  block_ring } ; set_db add_stripes_skip_via_on_pin {  standardcell } ; set_db add_stripes_skip_via_on_wire_shape {  noshape   }
                    set x1 [expr {$x_length * $i + $x_margin + $seq_width + $resource_width/2}]
                    set y1 [expr {$y_length * $j + $y_margin + $swb_router_height + $resource_height * $k}]
                    set x2 [expr {$x1 + ($resource_width/2)*1}]
                    set y2 [expr {$y1 + $resource_height}]
                    set area_stripe [list \
                        $x1 $y1 \
                        $x2 $y1 \
                        $x2 $y2 \
                        $x1 $y2]
                    add_stripes -nets {VDD VSS} -layer M8 -direction vertical -width 1.8 -spacing 1.8 -number_of_sets 1 -area $area_stripe -start_from left -switch_layer_over_obs false -max_same_layer_jog_length 2 -pad_core_ring_top_layer_limit AP -pad_core_ring_bottom_layer_limit M1 -block_ring_top_layer_limit AP -block_ring_bottom_layer_limit M1 -use_wire_group 0 -snap_wire_center_to_grid none            
                }

            } else {
                set_db add_stripes_ignore_block_check false ; set_db add_stripes_break_at none ; set_db add_stripes_route_over_rows_only false ; set_db add_stripes_rows_without_stripes_only false ; set_db add_stripes_extend_to_closest_target none ; set_db add_stripes_stop_at_last_wire_for_area true ; set_db add_stripes_partial_set_through_domain false ; set_db add_stripes_ignore_non_default_domains false ; set_db add_stripes_trim_antenna_back_to_shape block_ring ; set_db add_stripes_spacing_type edge_to_edge ; set_db add_stripes_spacing_from_block 0 ; set_db add_stripes_stripe_min_length stripe_width ; set_db add_stripes_stacked_via_top_layer AP ; set_db add_stripes_stacked_via_bottom_layer M1 ; set_db add_stripes_via_using_exact_crossover_size false ; set_db add_stripes_split_vias false ; set_db add_stripes_orthogonal_only true ; set_db add_stripes_allow_jog { padcore_ring  block_ring } ; set_db add_stripes_skip_via_on_pin {  standardcell } ; set_db add_stripes_skip_via_on_wire_shape {  noshape   }
                set x1 [expr {$x_length * $i + $x_margin + $seq_width + $resource_width/2}]
                    set y1 [expr {$y_length * $j + $y_margin + $swb_router_height + $resource_height * $k}]
                    set x2 [expr {$x1 + ($resource_width/2)*1}]
                    set y2 [expr {$y1 + $resource_height}]
                set area_stripe [list \
                    $x1 $y1 \
                    $x2 $y1 \
                    $x2 $y2 \
                    $x1 $y2]
                add_stripes -nets {VDD VSS} -layer M8 -direction vertical -width 1.8 -spacing 1.8 -number_of_sets 1 -area $area_stripe -start_from left -switch_layer_over_obs false -max_same_layer_jog_length 2 -pad_core_ring_top_layer_limit AP -pad_core_ring_bottom_layer_limit M1 -block_ring_top_layer_limit AP -block_ring_bottom_layer_limit M1 -use_wire_group 0 -snap_wire_center_to_grid none                         
            }
        }
    }
}



#vertical stripe in swb_router
set_db add_stripes_ignore_block_check false ; set_db add_stripes_break_at none ; set_db add_stripes_route_over_rows_only false ; set_db add_stripes_rows_without_stripes_only false ; set_db add_stripes_extend_to_closest_target none ; set_db add_stripes_stop_at_last_wire_for_area true ; set_db add_stripes_partial_set_through_domain false ; set_db add_stripes_ignore_non_default_domains false ; set_db add_stripes_trim_antenna_back_to_shape block_ring ; set_db add_stripes_spacing_type edge_to_edge ; set_db add_stripes_spacing_from_block 0 ; set_db add_stripes_stripe_min_length stripe_width ; set_db add_stripes_stacked_via_top_layer AP ; set_db add_stripes_stacked_via_bottom_layer M1 ; set_db add_stripes_via_using_exact_crossover_size false ; set_db add_stripes_split_vias false ; set_db add_stripes_orthogonal_only true ; set_db add_stripes_allow_jog { padcore_ring  block_ring } ; set_db add_stripes_skip_via_on_pin {  standardcell } ; set_db add_stripes_skip_via_on_wire_shape {  noshape   }

for {set i 0} {$i < $columns} {incr i} {
    for {set j 0} {$j < $rows} {incr j} {
        set x1 [expr {$x_margin + $x_length * $i + $seq_width + $resource_width + $swb_router_width/2}]
        set y1 [expr {$y_margin + $y_length * $j}]
        set x2 [expr {$x1 + $x_offset * 2}]
        set y2 [expr {$y1 + $swb_router_height + $seq_height}]
        set area_stripe [list \
            $x1 $y1 \
            $x2 $y1 \
            $x2 $y2 \
            $x1 $y2]
        add_stripes -nets {VDD VSS} -layer M8 -direction vertical -width 1.8 -spacing 1.8 -number_of_sets 1 -area $area_stripe -start_from left -switch_layer_over_obs false -max_same_layer_jog_length 2 -pad_core_ring_top_layer_limit AP -pad_core_ring_bottom_layer_limit M1 -block_ring_top_layer_limit AP -block_ring_bottom_layer_limit M1 -use_wire_group 0 -snap_wire_center_to_grid none            
    }
}



#vertical stripe in swb_router
set_db add_stripes_ignore_block_check false ; set_db add_stripes_break_at none ; set_db add_stripes_route_over_rows_only false ; set_db add_stripes_rows_without_stripes_only false ; set_db add_stripes_extend_to_closest_target none ; set_db add_stripes_stop_at_last_wire_for_area true ; set_db add_stripes_partial_set_through_domain false ; set_db add_stripes_ignore_non_default_domains false ; set_db add_stripes_trim_antenna_back_to_shape block_ring ; set_db add_stripes_spacing_type edge_to_edge ; set_db add_stripes_spacing_from_block 0 ; set_db add_stripes_stripe_min_length stripe_width ; set_db add_stripes_stacked_via_top_layer AP ; set_db add_stripes_stacked_via_bottom_layer M1 ; set_db add_stripes_via_using_exact_crossover_size false ; set_db add_stripes_split_vias false ; set_db add_stripes_orthogonal_only true ; set_db add_stripes_allow_jog { padcore_ring  block_ring } ; set_db add_stripes_skip_via_on_pin {  standardcell } ; set_db add_stripes_skip_via_on_wire_shape {  noshape   }

for {set i 0} {$i < $columns} {incr i} {
    for {set j 0} {$j < $rows} {incr j} {
        set x1 [expr {$x_margin + $x_length * $i + $seq_width/2}]
        set y1 [expr {$y_margin + $swb_router_height + $y_length * $j}]
        set x2 [expr {$x1 + $x_offset * 2}]
        set y2 [expr {$y1 + $seq_height}]
        set area_stripe [list \
            $x1 $y1 \
            $x2 $y1 \
            $x2 $y2 \
            $x1 $y2]
        add_stripes -nets {VDD VSS} -layer M8 -direction vertical -width 1.8 -spacing 1.8 -number_of_sets 1 -area $area_stripe -start_from left -switch_layer_over_obs false -max_same_layer_jog_length 2 -pad_core_ring_top_layer_limit AP -pad_core_ring_bottom_layer_limit M1 -block_ring_top_layer_limit AP -block_ring_bottom_layer_limit M1 -use_wire_group 0 -snap_wire_center_to_grid none            
    }
}



#stripes among rings
set_db add_stripes_ignore_block_check true ; set_db add_stripes_break_at none ; set_db add_stripes_route_over_rows_only false ; set_db add_stripes_rows_without_stripes_only false ; set_db add_stripes_extend_to_closest_target none ; set_db add_stripes_stop_at_last_wire_for_area true ; set_db add_stripes_partial_set_through_domain false ; set_db add_stripes_ignore_non_default_domains false ; set_db add_stripes_trim_antenna_back_to_shape block_ring ; set_db add_stripes_spacing_type edge_to_edge ; set_db add_stripes_spacing_from_block 0 ; set_db add_stripes_stripe_min_length stripe_width ; set_db add_stripes_stacked_via_top_layer AP ; set_db add_stripes_stacked_via_bottom_layer M1 ; set_db add_stripes_via_using_exact_crossover_size false ; set_db add_stripes_split_vias false ; set_db add_stripes_orthogonal_only true ; set_db add_stripes_allow_jog { padcore_ring  block_ring } ; set_db add_stripes_skip_via_on_pin {  standardcell } ; set_db add_stripes_skip_via_on_wire_shape {  noshape   }

for {set i 0} {$i < $columns} {incr i} {
    for {set j 0} {$j < $rows} {incr j} {
        for {set k 0} {$k < 16} {incr k} {
            #between sequencer and resources
            set x1 [expr {$x_margin + $x_length * $i + $seq_width - $x_offset}]
            set y1 [expr {$y_margin + $y_length * $j + $swb_router_height + $y_offset + $k * $resource_height}]
            set x2 [expr {$x1 + $x_offset * 2}]
            set y2 [expr {$y1 - $y_offset * 2 + $resource_height}]
            set area_stripe [list \
                $x1 $y1 \
                $x2 $y1 \
                $x2 $y2 \
                $x1 $y2]
            add_stripes -nets {VDD VSS} -layer M7 -direction horizontal -width 1.8 -spacing 1.8 -set_to_set_distance 10 -area $area_stripe -start_from bottom -switch_layer_over_obs false -merge_stripes_value 10 -max_same_layer_jog_length 2 -pad_core_ring_top_layer_limit AP -pad_core_ring_bottom_layer_limit M1 -block_ring_top_layer_limit AP -block_ring_bottom_layer_limit M1 -use_wire_group 0 -snap_wire_center_to_grid none
            #between swb and resources
            set x1 [expr {$x_margin + $x_length * $i + $seq_width + $resource_width - $x_offset}]
            set y1 [expr {$y_margin + $y_length * $j + $swb_router_height + $y_offset + $k * $resource_height}]
            set x2 [expr {$x1 + $x_offset * 2}]
            set y2 [expr {$y1 - $y_offset * 2 + $resource_height}]
            set area_stripe [list \
                $x1 $y1 \
                $x2 $y1 \
                $x2 $y2 \
                $x1 $y2]
            add_stripes -nets {VDD VSS} -layer M7 -direction horizontal -width 1.8 -spacing 1.8 -set_to_set_distance 10 -area $area_stripe -start_from bottom -switch_layer_over_obs false -merge_stripes_value 10 -max_same_layer_jog_length 2 -pad_core_ring_top_layer_limit AP -pad_core_ring_bottom_layer_limit M1 -block_ring_top_layer_limit AP -block_ring_bottom_layer_limit M1 -use_wire_group 0 -snap_wire_center_to_grid none
        }

        #vertical between seq and swb
        set x1 [expr {$x_margin + $x_length * $i + $x_offset}]
        set y1 [expr {$y_margin + $y_length * $j + $swb_router_height - $y_offset}]
        set x2 [expr {$x1 + $seq_width - $x_offset * 2}]
        set y2 [expr {$y1 + $y_offset * 2}]
        set area_stripe [list \
            $x1 $y1 \
            $x2 $y1 \
            $x2 $y2 \
            $x1 $y2]
        add_stripes -nets {VDD VSS} -layer M8 -direction vertical -width 1.8 -spacing 1.8 -set_to_set_distance 10 -area $area_stripe -start_from left -switch_layer_over_obs false -merge_stripes_value 10 -max_same_layer_jog_length 2 -pad_core_ring_top_layer_limit AP -pad_core_ring_bottom_layer_limit M1 -block_ring_top_layer_limit AP -block_ring_bottom_layer_limit M1 -use_wire_group 0 -snap_wire_center_to_grid none
    }
}

#underneath resources with NO macros
for {set i 0} {$i < $columns} {incr i} {
    for {set j 0} {$j < $rows} {incr j} {
        for {set k 0} {$k < 16} {incr k} {
            if { ($i == 0 && $j == 2) || ($i == 1 && $j == 2) || ($i == 2 && $j == 2) || ($i == 0 && $j == 0) || ($i == 1 && $j == 0) || ($i == 2 && $j == 0) } {
                if { $i == 0 && $j == 2 && ($k+1) != 1 && ($k+1) != 2 && ($k+1) != 3 && ($k+1) != 4 && ($k+1) != 5 && ($k+1) != 6 } {
                    set_db add_stripes_ignore_block_check true ; set_db add_stripes_break_at none ; set_db add_stripes_route_over_rows_only false ; set_db add_stripes_rows_without_stripes_only false ; set_db add_stripes_extend_to_closest_target none ; set_db add_stripes_stop_at_last_wire_for_area true ; set_db add_stripes_partial_set_through_domain false ; set_db add_stripes_ignore_non_default_domains false ; set_db add_stripes_trim_antenna_back_to_shape block_ring ; set_db add_stripes_spacing_type edge_to_edge ; set_db add_stripes_spacing_from_block 0 ; set_db add_stripes_stripe_min_length stripe_width ; set_db add_stripes_stacked_via_top_layer AP ; set_db add_stripes_stacked_via_bottom_layer M1 ; set_db add_stripes_via_using_exact_crossover_size false ; set_db add_stripes_split_vias false ; set_db add_stripes_orthogonal_only true ; set_db add_stripes_allow_jog { padcore_ring  block_ring } ; set_db add_stripes_skip_via_on_pin {  standardcell } ; set_db add_stripes_skip_via_on_wire_shape {  noshape   }

                    set x1 [expr {$x_length * $i + $x_margin + $seq_width + $x_offset}]
                    set y1 [expr {$y_length * $j + $y_margin + $swb_router_height + $resource_height * $k - $y_offset}]
                    set x2 [expr {$x1 + $resource_width - $x_offset*2}]
                    set y2 [expr {$y1 + $y_offset*2}]
                    set area_stripe [list \
                        $x1 $y1 \
                        $x2 $y1 \
                        $x2 $y2 \
                        $x1 $y2]
                    add_stripes -nets {VDD VSS} -layer M8 -direction vertical -width 1.8 -spacing 1.8 -set_to_set_distance 10 -area $area_stripe -start_from left -switch_layer_over_obs false -merge_stripes_value 10 -max_same_layer_jog_length 2 -pad_core_ring_top_layer_limit AP -pad_core_ring_bottom_layer_limit M1 -block_ring_top_layer_limit AP -block_ring_bottom_layer_limit M1 -use_wire_group 0 -snap_wire_center_to_grid none
                }

                if { $i == 1 && $j == 2 && ($k+1) != 1 && ($k+1) != 2 && ($k+1) != 3 && ($k+1) != 4 && ($k+1) != 5 && ($k+1) != 6 } {
                    set_db add_stripes_ignore_block_check true ; set_db add_stripes_break_at none ; set_db add_stripes_route_over_rows_only false ; set_db add_stripes_rows_without_stripes_only false ; set_db add_stripes_extend_to_closest_target none ; set_db add_stripes_stop_at_last_wire_for_area true ; set_db add_stripes_partial_set_through_domain false ; set_db add_stripes_ignore_non_default_domains false ; set_db add_stripes_trim_antenna_back_to_shape block_ring ; set_db add_stripes_spacing_type edge_to_edge ; set_db add_stripes_spacing_from_block 0 ; set_db add_stripes_stripe_min_length stripe_width ; set_db add_stripes_stacked_via_top_layer AP ; set_db add_stripes_stacked_via_bottom_layer M1 ; set_db add_stripes_via_using_exact_crossover_size false ; set_db add_stripes_split_vias false ; set_db add_stripes_orthogonal_only true ; set_db add_stripes_allow_jog { padcore_ring  block_ring } ; set_db add_stripes_skip_via_on_pin {  standardcell } ; set_db add_stripes_skip_via_on_wire_shape {  noshape   }

                    set x1 [expr {$x_length * $i + $x_margin + $seq_width + $x_offset}]
                    set y1 [expr {$y_length * $j + $y_margin + $swb_router_height + $resource_height * $k - $y_offset}]
                    set x2 [expr {$x1 + $resource_width - $x_offset*2}]
                    set y2 [expr {$y1 + $y_offset*2}]
                    set area_stripe [list \
                        $x1 $y1 \
                        $x2 $y1 \
                        $x2 $y2 \
                        $x1 $y2]
                    add_stripes -nets {VDD VSS} -layer M8 -direction vertical -width 1.8 -spacing 1.8 -set_to_set_distance 10 -area $area_stripe -start_from left -switch_layer_over_obs false -merge_stripes_value 10 -max_same_layer_jog_length 2 -pad_core_ring_top_layer_limit AP -pad_core_ring_bottom_layer_limit M1 -block_ring_top_layer_limit AP -block_ring_bottom_layer_limit M1 -use_wire_group 0 -snap_wire_center_to_grid none
                }

                if { $i == 2 && $j == 2 && ($k+1) != 1 && ($k+1) != 2 && ($k+1) != 3 && ($k+1) != 4 && ($k+1) != 5 && ($k+1) != 6 } {
                    set_db add_stripes_ignore_block_check true ; set_db add_stripes_break_at none ; set_db add_stripes_route_over_rows_only false ; set_db add_stripes_rows_without_stripes_only false ; set_db add_stripes_extend_to_closest_target none ; set_db add_stripes_stop_at_last_wire_for_area true ; set_db add_stripes_partial_set_through_domain false ; set_db add_stripes_ignore_non_default_domains false ; set_db add_stripes_trim_antenna_back_to_shape block_ring ; set_db add_stripes_spacing_type edge_to_edge ; set_db add_stripes_spacing_from_block 0 ; set_db add_stripes_stripe_min_length stripe_width ; set_db add_stripes_stacked_via_top_layer AP ; set_db add_stripes_stacked_via_bottom_layer M1 ; set_db add_stripes_via_using_exact_crossover_size false ; set_db add_stripes_split_vias false ; set_db add_stripes_orthogonal_only true ; set_db add_stripes_allow_jog { padcore_ring  block_ring } ; set_db add_stripes_skip_via_on_pin {  standardcell } ; set_db add_stripes_skip_via_on_wire_shape {  noshape   }

                    set x1 [expr {$x_length * $i + $x_margin + $seq_width + $x_offset}]
                    set y1 [expr {$y_length * $j + $y_margin + $swb_router_height + $resource_height * $k - $y_offset}]
                    set x2 [expr {$x1 + $resource_width - $x_offset*2}]
                    set y2 [expr {$y1 + $y_offset*2}]
                    set area_stripe [list \
                        $x1 $y1 \
                        $x2 $y1 \
                        $x2 $y2 \
                        $x1 $y2]
                    add_stripes -nets {VDD VSS} -layer M8 -direction vertical -width 1.8 -spacing 1.8 -set_to_set_distance 10 -area $area_stripe -start_from left -switch_layer_over_obs false -merge_stripes_value 10 -max_same_layer_jog_length 2 -pad_core_ring_top_layer_limit AP -pad_core_ring_bottom_layer_limit M1 -block_ring_top_layer_limit AP -block_ring_bottom_layer_limit M1 -use_wire_group 0 -snap_wire_center_to_grid none
                }

                if { $i == 0 && $j == 0 && ($k+1) != 1 && ($k+1) != 2 && ($k+1) != 3 && ($k+1) != 4 && ($k+1) != 5 && ($k+1) != 6 } {
                    set_db add_stripes_ignore_block_check true ; set_db add_stripes_break_at none ; set_db add_stripes_route_over_rows_only false ; set_db add_stripes_rows_without_stripes_only false ; set_db add_stripes_extend_to_closest_target none ; set_db add_stripes_stop_at_last_wire_for_area true ; set_db add_stripes_partial_set_through_domain false ; set_db add_stripes_ignore_non_default_domains false ; set_db add_stripes_trim_antenna_back_to_shape block_ring ; set_db add_stripes_spacing_type edge_to_edge ; set_db add_stripes_spacing_from_block 0 ; set_db add_stripes_stripe_min_length stripe_width ; set_db add_stripes_stacked_via_top_layer AP ; set_db add_stripes_stacked_via_bottom_layer M1 ; set_db add_stripes_via_using_exact_crossover_size false ; set_db add_stripes_split_vias false ; set_db add_stripes_orthogonal_only true ; set_db add_stripes_allow_jog { padcore_ring  block_ring } ; set_db add_stripes_skip_via_on_pin {  standardcell } ; set_db add_stripes_skip_via_on_wire_shape {  noshape   }

                    set x1 [expr {$x_length * $i + $x_margin + $seq_width + $x_offset}]
                    set y1 [expr {$y_length * $j + $y_margin + $swb_router_height + $resource_height * $k - $y_offset}]
                    set x2 [expr {$x1 + $resource_width - $x_offset*2}]
                    set y2 [expr {$y1 + $y_offset*2}]
                    set area_stripe [list \
                        $x1 $y1 \
                        $x2 $y1 \
                        $x2 $y2 \
                        $x1 $y2]
                    add_stripes -nets {VDD VSS} -layer M8 -direction vertical -width 1.8 -spacing 1.8 -set_to_set_distance 10 -area $area_stripe -start_from left -switch_layer_over_obs false -merge_stripes_value 10 -max_same_layer_jog_length 2 -pad_core_ring_top_layer_limit AP -pad_core_ring_bottom_layer_limit M1 -block_ring_top_layer_limit AP -block_ring_bottom_layer_limit M1 -use_wire_group 0 -snap_wire_center_to_grid none
                }

                if { $i == 1 && $j == 0 && ($k+1) != 1 && ($k+1) != 2 && ($k+1) != 3 && ($k+1) != 4 && ($k+1) != 5 && ($k+1) != 6 } {
                    set_db add_stripes_ignore_block_check true ; set_db add_stripes_break_at none ; set_db add_stripes_route_over_rows_only false ; set_db add_stripes_rows_without_stripes_only false ; set_db add_stripes_extend_to_closest_target none ; set_db add_stripes_stop_at_last_wire_for_area true ; set_db add_stripes_partial_set_through_domain false ; set_db add_stripes_ignore_non_default_domains false ; set_db add_stripes_trim_antenna_back_to_shape block_ring ; set_db add_stripes_spacing_type edge_to_edge ; set_db add_stripes_spacing_from_block 0 ; set_db add_stripes_stripe_min_length stripe_width ; set_db add_stripes_stacked_via_top_layer AP ; set_db add_stripes_stacked_via_bottom_layer M1 ; set_db add_stripes_via_using_exact_crossover_size false ; set_db add_stripes_split_vias false ; set_db add_stripes_orthogonal_only true ; set_db add_stripes_allow_jog { padcore_ring  block_ring } ; set_db add_stripes_skip_via_on_pin {  standardcell } ; set_db add_stripes_skip_via_on_wire_shape {  noshape   }

                    set x1 [expr {$x_length * $i + $x_margin + $seq_width + $x_offset}]
                    set y1 [expr {$y_length * $j + $y_margin + $swb_router_height + $resource_height * $k - $y_offset}]
                    set x2 [expr {$x1 + $resource_width - $x_offset*2}]
                    set y2 [expr {$y1 + $y_offset*2}]
                    set area_stripe [list \
                        $x1 $y1 \
                        $x2 $y1 \
                        $x2 $y2 \
                        $x1 $y2]
                    add_stripes -nets {VDD VSS} -layer M8 -direction vertical -width 1.8 -spacing 1.8 -set_to_set_distance 10 -area $area_stripe -start_from left -switch_layer_over_obs false -merge_stripes_value 10 -max_same_layer_jog_length 2 -pad_core_ring_top_layer_limit AP -pad_core_ring_bottom_layer_limit M1 -block_ring_top_layer_limit AP -block_ring_bottom_layer_limit M1 -use_wire_group 0 -snap_wire_center_to_grid none
                }

                if { $i == 2 && $j == 0 && ($k+1) != 1 && ($k+1) != 2 && ($k+1) != 3 && ($k+1) != 4 && ($k+1) != 5 && ($k+1) != 6 } {
                    set_db add_stripes_ignore_block_check true ; set_db add_stripes_break_at none ; set_db add_stripes_route_over_rows_only false ; set_db add_stripes_rows_without_stripes_only false ; set_db add_stripes_extend_to_closest_target none ; set_db add_stripes_stop_at_last_wire_for_area true ; set_db add_stripes_partial_set_through_domain false ; set_db add_stripes_ignore_non_default_domains false ; set_db add_stripes_trim_antenna_back_to_shape block_ring ; set_db add_stripes_spacing_type edge_to_edge ; set_db add_stripes_spacing_from_block 0 ; set_db add_stripes_stripe_min_length stripe_width ; set_db add_stripes_stacked_via_top_layer AP ; set_db add_stripes_stacked_via_bottom_layer M1 ; set_db add_stripes_via_using_exact_crossover_size false ; set_db add_stripes_split_vias false ; set_db add_stripes_orthogonal_only true ; set_db add_stripes_allow_jog { padcore_ring  block_ring } ; set_db add_stripes_skip_via_on_pin {  standardcell } ; set_db add_stripes_skip_via_on_wire_shape {  noshape   }

                    set x1 [expr {$x_length * $i + $x_margin + $seq_width + $x_offset}]
                    set y1 [expr {$y_length * $j + $y_margin + $swb_router_height + $resource_height * $k - $y_offset}]
                    set x2 [expr {$x1 + $resource_width - $x_offset*2}]
                    set y2 [expr {$y1 + $y_offset*2}]
                    set area_stripe [list \
                        $x1 $y1 \
                        $x2 $y1 \
                        $x2 $y2 \
                        $x1 $y2]
                    add_stripes -nets {VDD VSS} -layer M8 -direction vertical -width 1.8 -spacing 1.8 -set_to_set_distance 10 -area $area_stripe -start_from left -switch_layer_over_obs false -merge_stripes_value 10 -max_same_layer_jog_length 2 -pad_core_ring_top_layer_limit AP -pad_core_ring_bottom_layer_limit M1 -block_ring_top_layer_limit AP -block_ring_bottom_layer_limit M1 -use_wire_group 0 -snap_wire_center_to_grid none
                }

            } else {
                set_db add_stripes_ignore_block_check true ; set_db add_stripes_break_at none ; set_db add_stripes_route_over_rows_only false ; set_db add_stripes_rows_without_stripes_only false ; set_db add_stripes_extend_to_closest_target none ; set_db add_stripes_stop_at_last_wire_for_area true ; set_db add_stripes_partial_set_through_domain false ; set_db add_stripes_ignore_non_default_domains false ; set_db add_stripes_trim_antenna_back_to_shape block_ring ; set_db add_stripes_spacing_type edge_to_edge ; set_db add_stripes_spacing_from_block 0 ; set_db add_stripes_stripe_min_length stripe_width ; set_db add_stripes_stacked_via_top_layer AP ; set_db add_stripes_stacked_via_bottom_layer M1 ; set_db add_stripes_via_using_exact_crossover_size false ; set_db add_stripes_split_vias false ; set_db add_stripes_orthogonal_only true ; set_db add_stripes_allow_jog { padcore_ring  block_ring } ; set_db add_stripes_skip_via_on_pin {  standardcell } ; set_db add_stripes_skip_via_on_wire_shape {  noshape   }

                set x1 [expr {$x_length * $i + $x_margin + $seq_width + $x_offset}]
                set y1 [expr {$y_length * $j + $y_margin + $swb_router_height + $resource_height * $k - $y_offset}]
                set x2 [expr {$x1 + $resource_width - $x_offset*2}]
                set y2 [expr {$y1 + $y_offset*2}]
                set area_stripe [list \
                    $x1 $y1 \
                    $x2 $y1 \
                    $x2 $y2 \
                    $x1 $y2]
                add_stripes -nets {VDD VSS} -layer M8 -direction vertical -width 1.8 -spacing 1.8 -set_to_set_distance 10 -area $area_stripe -start_from left -switch_layer_over_obs false -merge_stripes_value 10 -max_same_layer_jog_length 2 -pad_core_ring_top_layer_limit AP -pad_core_ring_bottom_layer_limit M1 -block_ring_top_layer_limit AP -block_ring_bottom_layer_limit M1 -use_wire_group 0 -snap_wire_center_to_grid none
            }
        }
    }
}

#underneath resources with macros
set_db add_stripes_ignore_block_check true ; set_db add_stripes_break_at none ; set_db add_stripes_route_over_rows_only false ; set_db add_stripes_rows_without_stripes_only false ; set_db add_stripes_extend_to_closest_target none ; set_db add_stripes_stop_at_last_wire_for_area true ; set_db add_stripes_partial_set_through_domain false ; set_db add_stripes_ignore_non_default_domains false ; set_db add_stripes_trim_antenna_back_to_shape block_ring ; set_db add_stripes_spacing_type edge_to_edge ; set_db add_stripes_spacing_from_block 0 ; set_db add_stripes_stripe_min_length stripe_width ; set_db add_stripes_stacked_via_top_layer AP ; set_db add_stripes_stacked_via_bottom_layer M1 ; set_db add_stripes_via_using_exact_crossover_size false ; set_db add_stripes_split_vias false ; set_db add_stripes_orthogonal_only true ; set_db add_stripes_allow_jog { padcore_ring  block_ring } ; set_db add_stripes_skip_via_on_pin {  standardcell } ; set_db add_stripes_skip_via_on_wire_shape {  noshape   }
set x1 [expr {$x_length * 0 + $x_margin + $seq_width + $x_offset}]
set y1 [expr {$y_length * 2 + $y_margin + $swb_router_height + $resource_height * 0 - $y_offset}]
set x2 [expr {$x1 + $resource_width - $x_offset*2}]
set y2 [expr {$y1 + $y_offset*2}]
set area_stripe [list \
$x1 $y1 \
$x2 $y1 \
$x2 $y2 \
$x1 $y2]
add_stripes -nets {VDD VSS} -layer M8 -direction vertical -width 1.8 -spacing 1.8 -set_to_set_distance 10 -area $area_stripe -start_from left -switch_layer_over_obs false -merge_stripes_value 10 -max_same_layer_jog_length 2 -pad_core_ring_top_layer_limit AP -pad_core_ring_bottom_layer_limit M1 -block_ring_top_layer_limit AP -block_ring_bottom_layer_limit M1 -use_wire_group 0 -snap_wire_center_to_grid none             

set_db add_stripes_ignore_block_check true ; set_db add_stripes_break_at none ; set_db add_stripes_route_over_rows_only false ; set_db add_stripes_rows_without_stripes_only false ; set_db add_stripes_extend_to_closest_target none ; set_db add_stripes_stop_at_last_wire_for_area true ; set_db add_stripes_partial_set_through_domain false ; set_db add_stripes_ignore_non_default_domains false ; set_db add_stripes_trim_antenna_back_to_shape block_ring ; set_db add_stripes_spacing_type edge_to_edge ; set_db add_stripes_spacing_from_block 0 ; set_db add_stripes_stripe_min_length stripe_width ; set_db add_stripes_stacked_via_top_layer AP ; set_db add_stripes_stacked_via_bottom_layer M1 ; set_db add_stripes_via_using_exact_crossover_size false ; set_db add_stripes_split_vias false ; set_db add_stripes_orthogonal_only true ; set_db add_stripes_allow_jog { padcore_ring  block_ring } ; set_db add_stripes_skip_via_on_pin {  standardcell } ; set_db add_stripes_skip_via_on_wire_shape {  noshape   }
set x1 [expr {$x_length * 1 + $x_margin + $seq_width + $x_offset}]
set y1 [expr {$y_length * 2 + $y_margin + $swb_router_height + $resource_height * 0 - $y_offset}]
set x2 [expr {$x1 + $resource_width - $x_offset*2}]
set y2 [expr {$y1 + $y_offset*2}]
set area_stripe [list \
$x1 $y1 \
$x2 $y1 \
$x2 $y2 \
$x1 $y2]
add_stripes -nets {VDD VSS} -layer M8 -direction vertical -width 1.8 -spacing 1.8 -set_to_set_distance 10 -area $area_stripe -start_from left -switch_layer_over_obs false -merge_stripes_value 10 -max_same_layer_jog_length 2 -pad_core_ring_top_layer_limit AP -pad_core_ring_bottom_layer_limit M1 -block_ring_top_layer_limit AP -block_ring_bottom_layer_limit M1 -use_wire_group 0 -snap_wire_center_to_grid none             

set_db add_stripes_ignore_block_check true ; set_db add_stripes_break_at none ; set_db add_stripes_route_over_rows_only false ; set_db add_stripes_rows_without_stripes_only false ; set_db add_stripes_extend_to_closest_target none ; set_db add_stripes_stop_at_last_wire_for_area true ; set_db add_stripes_partial_set_through_domain false ; set_db add_stripes_ignore_non_default_domains false ; set_db add_stripes_trim_antenna_back_to_shape block_ring ; set_db add_stripes_spacing_type edge_to_edge ; set_db add_stripes_spacing_from_block 0 ; set_db add_stripes_stripe_min_length stripe_width ; set_db add_stripes_stacked_via_top_layer AP ; set_db add_stripes_stacked_via_bottom_layer M1 ; set_db add_stripes_via_using_exact_crossover_size false ; set_db add_stripes_split_vias false ; set_db add_stripes_orthogonal_only true ; set_db add_stripes_allow_jog { padcore_ring  block_ring } ; set_db add_stripes_skip_via_on_pin {  standardcell } ; set_db add_stripes_skip_via_on_wire_shape {  noshape   }
set x1 [expr {$x_length * 2 + $x_margin + $seq_width + $x_offset}]
set y1 [expr {$y_length * 2 + $y_margin + $swb_router_height + $resource_height * 0 - $y_offset}]
set x2 [expr {$x1 + $resource_width - $x_offset*2}]
set y2 [expr {$y1 + $y_offset*2}]
set area_stripe [list \
$x1 $y1 \
$x2 $y1 \
$x2 $y2 \
$x1 $y2]
add_stripes -nets {VDD VSS} -layer M8 -direction vertical -width 1.8 -spacing 1.8 -set_to_set_distance 10 -area $area_stripe -start_from left -switch_layer_over_obs false -merge_stripes_value 10 -max_same_layer_jog_length 2 -pad_core_ring_top_layer_limit AP -pad_core_ring_bottom_layer_limit M1 -block_ring_top_layer_limit AP -block_ring_bottom_layer_limit M1 -use_wire_group 0 -snap_wire_center_to_grid none             

set_db add_stripes_ignore_block_check true ; set_db add_stripes_break_at none ; set_db add_stripes_route_over_rows_only false ; set_db add_stripes_rows_without_stripes_only false ; set_db add_stripes_extend_to_closest_target none ; set_db add_stripes_stop_at_last_wire_for_area true ; set_db add_stripes_partial_set_through_domain false ; set_db add_stripes_ignore_non_default_domains false ; set_db add_stripes_trim_antenna_back_to_shape block_ring ; set_db add_stripes_spacing_type edge_to_edge ; set_db add_stripes_spacing_from_block 0 ; set_db add_stripes_stripe_min_length stripe_width ; set_db add_stripes_stacked_via_top_layer AP ; set_db add_stripes_stacked_via_bottom_layer M1 ; set_db add_stripes_via_using_exact_crossover_size false ; set_db add_stripes_split_vias false ; set_db add_stripes_orthogonal_only true ; set_db add_stripes_allow_jog { padcore_ring  block_ring } ; set_db add_stripes_skip_via_on_pin {  standardcell } ; set_db add_stripes_skip_via_on_wire_shape {  noshape   }
set x1 [expr {$x_length * 0 + $x_margin + $seq_width + $x_offset}]
set y1 [expr {$y_length * 0 + $y_margin + $swb_router_height + $resource_height * 0 - $y_offset}]
set x2 [expr {$x1 + $resource_width - $x_offset*2}]
set y2 [expr {$y1 + $y_offset*2}]
set area_stripe [list \
$x1 $y1 \
$x2 $y1 \
$x2 $y2 \
$x1 $y2]
add_stripes -nets {VDD VSS} -layer M8 -direction vertical -width 1.8 -spacing 1.8 -set_to_set_distance 10 -area $area_stripe -start_from left -switch_layer_over_obs false -merge_stripes_value 10 -max_same_layer_jog_length 2 -pad_core_ring_top_layer_limit AP -pad_core_ring_bottom_layer_limit M1 -block_ring_top_layer_limit AP -block_ring_bottom_layer_limit M1 -use_wire_group 0 -snap_wire_center_to_grid none             

set_db add_stripes_ignore_block_check true ; set_db add_stripes_break_at none ; set_db add_stripes_route_over_rows_only false ; set_db add_stripes_rows_without_stripes_only false ; set_db add_stripes_extend_to_closest_target none ; set_db add_stripes_stop_at_last_wire_for_area true ; set_db add_stripes_partial_set_through_domain false ; set_db add_stripes_ignore_non_default_domains false ; set_db add_stripes_trim_antenna_back_to_shape block_ring ; set_db add_stripes_spacing_type edge_to_edge ; set_db add_stripes_spacing_from_block 0 ; set_db add_stripes_stripe_min_length stripe_width ; set_db add_stripes_stacked_via_top_layer AP ; set_db add_stripes_stacked_via_bottom_layer M1 ; set_db add_stripes_via_using_exact_crossover_size false ; set_db add_stripes_split_vias false ; set_db add_stripes_orthogonal_only true ; set_db add_stripes_allow_jog { padcore_ring  block_ring } ; set_db add_stripes_skip_via_on_pin {  standardcell } ; set_db add_stripes_skip_via_on_wire_shape {  noshape   }
set x1 [expr {$x_length * 1 + $x_margin + $seq_width + $x_offset}]
set y1 [expr {$y_length * 0 + $y_margin + $swb_router_height + $resource_height * 0 - $y_offset}]
set x2 [expr {$x1 + $resource_width - $x_offset*2}]
set y2 [expr {$y1 + $y_offset*2}]
set area_stripe [list \
$x1 $y1 \
$x2 $y1 \
$x2 $y2 \
$x1 $y2]
add_stripes -nets {VDD VSS} -layer M8 -direction vertical -width 1.8 -spacing 1.8 -set_to_set_distance 10 -area $area_stripe -start_from left -switch_layer_over_obs false -merge_stripes_value 10 -max_same_layer_jog_length 2 -pad_core_ring_top_layer_limit AP -pad_core_ring_bottom_layer_limit M1 -block_ring_top_layer_limit AP -block_ring_bottom_layer_limit M1 -use_wire_group 0 -snap_wire_center_to_grid none             

set_db add_stripes_ignore_block_check true ; set_db add_stripes_break_at none ; set_db add_stripes_route_over_rows_only false ; set_db add_stripes_rows_without_stripes_only false ; set_db add_stripes_extend_to_closest_target none ; set_db add_stripes_stop_at_last_wire_for_area true ; set_db add_stripes_partial_set_through_domain false ; set_db add_stripes_ignore_non_default_domains false ; set_db add_stripes_trim_antenna_back_to_shape block_ring ; set_db add_stripes_spacing_type edge_to_edge ; set_db add_stripes_spacing_from_block 0 ; set_db add_stripes_stripe_min_length stripe_width ; set_db add_stripes_stacked_via_top_layer AP ; set_db add_stripes_stacked_via_bottom_layer M1 ; set_db add_stripes_via_using_exact_crossover_size false ; set_db add_stripes_split_vias false ; set_db add_stripes_orthogonal_only true ; set_db add_stripes_allow_jog { padcore_ring  block_ring } ; set_db add_stripes_skip_via_on_pin {  standardcell } ; set_db add_stripes_skip_via_on_wire_shape {  noshape   }
set x1 [expr {$x_length * 2 + $x_margin + $seq_width + $x_offset}]
set y1 [expr {$y_length * 0 + $y_margin + $swb_router_height + $resource_height * 0 - $y_offset}]
set x2 [expr {$x1 + $resource_width - $x_offset*2}]
set y2 [expr {$y1 + $y_offset*2}]
set area_stripe [list \
$x1 $y1 \
$x2 $y1 \
$x2 $y2 \
$x1 $y2]
add_stripes -nets {VDD VSS} -layer M8 -direction vertical -width 1.8 -spacing 1.8 -set_to_set_distance 10 -area $area_stripe -start_from left -switch_layer_over_obs false -merge_stripes_value 10 -max_same_layer_jog_length 2 -pad_core_ring_top_layer_limit AP -pad_core_ring_bottom_layer_limit M1 -block_ring_top_layer_limit AP -block_ring_bottom_layer_limit M1 -use_wire_group 0 -snap_wire_center_to_grid none             




#stripes between different cells
set_db add_stripes_ignore_block_check true ; set_db add_stripes_break_at none ; set_db add_stripes_route_over_rows_only false ; set_db add_stripes_rows_without_stripes_only false ; set_db add_stripes_extend_to_closest_target none ; set_db add_stripes_stop_at_last_wire_for_area true ; set_db add_stripes_partial_set_through_domain false ; set_db add_stripes_ignore_non_default_domains false ; set_db add_stripes_trim_antenna_back_to_shape block_ring ; set_db add_stripes_spacing_type edge_to_edge ; set_db add_stripes_spacing_from_block 0 ; set_db add_stripes_stripe_min_length stripe_width ; set_db add_stripes_stacked_via_top_layer AP ; set_db add_stripes_stacked_via_bottom_layer M1 ; set_db add_stripes_via_using_exact_crossover_size false ; set_db add_stripes_split_vias false ; set_db add_stripes_orthogonal_only true ; set_db add_stripes_allow_jog { padcore_ring  block_ring } ; set_db add_stripes_skip_via_on_pin {  standardcell } ; set_db add_stripes_skip_via_on_wire_shape {  noshape   }

for {set i 0} {$i < $columns} {incr i} {
    for {set j 0} {$j < $rows-1} {incr j} {
        #between lower sequencer and upper swb
        set x1 [expr {$x_margin + $x_length * $i + $x_offset}]
        set y1 [expr {$y_margin + $y_length * ($j+1) - $y_offset}]
        set x2 [expr {$x1 + $seq_width - $x_offset * 2}]
        set y2 [expr {$y1 + $y_offset * 2}]
        set area_stripe [list \
            $x1 $y1 \
            $x2 $y1 \
            $x2 $y2 \
            $x1 $y2]
        add_stripes -nets {VDD VSS} -layer M8 -direction vertical -width 1.8 -spacing 1.8 -set_to_set_distance 20 -area $area_stripe -start_from left -switch_layer_over_obs false -merge_stripes_value 10 -max_same_layer_jog_length 2 -pad_core_ring_top_layer_limit AP -pad_core_ring_bottom_layer_limit M1 -block_ring_top_layer_limit AP -block_ring_bottom_layer_limit M1 -use_wire_group 0 -snap_wire_center_to_grid none

        #between lower resource and upper swb
        set x1 [expr {$x_margin + $x_length * $i + $seq_width + $x_offset}]
        set y1 [expr {$y_margin + $y_length * ($j+1) - $y_offset}]
        set x2 [expr {$x1 + $resource_width - $x_offset * 2}]
        set y2 [expr {$y1 + $y_offset * 2}]
        set area_stripe [list \
            $x1 $y1 \
            $x2 $y1 \
            $x2 $y2 \
            $x1 $y2]
        add_stripes -nets {VDD VSS} -layer M8 -direction vertical -width 1.8 -spacing 1.8 -set_to_set_distance 20 -area $area_stripe -start_from left -switch_layer_over_obs false -merge_stripes_value 10 -max_same_layer_jog_length 2 -pad_core_ring_top_layer_limit AP -pad_core_ring_bottom_layer_limit M1 -block_ring_top_layer_limit AP -block_ring_bottom_layer_limit M1 -use_wire_group 0 -snap_wire_center_to_grid none

        #between lower swb and upper swb
        set x1 [expr {$x_margin + $x_length * $i + $seq_width + $resource_width + $x_offset}]
        set y1 [expr {$y_margin + $y_length * ($j+1) - $y_offset}]
        set x2 [expr {$x1 + $swb_router_width - $x_offset * 2}]
        set y2 [expr {$y1 + $y_offset * 2}]
        set area_stripe [list \
            $x1 $y1 \
            $x2 $y1 \
            $x2 $y2 \
            $x1 $y2]
        add_stripes -nets {VDD VSS} -layer M8 -direction vertical -width 1.8 -spacing 1.8 -set_to_set_distance 20 -area $area_stripe -start_from left -switch_layer_over_obs false -merge_stripes_value 10 -max_same_layer_jog_length 2 -pad_core_ring_top_layer_limit AP -pad_core_ring_bottom_layer_limit M1 -block_ring_top_layer_limit AP -block_ring_bottom_layer_limit M1 -use_wire_group 0 -snap_wire_center_to_grid none
    }
}   

for {set i 0} {$i < $rows} {incr i} {
    for {set j 0} {$j < $columns-1} {incr j} {
        #between left swb and right swb
        set x1 [expr {$x_margin + $x_length * ($j+1) - $x_offset}]
        set y1 [expr {$y_margin + $y_length * $i + $y_offset}]
        set x2 [expr {$x1 + $x_offset * 2}]
        set y2 [expr {$y1 + $swb_router_height - $y_offset * 2}]
        set area_stripe [list \
            $x1 $y1 \
            $x2 $y1 \
            $x2 $y2 \
            $x1 $y2]
        add_stripes -nets {VDD VSS} -layer M7 -direction horizontal -width 1.8 -spacing 1.8 -set_to_set_distance 20 -area $area_stripe -start_from bottom -switch_layer_over_obs false -merge_stripes_value 10 -max_same_layer_jog_length 2 -pad_core_ring_top_layer_limit AP -pad_core_ring_bottom_layer_limit M1 -block_ring_top_layer_limit AP -block_ring_bottom_layer_limit M1 -use_wire_group 0 -snap_wire_center_to_grid none

        #between left swb and right seq
        set x1 [expr {$x_margin + $x_length * ($j+1) - $x_offset}]
        set y1 [expr {$y_margin + $y_length * $i + $swb_router_height + $y_offset}]
        set x2 [expr {$x1 + $x_offset * 2}]
        set y2 [expr {$y1 + $seq_height - $y_offset * 2}]
        set area_stripe [list \
            $x1 $y1 \
            $x2 $y1 \
            $x2 $y2 \
            $x1 $y2]
        add_stripes -nets {VDD VSS} -layer M7 -direction horizontal -width 1.8 -spacing 1.8 -set_to_set_distance 20 -area $area_stripe -start_from bottom -switch_layer_over_obs false -merge_stripes_value 10 -max_same_layer_jog_length 2 -pad_core_ring_top_layer_limit AP -pad_core_ring_bottom_layer_limit M1 -block_ring_top_layer_limit AP -block_ring_bottom_layer_limit M1 -use_wire_group 0 -snap_wire_center_to_grid none
    }
}



#stripes core ring to inner rings
set_db add_stripes_ignore_block_check false ; set_db add_stripes_break_at {  block_ring  } ; set_db add_stripes_route_over_rows_only false ; set_db add_stripes_rows_without_stripes_only false ; set_db add_stripes_extend_to_closest_target ring ; set_db add_stripes_stop_at_last_wire_for_area true ; set_db add_stripes_partial_set_through_domain false ; set_db add_stripes_ignore_non_default_domains false ; set_db add_stripes_trim_antenna_back_to_shape block_ring ; set_db add_stripes_spacing_type edge_to_edge ; set_db add_stripes_spacing_from_block 0 ; set_db add_stripes_stripe_min_length stripe_width ; set_db add_stripes_stacked_via_top_layer AP ; set_db add_stripes_stacked_via_bottom_layer M1 ; set_db add_stripes_via_using_exact_crossover_size false ; set_db add_stripes_split_vias false ; set_db add_stripes_orthogonal_only true ; set_db add_stripes_allow_jog { padcore_ring  block_ring } ; set_db add_stripes_skip_via_on_pin {  standardcell } ; set_db add_stripes_skip_via_on_wire_shape {  noshape   }

for {set j 0} {$j < $rows} {incr j} {
    #left side
    set x1 0
    set y1 [expr {$y_margin + $y_offset + $y_length * $j}]
    set x2 [expr {$x1 + $x_margin + $x_offset}]
    set y2 [expr {$y1 + $swb_router_height - $y_offset * 2}]
    set area_stripe [list \
        $x1 $y1 \
        $x2 $y1 \
        $x2 $y2 \
        $x1 $y2]
    add_stripes -nets {VDD VSS} -layer M7 -direction horizontal -width 1.8 -spacing 1.8 -set_to_set_distance 20 -area $area_stripe -start_from bottom -switch_layer_over_obs false -merge_stripes_value 10 -max_same_layer_jog_length 2 -pad_core_ring_top_layer_limit AP -pad_core_ring_bottom_layer_limit M1 -block_ring_top_layer_limit AP -block_ring_bottom_layer_limit M1 -use_wire_group 0 -snap_wire_center_to_grid none

    set x1 0
    set y1 [expr {$y_margin + $y_offset + $y_length * $j + $swb_router_height}]
    set x2 [expr {$x1 + $x_margin + $x_offset}]
    set y2 [expr {$y1 + $seq_height - $y_offset * 2}]
    set area_stripe [list \
        $x1 $y1 \
        $x2 $y1 \
        $x2 $y2 \
        $x1 $y2]
    add_stripes -nets {VDD VSS} -layer M7 -direction horizontal -width 1.8 -spacing 1.8 -set_to_set_distance 20 -area $area_stripe -start_from bottom -switch_layer_over_obs false -merge_stripes_value 10 -max_same_layer_jog_length 2 -pad_core_ring_top_layer_limit AP -pad_core_ring_bottom_layer_limit M1 -block_ring_top_layer_limit AP -block_ring_bottom_layer_limit M1 -use_wire_group 0 -snap_wire_center_to_grid none

    #right side
    set x1 [expr {$x_margin + $x_length * $columns - $x_offset}]
    set y1 [expr {$y_margin + $y_offset + $y_length * $j}]
    set x2 [expr {$x1 + $x_margin + $x_offset}]
    set y2 [expr {$y1 + $swb_router_height + $seq_height - $y_offset * 2}]
    set area_stripe [list \
        $x1 $y1 \
        $x2 $y1 \
        $x2 $y2 \
        $x1 $y2]
    add_stripes -nets {VDD VSS} -layer M7 -direction horizontal -width 1.8 -spacing 1.8 -set_to_set_distance 20 -area $area_stripe -start_from bottom -switch_layer_over_obs false -merge_stripes_value 10 -max_same_layer_jog_length 2 -pad_core_ring_top_layer_limit AP -pad_core_ring_bottom_layer_limit M1 -block_ring_top_layer_limit AP -block_ring_bottom_layer_limit M1 -use_wire_group 0 -snap_wire_center_to_grid none
}

for {set i 0} {$i < $columns} {incr i} {
    #bottom side
    set x1 [expr {$x_margin + $x_offset + $x_length *$i}]
    set y1 0
    set x2 [expr {$x1 + $seq_width + $resource_width + $swb_router_width -$x_offset * 2}]
    set y2 [expr {$y1 + $y_margin + $y_offset}]
    set area_stripe [list \
        $x1 $y1 \
        $x2 $y1 \
        $x2 $y2 \
        $x1 $y2]
    add_stripes -nets {VDD VSS} -layer M8 -direction vertical -width 1.8 -spacing 1.8 -set_to_set_distance 20 -area $area_stripe -start_from left -switch_layer_over_obs false -merge_stripes_value 10 -max_same_layer_jog_length 2 -pad_core_ring_top_layer_limit AP -pad_core_ring_bottom_layer_limit M1 -block_ring_top_layer_limit AP -block_ring_bottom_layer_limit M1 -use_wire_group 0 -snap_wire_center_to_grid none

    #top side
    set x1 [expr {$x_margin + $x_offset + $x_length *$i}]
    set y1 [expr {$y_margin + $y_length * $rows - $y_offset}]
    set x2 [expr {$x1 + $seq_width -$x_offset * 2}]
    set y2 [expr {$y1 + $y_margin + $y_offset}]
    set area_stripe [list \
        $x1 $y1 \
        $x2 $y1 \
        $x2 $y2 \
        $x1 $y2]
    add_stripes -nets {VDD VSS} -layer M8 -direction vertical -width 1.8 -spacing 1.8 -set_to_set_distance 20 -area $area_stripe -start_from left -switch_layer_over_obs false -merge_stripes_value 10 -max_same_layer_jog_length 2 -pad_core_ring_top_layer_limit AP -pad_core_ring_bottom_layer_limit M1 -block_ring_top_layer_limit AP -block_ring_bottom_layer_limit M1 -use_wire_group 0 -snap_wire_center_to_grid none

    set x1 [expr {$x_margin + $seq_width + $x_offset + $x_length *$i}]
    set y1 [expr {$y_margin + $y_length * $rows - $y_offset}]
    set x2 [expr {$x1 + $resource_width - $x_offset * 2}]
    set y2 [expr {$y1 + $y_margin + $y_offset}]
    set area_stripe [list \
        $x1 $y1 \
        $x2 $y1 \
        $x2 $y2 \
        $x1 $y2]
    add_stripes -nets {VDD VSS} -layer M8 -direction vertical -width 1.8 -spacing 1.8 -set_to_set_distance 20 -area $area_stripe -start_from left -switch_layer_over_obs false -merge_stripes_value 10 -max_same_layer_jog_length 2 -pad_core_ring_top_layer_limit AP -pad_core_ring_bottom_layer_limit M1 -block_ring_top_layer_limit AP -block_ring_bottom_layer_limit M1 -use_wire_group 0 -snap_wire_center_to_grid none

    set x1 [expr {$x_margin + $seq_width + $resource_width + $x_offset + $x_length *$i}]
    set y1 [expr {$y_margin + $y_length * $rows - $y_offset}]
    set x2 [expr {$x1 + $swb_router_width - $x_offset * 2}]
    set y2 [expr {$y1 + $y_margin + $y_offset}]
    set area_stripe [list \
        $x1 $y1 \
        $x2 $y1 \
        $x2 $y2 \
        $x1 $y2]
    add_stripes -nets {VDD VSS} -layer M8 -direction vertical -width 1.8 -spacing 1.8 -set_to_set_distance 20 -area $area_stripe -start_from left -switch_layer_over_obs false -merge_stripes_value 10 -max_same_layer_jog_length 2 -pad_core_ring_top_layer_limit AP -pad_core_ring_bottom_layer_limit M1 -block_ring_top_layer_limit AP -block_ring_bottom_layer_limit M1 -use_wire_group 0 -snap_wire_center_to_grid none
}



#final special route for cells' pins
reset_db -category route_special
set_db route_special_endcap_as_core true

route_special \
-nets { VDD VSS } \
-connect {core_pin floating_stripe} \
-allow_layer_change 1 \
-layer_change_range { M1(1) AP(10) } \
-allow_jogging 1 \
-crossover_via_layer_range { M1(1) AP(10) } \
-core_pin_target { none }



#to fix missing vias
update_power_vias -skip_via_on_pin standardcell -bottom_layer M1 -nets {VDD VSS} -add_vias 1 -top_layer AP

