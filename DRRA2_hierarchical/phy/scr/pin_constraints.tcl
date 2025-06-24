set bulk_bitwidth 256
set layer_in_north M2
set layer_out_south M2
set layer_in_south M4
set layer_out_north M4
set layer_in_west M3
set layer_out_east M3
set layer_in_east M5
set layer_out_west M5
set layer_bulk_intracell_out M3
set layer_bulk_intracell_in M5
set layer_word M7
set pin_margin 1.5
set pin_pitch1 0.2
set pin_pitch2 0.28
set pin_pitch3 0.4

#constraints for N,S,W,E pins for switchbox/router partition
for {set i 0} {$i < $bulk_bitwidth} {incr i} {
    set_pin_constraint -cell _kmcyy4g8mbb -pins "bulk_intercell_w_out[$i]" -location [list 0 [expr {$pin_margin + $pin_pitch1 * $i}] $layer_out_west]
    set_pin_constraint -cell _kmcyy4g8mbb -pins "bulk_intercell_w_in[$i]" -location [list 0 [expr {$pin_margin + $pin_pitch1 * $i}] $layer_in_west]
    set_pin_constraint -cell _kmcyy4g8mbb -pins "bulk_intercell_n_out[$i]" -location [list [expr {$seq_width + $resource_width + $swb_router_width - $pin_margin - $pin_pitch2 * $i}] [expr {$swb_router_height + $seq_height}] $layer_out_north]
    set_pin_constraint -cell _kmcyy4g8mbb -pins "bulk_intercell_n_in[$i]" -location [list [expr {$seq_width + $resource_width + $swb_router_width - $pin_margin - $pin_pitch1 * $i}] [expr {$swb_router_height + $seq_height}] $layer_in_north]
    set_pin_constraint -cell _kmcyy4g8mbb -pins "bulk_intercell_e_out[$i]" -location [list [expr {$seq_width + $resource_width + $swb_router_width}] [expr {$pin_margin + $pin_pitch1 * $i}] $layer_out_east]
    set_pin_constraint -cell _kmcyy4g8mbb -pins "bulk_intercell_e_in[$i]" -location [list [expr {$seq_width + $resource_width + $swb_router_width}] [expr {$pin_margin + $pin_pitch1 * $i}] $layer_in_east]
    set_pin_constraint -cell _kmcyy4g8mbb -pins "bulk_intercell_s_out[$i]" -location [list [expr {$seq_width + $resource_width + $swb_router_width - $pin_margin - $pin_pitch2 * $i}] 0 $layer_out_south]
    set_pin_constraint -cell _kmcyy4g8mbb -pins "bulk_intercell_s_in[$i]" -location [list [expr {$seq_width + $resource_width + $swb_router_width - $pin_margin - $pin_pitch1 * $i}] 0 $layer_in_south]
    set_pin_constraint -cell _kmcyy4g8mbb_3 -pins "bulk_intercell_w_out[$i]" -location [list 0 [expr {$pin_margin + $pin_pitch1 * $i}] $layer_out_west]
    set_pin_constraint -cell _kmcyy4g8mbb_3 -pins "bulk_intercell_w_in[$i]" -location [list 0 [expr {$pin_margin + $pin_pitch1 * $i}] $layer_in_west]
    set_pin_constraint -cell _kmcyy4g8mbb_3 -pins "bulk_intercell_n_out[$i]" -location [list [expr {$seq_width + $resource_width + $swb_router_width - $pin_margin - $pin_pitch2 * $i}] [expr {$swb_router_height + $seq_height}] $layer_out_north]
    set_pin_constraint -cell _kmcyy4g8mbb_3 -pins "bulk_intercell_n_in[$i]" -location [list [expr {$seq_width + $resource_width + $swb_router_width - $pin_margin - $pin_pitch1 * $i}] [expr {$swb_router_height + $seq_height}] $layer_in_north]
    set_pin_constraint -cell _kmcyy4g8mbb_3 -pins "bulk_intercell_e_out[$i]" -location [list [expr {$seq_width + $resource_width + $swb_router_width}] [expr {$pin_margin + $pin_pitch1 * $i}] $layer_out_east]
    set_pin_constraint -cell _kmcyy4g8mbb_3 -pins "bulk_intercell_e_in[$i]" -location [list [expr {$seq_width + $resource_width + $swb_router_width}] [expr {$pin_margin + $pin_pitch1 * $i}] $layer_in_east]
    set_pin_constraint -cell _kmcyy4g8mbb_3 -pins "bulk_intercell_s_out[$i]" -location [list [expr {$seq_width + $resource_width + $swb_router_width - $pin_margin - $pin_pitch2 * $i}] 0 $layer_out_south]
    set_pin_constraint -cell _kmcyy4g8mbb_3 -pins "bulk_intercell_s_in[$i]" -location [list [expr {$seq_width + $resource_width + $swb_router_width - $pin_margin - $pin_pitch1 * $i}] 0 $layer_in_south]
    set_pin_constraint -cell _kmcyy4g8mbb_4 -pins "bulk_intercell_w_out[$i]" -location [list 0 [expr {$pin_margin + $pin_pitch1 * $i}] $layer_out_west]
    set_pin_constraint -cell _kmcyy4g8mbb_4 -pins "bulk_intercell_w_in[$i]" -location [list 0 [expr {$pin_margin + $pin_pitch1 * $i}] $layer_in_west]
    set_pin_constraint -cell _kmcyy4g8mbb_4 -pins "bulk_intercell_n_out[$i]" -location [list [expr {$seq_width + $resource_width + $swb_router_width - $pin_margin - $pin_pitch2 * $i}] [expr {$swb_router_height + $seq_height}] $layer_out_north]
    set_pin_constraint -cell _kmcyy4g8mbb_4 -pins "bulk_intercell_n_in[$i]" -location [list [expr {$seq_width + $resource_width + $swb_router_width - $pin_margin - $pin_pitch1 * $i}] [expr {$swb_router_height + $seq_height}] $layer_in_north]
    set_pin_constraint -cell _kmcyy4g8mbb_4 -pins "bulk_intercell_e_out[$i]" -location [list [expr {$seq_width + $resource_width + $swb_router_width}] [expr {$pin_margin + $pin_pitch1 * $i}] $layer_out_east]
    set_pin_constraint -cell _kmcyy4g8mbb_4 -pins "bulk_intercell_e_in[$i]" -location [list [expr {$seq_width + $resource_width + $swb_router_width}] [expr {$pin_margin + $pin_pitch1 * $i}] $layer_in_east]
    set_pin_constraint -cell _kmcyy4g8mbb_4 -pins "bulk_intercell_s_out[$i]" -location [list [expr {$seq_width + $resource_width + $swb_router_width - $pin_margin - $pin_pitch2 * $i}] 0 $layer_out_south]
    set_pin_constraint -cell _kmcyy4g8mbb_4 -pins "bulk_intercell_s_in[$i]" -location [list [expr {$seq_width + $resource_width + $swb_router_width - $pin_margin - $pin_pitch1 * $i}] 0 $layer_in_south]
    set_pin_constraint -cell _kmcyy4g8mbb_5 -pins "bulk_intercell_w_out[$i]" -location [list 0 [expr {$pin_margin + $pin_pitch1 * $i}] $layer_out_west]
    set_pin_constraint -cell _kmcyy4g8mbb_5 -pins "bulk_intercell_w_in[$i]" -location [list 0 [expr {$pin_margin + $pin_pitch1 * $i}] $layer_in_west]
    set_pin_constraint -cell _kmcyy4g8mbb_5 -pins "bulk_intercell_n_out[$i]" -location [list [expr {$seq_width + $resource_width + $swb_router_width - $pin_margin - $pin_pitch2 * $i}] [expr {$swb_router_height + $seq_height}] $layer_out_north]
    set_pin_constraint -cell _kmcyy4g8mbb_5 -pins "bulk_intercell_n_in[$i]" -location [list [expr {$seq_width + $resource_width + $swb_router_width - $pin_margin - $pin_pitch1 * $i}] [expr {$swb_router_height + $seq_height}] $layer_in_north]
    set_pin_constraint -cell _kmcyy4g8mbb_5 -pins "bulk_intercell_e_out[$i]" -location [list [expr {$seq_width + $resource_width + $swb_router_width}] [expr {$pin_margin + $pin_pitch1 * $i}] $layer_out_east]
    set_pin_constraint -cell _kmcyy4g8mbb_5 -pins "bulk_intercell_e_in[$i]" -location [list [expr {$seq_width + $resource_width + $swb_router_width}] [expr {$pin_margin + $pin_pitch1 * $i}] $layer_in_east]
    set_pin_constraint -cell _kmcyy4g8mbb_5 -pins "bulk_intercell_s_out[$i]" -location [list [expr {$seq_width + $resource_width + $swb_router_width - $pin_margin - $pin_pitch2 * $i}] 0 $layer_out_south]
    set_pin_constraint -cell _kmcyy4g8mbb_5 -pins "bulk_intercell_s_in[$i]" -location [list [expr {$seq_width + $resource_width + $swb_router_width - $pin_margin - $pin_pitch1 * $i}] 0 $layer_in_south]
    set_pin_constraint -cell _kmcyy4g8mbb_1 -pins "bulk_intercell_w_out[$i]" -location [list 0 [expr {$pin_margin + $pin_pitch1 * $i}] $layer_out_west]
    set_pin_constraint -cell _kmcyy4g8mbb_1 -pins "bulk_intercell_w_in[$i]" -location [list 0 [expr {$pin_margin + $pin_pitch1 * $i}] $layer_in_west]
    set_pin_constraint -cell _kmcyy4g8mbb_1 -pins "bulk_intercell_n_out[$i]" -location [list [expr {$seq_width + $resource_width + $swb_router_width - $pin_margin - $pin_pitch2 * $i}] [expr {$swb_router_height + $seq_height}] $layer_out_north]
    set_pin_constraint -cell _kmcyy4g8mbb_1 -pins "bulk_intercell_n_in[$i]" -location [list [expr {$seq_width + $resource_width + $swb_router_width - $pin_margin - $pin_pitch1 * $i}] [expr {$swb_router_height + $seq_height}] $layer_in_north]
    set_pin_constraint -cell _kmcyy4g8mbb_1 -pins "bulk_intercell_e_out[$i]" -location [list [expr {$seq_width + $resource_width + $swb_router_width}] [expr {$pin_margin + $pin_pitch1 * $i}] $layer_out_east]
    set_pin_constraint -cell _kmcyy4g8mbb_1 -pins "bulk_intercell_e_in[$i]" -location [list [expr {$seq_width + $resource_width + $swb_router_width}] [expr {$pin_margin + $pin_pitch1 * $i}] $layer_in_east]
    set_pin_constraint -cell _kmcyy4g8mbb_1 -pins "bulk_intercell_s_out[$i]" -location [list [expr {$seq_width + $resource_width + $swb_router_width - $pin_margin - $pin_pitch2 * $i}] 0 $layer_out_south]
    set_pin_constraint -cell _kmcyy4g8mbb_1 -pins "bulk_intercell_s_in[$i]" -location [list [expr {$seq_width + $resource_width + $swb_router_width - $pin_margin - $pin_pitch1 * $i}] 0 $layer_in_south]
    set_pin_constraint -cell _kmcyy4g8mbb_6 -pins "bulk_intercell_w_out[$i]" -location [list 0 [expr {$pin_margin + $pin_pitch1 * $i}] $layer_out_west]
    set_pin_constraint -cell _kmcyy4g8mbb_6 -pins "bulk_intercell_w_in[$i]" -location [list 0 [expr {$pin_margin + $pin_pitch1 * $i}] $layer_in_west]
    set_pin_constraint -cell _kmcyy4g8mbb_6 -pins "bulk_intercell_n_out[$i]" -location [list [expr {$seq_width + $resource_width + $swb_router_width - $pin_margin - $pin_pitch2 * $i}] [expr {$swb_router_height + $seq_height}] $layer_out_north]
    set_pin_constraint -cell _kmcyy4g8mbb_6 -pins "bulk_intercell_n_in[$i]" -location [list [expr {$seq_width + $resource_width + $swb_router_width - $pin_margin - $pin_pitch1 * $i}] [expr {$swb_router_height + $seq_height}] $layer_in_north]
    set_pin_constraint -cell _kmcyy4g8mbb_6 -pins "bulk_intercell_e_out[$i]" -location [list [expr {$seq_width + $resource_width + $swb_router_width}] [expr {$pin_margin + $pin_pitch1 * $i}] $layer_out_east]
    set_pin_constraint -cell _kmcyy4g8mbb_6 -pins "bulk_intercell_e_in[$i]" -location [list [expr {$seq_width + $resource_width + $swb_router_width}] [expr {$pin_margin + $pin_pitch1 * $i}] $layer_in_east]
    set_pin_constraint -cell _kmcyy4g8mbb_6 -pins "bulk_intercell_s_out[$i]" -location [list [expr {$seq_width + $resource_width + $swb_router_width - $pin_margin - $pin_pitch2 * $i}] 0 $layer_out_south]
    set_pin_constraint -cell _kmcyy4g8mbb_6 -pins "bulk_intercell_s_in[$i]" -location [list [expr {$seq_width + $resource_width + $swb_router_width - $pin_margin - $pin_pitch1 * $i}] 0 $layer_in_south]
    set_pin_constraint -cell _kmcyy4g8mbb_2 -pins "bulk_intercell_w_out[$i]" -location [list 0 [expr {$pin_margin + $pin_pitch1 * $i}] $layer_out_west]
    set_pin_constraint -cell _kmcyy4g8mbb_2 -pins "bulk_intercell_w_in[$i]" -location [list 0 [expr {$pin_margin + $pin_pitch1 * $i}] $layer_in_west]
    set_pin_constraint -cell _kmcyy4g8mbb_2 -pins "bulk_intercell_n_out[$i]" -location [list [expr {$seq_width + $resource_width + $swb_router_width - $pin_margin - $pin_pitch2 * $i}] [expr {$swb_router_height + $seq_height}] $layer_out_north]
    set_pin_constraint -cell _kmcyy4g8mbb_2 -pins "bulk_intercell_n_in[$i]" -location [list [expr {$seq_width + $resource_width + $swb_router_width - $pin_margin - $pin_pitch1 * $i}] [expr {$swb_router_height + $seq_height}] $layer_in_north]
    set_pin_constraint -cell _kmcyy4g8mbb_2 -pins "bulk_intercell_e_out[$i]" -location [list [expr {$seq_width + $resource_width + $swb_router_width}] [expr {$pin_margin + $pin_pitch1 * $i}] $layer_out_east]
    set_pin_constraint -cell _kmcyy4g8mbb_2 -pins "bulk_intercell_e_in[$i]" -location [list [expr {$seq_width + $resource_width + $swb_router_width}] [expr {$pin_margin + $pin_pitch1 * $i}] $layer_in_east]
    set_pin_constraint -cell _kmcyy4g8mbb_2 -pins "bulk_intercell_s_out[$i]" -location [list [expr {$seq_width + $resource_width + $swb_router_width - $pin_margin - $pin_pitch2 * $i}] 0 $layer_out_south]
    set_pin_constraint -cell _kmcyy4g8mbb_2 -pins "bulk_intercell_s_in[$i]" -location [list [expr {$seq_width + $resource_width + $swb_router_width - $pin_margin - $pin_pitch1 * $i}] 0 $layer_in_south]
    set_pin_constraint -cell _kmcyy4g8mbb_7 -pins "bulk_intercell_w_out[$i]" -location [list 0 [expr {$pin_margin + $pin_pitch1 * $i}] $layer_out_west]
    set_pin_constraint -cell _kmcyy4g8mbb_7 -pins "bulk_intercell_w_in[$i]" -location [list 0 [expr {$pin_margin + $pin_pitch1 * $i}] $layer_in_west]
    set_pin_constraint -cell _kmcyy4g8mbb_7 -pins "bulk_intercell_n_out[$i]" -location [list [expr {$seq_width + $resource_width + $swb_router_width - $pin_margin - $pin_pitch2 * $i}] [expr {$swb_router_height + $seq_height}] $layer_out_north]
    set_pin_constraint -cell _kmcyy4g8mbb_7 -pins "bulk_intercell_n_in[$i]" -location [list [expr {$seq_width + $resource_width + $swb_router_width - $pin_margin - $pin_pitch1 * $i}] [expr {$swb_router_height + $seq_height}] $layer_in_north]
    set_pin_constraint -cell _kmcyy4g8mbb_7 -pins "bulk_intercell_e_out[$i]" -location [list [expr {$seq_width + $resource_width + $swb_router_width}] [expr {$pin_margin + $pin_pitch1 * $i}] $layer_out_east]
    set_pin_constraint -cell _kmcyy4g8mbb_7 -pins "bulk_intercell_e_in[$i]" -location [list [expr {$seq_width + $resource_width + $swb_router_width}] [expr {$pin_margin + $pin_pitch1 * $i}] $layer_in_east]
    set_pin_constraint -cell _kmcyy4g8mbb_7 -pins "bulk_intercell_s_out[$i]" -location [list [expr {$seq_width + $resource_width + $swb_router_width - $pin_margin - $pin_pitch2 * $i}] 0 $layer_out_south]
    set_pin_constraint -cell _kmcyy4g8mbb_7 -pins "bulk_intercell_s_in[$i]" -location [list [expr {$seq_width + $resource_width + $swb_router_width - $pin_margin - $pin_pitch1 * $i}] 0 $layer_in_south]
    set_pin_constraint -cell _kmcyy4g8mbb_8 -pins "bulk_intercell_w_out[$i]" -location [list 0 [expr {$pin_margin + $pin_pitch1 * $i}] $layer_out_west]
    set_pin_constraint -cell _kmcyy4g8mbb_8 -pins "bulk_intercell_w_in[$i]" -location [list 0 [expr {$pin_margin + $pin_pitch1 * $i}] $layer_in_west]
    set_pin_constraint -cell _kmcyy4g8mbb_8 -pins "bulk_intercell_n_out[$i]" -location [list [expr {$seq_width + $resource_width + $swb_router_width - $pin_margin - $pin_pitch2 * $i}] [expr {$swb_router_height + $seq_height}] $layer_out_north]
    set_pin_constraint -cell _kmcyy4g8mbb_8 -pins "bulk_intercell_n_in[$i]" -location [list [expr {$seq_width + $resource_width + $swb_router_width - $pin_margin - $pin_pitch1 * $i}] [expr {$swb_router_height + $seq_height}] $layer_in_north]
    set_pin_constraint -cell _kmcyy4g8mbb_8 -pins "bulk_intercell_e_out[$i]" -location [list [expr {$seq_width + $resource_width + $swb_router_width}] [expr {$pin_margin + $pin_pitch1 * $i}] $layer_out_east]
    set_pin_constraint -cell _kmcyy4g8mbb_8 -pins "bulk_intercell_e_in[$i]" -location [list [expr {$seq_width + $resource_width + $swb_router_width}] [expr {$pin_margin + $pin_pitch1 * $i}] $layer_in_east]
    set_pin_constraint -cell _kmcyy4g8mbb_8 -pins "bulk_intercell_s_out[$i]" -location [list [expr {$seq_width + $resource_width + $swb_router_width - $pin_margin - $pin_pitch2 * $i}] 0 $layer_out_south]
    set_pin_constraint -cell _kmcyy4g8mbb_8 -pins "bulk_intercell_s_in[$i]" -location [list [expr {$seq_width + $resource_width + $swb_router_width - $pin_margin - $pin_pitch1 * $i}] 0 $layer_in_south]
}

#constraints for intracell connections for switchbox/router partition
for {set z 0} {$z < 15} {incr z} {
    for {set i 0} {$i < $bulk_bitwidth} {incr i} {
    set_pin_constraint -cell _kmcyy4g8mbb -pins "bulk_intracell_out[[expr {$z + 1}]][$i]" -location [list [expr {$seq_width + $resource_width}] [expr {$swb_router_height + $resource_height * $z + $pin_margin + $pin_pitch1 * $i}] $layer_bulk_intracell_out]
    set_pin_constraint -cell _kmcyy4g8mbb -pins "bulk_intracell_in[[expr {$z + 1}]][$i]" -location [list [expr {$seq_width + $resource_width}] [expr {$swb_router_height + $resource_height * $z + $pin_margin + $pin_pitch1 * $i}] $layer_bulk_intracell_in]
    set_pin_constraint -cell _kmcyy4g8mbb_3 -pins "bulk_intracell_out[[expr {$z + 1}]][$i]" -location [list [expr {$seq_width + $resource_width}] [expr {$swb_router_height + $resource_height * $z + $pin_margin + $pin_pitch1 * $i}] $layer_bulk_intracell_out]
    set_pin_constraint -cell _kmcyy4g8mbb_3 -pins "bulk_intracell_in[[expr {$z + 1}]][$i]" -location [list [expr {$seq_width + $resource_width}] [expr {$swb_router_height + $resource_height * $z + $pin_margin + $pin_pitch1 * $i}] $layer_bulk_intracell_in]
    set_pin_constraint -cell _kmcyy4g8mbb_4 -pins "bulk_intracell_out[[expr {$z + 1}]][$i]" -location [list [expr {$seq_width + $resource_width}] [expr {$swb_router_height + $resource_height * $z + $pin_margin + $pin_pitch1 * $i}] $layer_bulk_intracell_out]
    set_pin_constraint -cell _kmcyy4g8mbb_4 -pins "bulk_intracell_in[[expr {$z + 1}]][$i]" -location [list [expr {$seq_width + $resource_width}] [expr {$swb_router_height + $resource_height * $z + $pin_margin + $pin_pitch1 * $i}] $layer_bulk_intracell_in]
    set_pin_constraint -cell _kmcyy4g8mbb_5 -pins "bulk_intracell_out[[expr {$z + 1}]][$i]" -location [list [expr {$seq_width + $resource_width}] [expr {$swb_router_height + $resource_height * $z + $pin_margin + $pin_pitch1 * $i}] $layer_bulk_intracell_out]
    set_pin_constraint -cell _kmcyy4g8mbb_5 -pins "bulk_intracell_in[[expr {$z + 1}]][$i]" -location [list [expr {$seq_width + $resource_width}] [expr {$swb_router_height + $resource_height * $z + $pin_margin + $pin_pitch1 * $i}] $layer_bulk_intracell_in]
    set_pin_constraint -cell _kmcyy4g8mbb_1 -pins "bulk_intracell_out[[expr {$z + 1}]][$i]" -location [list [expr {$seq_width + $resource_width}] [expr {$swb_router_height + $resource_height * $z + $pin_margin + $pin_pitch1 * $i}] $layer_bulk_intracell_out]
    set_pin_constraint -cell _kmcyy4g8mbb_1 -pins "bulk_intracell_in[[expr {$z + 1}]][$i]" -location [list [expr {$seq_width + $resource_width}] [expr {$swb_router_height + $resource_height * $z + $pin_margin + $pin_pitch1 * $i}] $layer_bulk_intracell_in]
    set_pin_constraint -cell _kmcyy4g8mbb_6 -pins "bulk_intracell_out[[expr {$z + 1}]][$i]" -location [list [expr {$seq_width + $resource_width}] [expr {$swb_router_height + $resource_height * $z + $pin_margin + $pin_pitch1 * $i}] $layer_bulk_intracell_out]
    set_pin_constraint -cell _kmcyy4g8mbb_6 -pins "bulk_intracell_in[[expr {$z + 1}]][$i]" -location [list [expr {$seq_width + $resource_width}] [expr {$swb_router_height + $resource_height * $z + $pin_margin + $pin_pitch1 * $i}] $layer_bulk_intracell_in]
    set_pin_constraint -cell _kmcyy4g8mbb_2 -pins "bulk_intracell_out[[expr {$z + 1}]][$i]" -location [list [expr {$seq_width + $resource_width}] [expr {$swb_router_height + $resource_height * $z + $pin_margin + $pin_pitch1 * $i}] $layer_bulk_intracell_out]
    set_pin_constraint -cell _kmcyy4g8mbb_2 -pins "bulk_intracell_in[[expr {$z + 1}]][$i]" -location [list [expr {$seq_width + $resource_width}] [expr {$swb_router_height + $resource_height * $z + $pin_margin + $pin_pitch1 * $i}] $layer_bulk_intracell_in]
    set_pin_constraint -cell _kmcyy4g8mbb_7 -pins "bulk_intracell_out[[expr {$z + 1}]][$i]" -location [list [expr {$seq_width + $resource_width}] [expr {$swb_router_height + $resource_height * $z + $pin_margin + $pin_pitch1 * $i}] $layer_bulk_intracell_out]
    set_pin_constraint -cell _kmcyy4g8mbb_7 -pins "bulk_intracell_in[[expr {$z + 1}]][$i]" -location [list [expr {$seq_width + $resource_width}] [expr {$swb_router_height + $resource_height * $z + $pin_margin + $pin_pitch1 * $i}] $layer_bulk_intracell_in]
    set_pin_constraint -cell _kmcyy4g8mbb_8 -pins "bulk_intracell_out[[expr {$z + 1}]][$i]" -location [list [expr {$seq_width + $resource_width}] [expr {$swb_router_height + $resource_height * $z + $pin_margin + $pin_pitch1 * $i}] $layer_bulk_intracell_out]
    set_pin_constraint -cell _kmcyy4g8mbb_8 -pins "bulk_intracell_in[[expr {$z + 1}]][$i]" -location [list [expr {$seq_width + $resource_width}] [expr {$swb_router_height + $resource_height * $z + $pin_margin + $pin_pitch1 * $i}] $layer_bulk_intracell_in]
    }
}

for {set z 0} {$z < 15} {incr z} {
    for {set i 0} {$i < 16} {incr i} {
    set_pin_constraint -cell _kmcyy4g8mbb -pins "word_channels_out[[expr {$z + 1}]][$i]" -location [list [expr {$seq_width + $resource_width}] [expr {$swb_router_height + $resource_height * $z + $pin_margin + $pin_pitch3 * $i}] $layer_word]
    set_pin_constraint -cell _kmcyy4g8mbb -pins "word_channels_in[[expr {$z + 1}]][$i]" -location [list [expr {$seq_width + $resource_width}] [expr {$swb_router_height + $resource_height * $z + $pin_margin + $pin_pitch3 * (16 + $i)}] $layer_word]
    set_pin_constraint -cell _kmcyy4g8mbb_3 -pins "word_channels_out[[expr {$z + 1}]][$i]" -location [list [expr {$seq_width + $resource_width}] [expr {$swb_router_height + $resource_height * $z + $pin_margin + $pin_pitch3 * $i}] $layer_word]
    set_pin_constraint -cell _kmcyy4g8mbb_3 -pins "word_channels_in[[expr {$z + 1}]][$i]" -location [list [expr {$seq_width + $resource_width}] [expr {$swb_router_height + $resource_height * $z + $pin_margin + $pin_pitch3 * (16 + $i)}] $layer_word]
    set_pin_constraint -cell _kmcyy4g8mbb_4 -pins "word_channels_out[[expr {$z + 1}]][$i]" -location [list [expr {$seq_width + $resource_width}] [expr {$swb_router_height + $resource_height * $z + $pin_margin + $pin_pitch3 * $i}] $layer_word]
    set_pin_constraint -cell _kmcyy4g8mbb_4 -pins "word_channels_in[[expr {$z + 1}]][$i]" -location [list [expr {$seq_width + $resource_width}] [expr {$swb_router_height + $resource_height * $z + $pin_margin + $pin_pitch3 * (16 + $i)}] $layer_word]
    set_pin_constraint -cell _kmcyy4g8mbb_5 -pins "word_channels_out[[expr {$z + 1}]][$i]" -location [list [expr {$seq_width + $resource_width}] [expr {$swb_router_height + $resource_height * $z + $pin_margin + $pin_pitch3 * $i}] $layer_word]
    set_pin_constraint -cell _kmcyy4g8mbb_5 -pins "word_channels_in[[expr {$z + 1}]][$i]" -location [list [expr {$seq_width + $resource_width}] [expr {$swb_router_height + $resource_height * $z + $pin_margin + $pin_pitch3 * (16 + $i)}] $layer_word]
    set_pin_constraint -cell _kmcyy4g8mbb_1 -pins "word_channels_out[[expr {$z + 1}]][$i]" -location [list [expr {$seq_width + $resource_width}] [expr {$swb_router_height + $resource_height * $z + $pin_margin + $pin_pitch3 * $i}] $layer_word]
    set_pin_constraint -cell _kmcyy4g8mbb_1 -pins "word_channels_in[[expr {$z + 1}]][$i]" -location [list [expr {$seq_width + $resource_width}] [expr {$swb_router_height + $resource_height * $z + $pin_margin + $pin_pitch3 * (16 + $i)}] $layer_word]
    set_pin_constraint -cell _kmcyy4g8mbb_6 -pins "word_channels_out[[expr {$z + 1}]][$i]" -location [list [expr {$seq_width + $resource_width}] [expr {$swb_router_height + $resource_height * $z + $pin_margin + $pin_pitch3 * $i}] $layer_word]
    set_pin_constraint -cell _kmcyy4g8mbb_6 -pins "word_channels_in[[expr {$z + 1}]][$i]" -location [list [expr {$seq_width + $resource_width}] [expr {$swb_router_height + $resource_height * $z + $pin_margin + $pin_pitch3 * (16 + $i)}] $layer_word]
    set_pin_constraint -cell _kmcyy4g8mbb_2 -pins "word_channels_out[[expr {$z + 1}]][$i]" -location [list [expr {$seq_width + $resource_width}] [expr {$swb_router_height + $resource_height * $z + $pin_margin + $pin_pitch3 * $i}] $layer_word]
    set_pin_constraint -cell _kmcyy4g8mbb_2 -pins "word_channels_in[[expr {$z + 1}]][$i]" -location [list [expr {$seq_width + $resource_width}] [expr {$swb_router_height + $resource_height * $z + $pin_margin + $pin_pitch3 * (16 + $i)}] $layer_word]
    set_pin_constraint -cell _kmcyy4g8mbb_7 -pins "word_channels_out[[expr {$z + 1}]][$i]" -location [list [expr {$seq_width + $resource_width}] [expr {$swb_router_height + $resource_height * $z + $pin_margin + $pin_pitch3 * $i}] $layer_word]
    set_pin_constraint -cell _kmcyy4g8mbb_7 -pins "word_channels_in[[expr {$z + 1}]][$i]" -location [list [expr {$seq_width + $resource_width}] [expr {$swb_router_height + $resource_height * $z + $pin_margin + $pin_pitch3 * (16 + $i)}] $layer_word]
    set_pin_constraint -cell _kmcyy4g8mbb_8 -pins "word_channels_out[[expr {$z + 1}]][$i]" -location [list [expr {$seq_width + $resource_width}] [expr {$swb_router_height + $resource_height * $z + $pin_margin + $pin_pitch3 * $i}] $layer_word]
    set_pin_constraint -cell _kmcyy4g8mbb_8 -pins "word_channels_in[[expr {$z + 1}]][$i]" -location [list [expr {$seq_width + $resource_width}] [expr {$swb_router_height + $resource_height * $z + $pin_margin + $pin_pitch3 * (16 + $i)}] $layer_word]
    }
}

