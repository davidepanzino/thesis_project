# Define pins constraints variables
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
set layer_word_out M3
set layer_word_in M5
set pin_margin 1.5
set pin_pitch1 0.28
set pin_pitch2 0.2
set pin_pitch3 0.4

#constraints for N,S,W,E pins for switchbox/router partition
for {set i 0} {$i < $bulk_bitwidth} {incr i} {
    set_pin_constraint -cell _kmcyy4g8mbb -pins "bulk_intercell_w_out[$i]" -location [list 0 [expr {$pin_margin + $pin_pitch2 * $i}] $layer_out_west]
    set_pin_constraint -cell _kmcyy4g8mbb -pins "bulk_intercell_w_in[$i]" -location [list 0 [expr {$pin_margin + $pin_pitch2 * $i}] $layer_in_west]
    set_pin_constraint -cell _kmcyy4g8mbb -pins "bulk_intercell_n_out[$i]" -location [list [expr {$seq_width + $resource_width + $swb_router_width - $pin_margin - $pin_pitch2 * $i}] [expr {$swb_router_height + $seq_height}] $layer_out_north]
    set_pin_constraint -cell _kmcyy4g8mbb -pins "bulk_intercell_n_in[$i]" -location [list [expr {$seq_width + $resource_width + $swb_router_width - $pin_margin - $pin_pitch1 * $i}] [expr {$swb_router_height + $seq_height}] $layer_in_north]
    set_pin_constraint -cell _kmcyy4g8mbb -pins "bulk_intercell_e_out[$i]" -location [list [expr {$seq_width + $resource_width + $swb_router_width}] [expr {$pin_margin + $pin_pitch2 * $i}] $layer_out_east]
    set_pin_constraint -cell _kmcyy4g8mbb -pins "bulk_intercell_e_in[$i]" -location [list [expr {$seq_width + $resource_width + $swb_router_width}] [expr {$pin_margin + $pin_pitch2 * $i}] $layer_in_east]
    set_pin_constraint -cell _kmcyy4g8mbb -pins "bulk_intercell_s_out[$i]" -location [list [expr {$seq_width + $resource_width + $swb_router_width - $pin_margin - $pin_pitch1 * $i}] 0 $layer_out_south]
    set_pin_constraint -cell _kmcyy4g8mbb -pins "bulk_intercell_s_in[$i]" -location [list [expr {$seq_width + $resource_width + $swb_router_width - $pin_margin - $pin_pitch2 * $i}] 0 $layer_in_south]
    set_pin_constraint -cell _kmcyy4g8mbb_3 -pins "bulk_intercell_w_out[$i]" -location [list 0 [expr {$pin_margin + $pin_pitch2 * $i}] $layer_out_west]
    set_pin_constraint -cell _kmcyy4g8mbb_3 -pins "bulk_intercell_w_in[$i]" -location [list 0 [expr {$pin_margin + $pin_pitch2 * $i}] $layer_in_west]
    set_pin_constraint -cell _kmcyy4g8mbb_3 -pins "bulk_intercell_n_out[$i]" -location [list [expr {$seq_width + $resource_width + $swb_router_width - $pin_margin - $pin_pitch2 * $i}] [expr {$swb_router_height + $seq_height}] $layer_out_north]
    set_pin_constraint -cell _kmcyy4g8mbb_3 -pins "bulk_intercell_n_in[$i]" -location [list [expr {$seq_width + $resource_width + $swb_router_width - $pin_margin - $pin_pitch1 * $i}] [expr {$swb_router_height + $seq_height}] $layer_in_north]
    set_pin_constraint -cell _kmcyy4g8mbb_3 -pins "bulk_intercell_e_out[$i]" -location [list [expr {$seq_width + $resource_width + $swb_router_width}] [expr {$pin_margin + $pin_pitch2 * $i}] $layer_out_east]
    set_pin_constraint -cell _kmcyy4g8mbb_3 -pins "bulk_intercell_e_in[$i]" -location [list [expr {$seq_width + $resource_width + $swb_router_width}] [expr {$pin_margin + $pin_pitch2 * $i}] $layer_in_east]
    set_pin_constraint -cell _kmcyy4g8mbb_3 -pins "bulk_intercell_s_out[$i]" -location [list [expr {$seq_width + $resource_width + $swb_router_width - $pin_margin - $pin_pitch1 * $i}] 0 $layer_out_south]
    set_pin_constraint -cell _kmcyy4g8mbb_3 -pins "bulk_intercell_s_in[$i]" -location [list [expr {$seq_width + $resource_width + $swb_router_width - $pin_margin - $pin_pitch2 * $i}] 0 $layer_in_south]
    set_pin_constraint -cell _kmcyy4g8mbb_4 -pins "bulk_intercell_w_out[$i]" -location [list 0 [expr {$pin_margin + $pin_pitch2 * $i}] $layer_out_west]
    set_pin_constraint -cell _kmcyy4g8mbb_4 -pins "bulk_intercell_w_in[$i]" -location [list 0 [expr {$pin_margin + $pin_pitch2 * $i}] $layer_in_west]
    set_pin_constraint -cell _kmcyy4g8mbb_4 -pins "bulk_intercell_n_out[$i]" -location [list [expr {$seq_width + $resource_width + $swb_router_width - $pin_margin - $pin_pitch2 * $i}] [expr {$swb_router_height + $seq_height}] $layer_out_north]
    set_pin_constraint -cell _kmcyy4g8mbb_4 -pins "bulk_intercell_n_in[$i]" -location [list [expr {$seq_width + $resource_width + $swb_router_width - $pin_margin - $pin_pitch1 * $i}] [expr {$swb_router_height + $seq_height}] $layer_in_north]
    set_pin_constraint -cell _kmcyy4g8mbb_4 -pins "bulk_intercell_e_out[$i]" -location [list [expr {$seq_width + $resource_width + $swb_router_width}] [expr {$pin_margin + $pin_pitch2 * $i}] $layer_out_east]
    set_pin_constraint -cell _kmcyy4g8mbb_4 -pins "bulk_intercell_e_in[$i]" -location [list [expr {$seq_width + $resource_width + $swb_router_width}] [expr {$pin_margin + $pin_pitch2 * $i}] $layer_in_east]
    set_pin_constraint -cell _kmcyy4g8mbb_4 -pins "bulk_intercell_s_out[$i]" -location [list [expr {$seq_width + $resource_width + $swb_router_width - $pin_margin - $pin_pitch1 * $i}] 0 $layer_out_south]
    set_pin_constraint -cell _kmcyy4g8mbb_4 -pins "bulk_intercell_s_in[$i]" -location [list [expr {$seq_width + $resource_width + $swb_router_width - $pin_margin - $pin_pitch2 * $i}] 0 $layer_in_south]
    set_pin_constraint -cell _kmcyy4g8mbb_5 -pins "bulk_intercell_w_out[$i]" -location [list 0 [expr {$pin_margin + $pin_pitch2 * $i}] $layer_out_west]
    set_pin_constraint -cell _kmcyy4g8mbb_5 -pins "bulk_intercell_w_in[$i]" -location [list 0 [expr {$pin_margin + $pin_pitch2 * $i}] $layer_in_west]
    set_pin_constraint -cell _kmcyy4g8mbb_5 -pins "bulk_intercell_n_out[$i]" -location [list [expr {$seq_width + $resource_width + $swb_router_width - $pin_margin - $pin_pitch2 * $i}] [expr {$swb_router_height + $seq_height}] $layer_out_north]
    set_pin_constraint -cell _kmcyy4g8mbb_5 -pins "bulk_intercell_n_in[$i]" -location [list [expr {$seq_width + $resource_width + $swb_router_width - $pin_margin - $pin_pitch1 * $i}] [expr {$swb_router_height + $seq_height}] $layer_in_north]
    set_pin_constraint -cell _kmcyy4g8mbb_5 -pins "bulk_intercell_e_out[$i]" -location [list [expr {$seq_width + $resource_width + $swb_router_width}] [expr {$pin_margin + $pin_pitch2 * $i}] $layer_out_east]
    set_pin_constraint -cell _kmcyy4g8mbb_5 -pins "bulk_intercell_e_in[$i]" -location [list [expr {$seq_width + $resource_width + $swb_router_width}] [expr {$pin_margin + $pin_pitch2 * $i}] $layer_in_east]
    set_pin_constraint -cell _kmcyy4g8mbb_5 -pins "bulk_intercell_s_out[$i]" -location [list [expr {$seq_width + $resource_width + $swb_router_width - $pin_margin - $pin_pitch1 * $i}] 0 $layer_out_south]
    set_pin_constraint -cell _kmcyy4g8mbb_5 -pins "bulk_intercell_s_in[$i]" -location [list [expr {$seq_width + $resource_width + $swb_router_width - $pin_margin - $pin_pitch2 * $i}] 0 $layer_in_south]
    set_pin_constraint -cell _kmcyy4g8mbb_1 -pins "bulk_intercell_w_out[$i]" -location [list 0 [expr {$pin_margin + $pin_pitch2 * $i}] $layer_out_west]
    set_pin_constraint -cell _kmcyy4g8mbb_1 -pins "bulk_intercell_w_in[$i]" -location [list 0 [expr {$pin_margin + $pin_pitch2 * $i}] $layer_in_west]
    set_pin_constraint -cell _kmcyy4g8mbb_1 -pins "bulk_intercell_n_out[$i]" -location [list [expr {$seq_width + $resource_width + $swb_router_width - $pin_margin - $pin_pitch2 * $i}] [expr {$swb_router_height + $seq_height}] $layer_out_north]
    set_pin_constraint -cell _kmcyy4g8mbb_1 -pins "bulk_intercell_n_in[$i]" -location [list [expr {$seq_width + $resource_width + $swb_router_width - $pin_margin - $pin_pitch1 * $i}] [expr {$swb_router_height + $seq_height}] $layer_in_north]
    set_pin_constraint -cell _kmcyy4g8mbb_1 -pins "bulk_intercell_e_out[$i]" -location [list [expr {$seq_width + $resource_width + $swb_router_width}] [expr {$pin_margin + $pin_pitch2 * $i}] $layer_out_east]
    set_pin_constraint -cell _kmcyy4g8mbb_1 -pins "bulk_intercell_e_in[$i]" -location [list [expr {$seq_width + $resource_width + $swb_router_width}] [expr {$pin_margin + $pin_pitch2 * $i}] $layer_in_east]
    set_pin_constraint -cell _kmcyy4g8mbb_1 -pins "bulk_intercell_s_out[$i]" -location [list [expr {$seq_width + $resource_width + $swb_router_width - $pin_margin - $pin_pitch1 * $i}] 0 $layer_out_south]
    set_pin_constraint -cell _kmcyy4g8mbb_1 -pins "bulk_intercell_s_in[$i]" -location [list [expr {$seq_width + $resource_width + $swb_router_width - $pin_margin - $pin_pitch2 * $i}] 0 $layer_in_south]
    set_pin_constraint -cell _kmcyy4g8mbb_6 -pins "bulk_intercell_w_out[$i]" -location [list 0 [expr {$pin_margin + $pin_pitch2 * $i}] $layer_out_west]
    set_pin_constraint -cell _kmcyy4g8mbb_6 -pins "bulk_intercell_w_in[$i]" -location [list 0 [expr {$pin_margin + $pin_pitch2 * $i}] $layer_in_west]
    set_pin_constraint -cell _kmcyy4g8mbb_6 -pins "bulk_intercell_n_out[$i]" -location [list [expr {$seq_width + $resource_width + $swb_router_width - $pin_margin - $pin_pitch2 * $i}] [expr {$swb_router_height + $seq_height}] $layer_out_north]
    set_pin_constraint -cell _kmcyy4g8mbb_6 -pins "bulk_intercell_n_in[$i]" -location [list [expr {$seq_width + $resource_width + $swb_router_width - $pin_margin - $pin_pitch1 * $i}] [expr {$swb_router_height + $seq_height}] $layer_in_north]
    set_pin_constraint -cell _kmcyy4g8mbb_6 -pins "bulk_intercell_e_out[$i]" -location [list [expr {$seq_width + $resource_width + $swb_router_width}] [expr {$pin_margin + $pin_pitch2 * $i}] $layer_out_east]
    set_pin_constraint -cell _kmcyy4g8mbb_6 -pins "bulk_intercell_e_in[$i]" -location [list [expr {$seq_width + $resource_width + $swb_router_width}] [expr {$pin_margin + $pin_pitch2 * $i}] $layer_in_east]
    set_pin_constraint -cell _kmcyy4g8mbb_6 -pins "bulk_intercell_s_out[$i]" -location [list [expr {$seq_width + $resource_width + $swb_router_width - $pin_margin - $pin_pitch1 * $i}] 0 $layer_out_south]
    set_pin_constraint -cell _kmcyy4g8mbb_6 -pins "bulk_intercell_s_in[$i]" -location [list [expr {$seq_width + $resource_width + $swb_router_width - $pin_margin - $pin_pitch2 * $i}] 0 $layer_in_south]
    set_pin_constraint -cell _kmcyy4g8mbb_2 -pins "bulk_intercell_w_out[$i]" -location [list 0 [expr {$pin_margin + $pin_pitch2 * $i}] $layer_out_west]
    set_pin_constraint -cell _kmcyy4g8mbb_2 -pins "bulk_intercell_w_in[$i]" -location [list 0 [expr {$pin_margin + $pin_pitch2 * $i}] $layer_in_west]
    set_pin_constraint -cell _kmcyy4g8mbb_2 -pins "bulk_intercell_n_out[$i]" -location [list [expr {$seq_width + $resource_width + $swb_router_width - $pin_margin - $pin_pitch2 * $i}] [expr {$swb_router_height + $seq_height}] $layer_out_north]
    set_pin_constraint -cell _kmcyy4g8mbb_2 -pins "bulk_intercell_n_in[$i]" -location [list [expr {$seq_width + $resource_width + $swb_router_width - $pin_margin - $pin_pitch1 * $i}] [expr {$swb_router_height + $seq_height}] $layer_in_north]
    set_pin_constraint -cell _kmcyy4g8mbb_2 -pins "bulk_intercell_e_out[$i]" -location [list [expr {$seq_width + $resource_width + $swb_router_width}] [expr {$pin_margin + $pin_pitch2 * $i}] $layer_out_east]
    set_pin_constraint -cell _kmcyy4g8mbb_2 -pins "bulk_intercell_e_in[$i]" -location [list [expr {$seq_width + $resource_width + $swb_router_width}] [expr {$pin_margin + $pin_pitch2 * $i}] $layer_in_east]
    set_pin_constraint -cell _kmcyy4g8mbb_2 -pins "bulk_intercell_s_out[$i]" -location [list [expr {$seq_width + $resource_width + $swb_router_width - $pin_margin - $pin_pitch1 * $i}] 0 $layer_out_south]
    set_pin_constraint -cell _kmcyy4g8mbb_2 -pins "bulk_intercell_s_in[$i]" -location [list [expr {$seq_width + $resource_width + $swb_router_width - $pin_margin - $pin_pitch2 * $i}] 0 $layer_in_south]
    set_pin_constraint -cell _kmcyy4g8mbb_7 -pins "bulk_intercell_w_out[$i]" -location [list 0 [expr {$pin_margin + $pin_pitch2 * $i}] $layer_out_west]
    set_pin_constraint -cell _kmcyy4g8mbb_7 -pins "bulk_intercell_w_in[$i]" -location [list 0 [expr {$pin_margin + $pin_pitch2 * $i}] $layer_in_west]
    set_pin_constraint -cell _kmcyy4g8mbb_7 -pins "bulk_intercell_n_out[$i]" -location [list [expr {$seq_width + $resource_width + $swb_router_width - $pin_margin - $pin_pitch2 * $i}] [expr {$swb_router_height + $seq_height}] $layer_out_north]
    set_pin_constraint -cell _kmcyy4g8mbb_7 -pins "bulk_intercell_n_in[$i]" -location [list [expr {$seq_width + $resource_width + $swb_router_width - $pin_margin - $pin_pitch1 * $i}] [expr {$swb_router_height + $seq_height}] $layer_in_north]
    set_pin_constraint -cell _kmcyy4g8mbb_7 -pins "bulk_intercell_e_out[$i]" -location [list [expr {$seq_width + $resource_width + $swb_router_width}] [expr {$pin_margin + $pin_pitch2 * $i}] $layer_out_east]
    set_pin_constraint -cell _kmcyy4g8mbb_7 -pins "bulk_intercell_e_in[$i]" -location [list [expr {$seq_width + $resource_width + $swb_router_width}] [expr {$pin_margin + $pin_pitch2 * $i}] $layer_in_east]
    set_pin_constraint -cell _kmcyy4g8mbb_7 -pins "bulk_intercell_s_out[$i]" -location [list [expr {$seq_width + $resource_width + $swb_router_width - $pin_margin - $pin_pitch1 * $i}] 0 $layer_out_south]
    set_pin_constraint -cell _kmcyy4g8mbb_7 -pins "bulk_intercell_s_in[$i]" -location [list [expr {$seq_width + $resource_width + $swb_router_width - $pin_margin - $pin_pitch2 * $i}] 0 $layer_in_south]
    set_pin_constraint -cell _kmcyy4g8mbb_8 -pins "bulk_intercell_w_out[$i]" -location [list 0 [expr {$pin_margin + $pin_pitch2 * $i}] $layer_out_west]
    set_pin_constraint -cell _kmcyy4g8mbb_8 -pins "bulk_intercell_w_in[$i]" -location [list 0 [expr {$pin_margin + $pin_pitch2 * $i}] $layer_in_west]
    set_pin_constraint -cell _kmcyy4g8mbb_8 -pins "bulk_intercell_n_out[$i]" -location [list [expr {$seq_width + $resource_width + $swb_router_width - $pin_margin - $pin_pitch2 * $i}] [expr {$swb_router_height + $seq_height}] $layer_out_north]
    set_pin_constraint -cell _kmcyy4g8mbb_8 -pins "bulk_intercell_n_in[$i]" -location [list [expr {$seq_width + $resource_width + $swb_router_width - $pin_margin - $pin_pitch1 * $i}] [expr {$swb_router_height + $seq_height}] $layer_in_north]
    set_pin_constraint -cell _kmcyy4g8mbb_8 -pins "bulk_intercell_e_out[$i]" -location [list [expr {$seq_width + $resource_width + $swb_router_width}] [expr {$pin_margin + $pin_pitch2 * $i}] $layer_out_east]
    set_pin_constraint -cell _kmcyy4g8mbb_8 -pins "bulk_intercell_e_in[$i]" -location [list [expr {$seq_width + $resource_width + $swb_router_width}] [expr {$pin_margin + $pin_pitch2 * $i}] $layer_in_east]
    set_pin_constraint -cell _kmcyy4g8mbb_8 -pins "bulk_intercell_s_out[$i]" -location [list [expr {$seq_width + $resource_width + $swb_router_width - $pin_margin - $pin_pitch1 * $i}] 0 $layer_out_south]
    set_pin_constraint -cell _kmcyy4g8mbb_8 -pins "bulk_intercell_s_in[$i]" -location [list [expr {$seq_width + $resource_width + $swb_router_width - $pin_margin - $pin_pitch2 * $i}] 0 $layer_in_south]
}



#constraints for intracell connections for switchbox/router partition (between switchbox/router and resources' slots)
for {set z 0} {$z < 15} {incr z} {
    for {set i 0} {$i < $bulk_bitwidth} {incr i} {
    set_pin_constraint -cell _kmcyy4g8mbb -pins "bulk_intracell_out[[expr {$z + 1}]][$i]" -location [list [expr {$seq_width + $resource_width}] [expr {$swb_router_height + $resource_height * $z + $pin_margin + $pin_pitch2 * $i}] $layer_bulk_intracell_out]
    set_pin_constraint -cell _kmcyy4g8mbb -pins "bulk_intracell_in[[expr {$z + 1}]][$i]" -location [list [expr {$seq_width + $resource_width}] [expr {$swb_router_height + $resource_height * $z + $pin_margin + $pin_pitch2 * $i}] $layer_bulk_intracell_in]
    set_pin_constraint -cell _kmcyy4g8mbb_3 -pins "bulk_intracell_out[[expr {$z + 1}]][$i]" -location [list [expr {$seq_width + $resource_width}] [expr {$swb_router_height + $resource_height * $z + $pin_margin + $pin_pitch2 * $i}] $layer_bulk_intracell_out]
    set_pin_constraint -cell _kmcyy4g8mbb_3 -pins "bulk_intracell_in[[expr {$z + 1}]][$i]" -location [list [expr {$seq_width + $resource_width}] [expr {$swb_router_height + $resource_height * $z + $pin_margin + $pin_pitch2 * $i}] $layer_bulk_intracell_in]
    set_pin_constraint -cell _kmcyy4g8mbb_4 -pins "bulk_intracell_out[[expr {$z + 1}]][$i]" -location [list [expr {$seq_width + $resource_width}] [expr {$swb_router_height + $resource_height * $z + $pin_margin + $pin_pitch2 * $i}] $layer_bulk_intracell_out]
    set_pin_constraint -cell _kmcyy4g8mbb_4 -pins "bulk_intracell_in[[expr {$z + 1}]][$i]" -location [list [expr {$seq_width + $resource_width}] [expr {$swb_router_height + $resource_height * $z + $pin_margin + $pin_pitch2 * $i}] $layer_bulk_intracell_in]
    set_pin_constraint -cell _kmcyy4g8mbb_5 -pins "bulk_intracell_out[[expr {$z + 1}]][$i]" -location [list [expr {$seq_width + $resource_width}] [expr {$swb_router_height + $resource_height * $z + $pin_margin + $pin_pitch2 * $i}] $layer_bulk_intracell_out]
    set_pin_constraint -cell _kmcyy4g8mbb_5 -pins "bulk_intracell_in[[expr {$z + 1}]][$i]" -location [list [expr {$seq_width + $resource_width}] [expr {$swb_router_height + $resource_height * $z + $pin_margin + $pin_pitch2 * $i}] $layer_bulk_intracell_in]
    set_pin_constraint -cell _kmcyy4g8mbb_1 -pins "bulk_intracell_out[[expr {$z + 1}]][$i]" -location [list [expr {$seq_width + $resource_width}] [expr {$swb_router_height + $resource_height * $z + $pin_margin + $pin_pitch2 * $i}] $layer_bulk_intracell_out]
    set_pin_constraint -cell _kmcyy4g8mbb_1 -pins "bulk_intracell_in[[expr {$z + 1}]][$i]" -location [list [expr {$seq_width + $resource_width}] [expr {$swb_router_height + $resource_height * $z + $pin_margin + $pin_pitch2 * $i}] $layer_bulk_intracell_in]
    set_pin_constraint -cell _kmcyy4g8mbb_6 -pins "bulk_intracell_out[[expr {$z + 1}]][$i]" -location [list [expr {$seq_width + $resource_width}] [expr {$swb_router_height + $resource_height * $z + $pin_margin + $pin_pitch2 * $i}] $layer_bulk_intracell_out]
    set_pin_constraint -cell _kmcyy4g8mbb_6 -pins "bulk_intracell_in[[expr {$z + 1}]][$i]" -location [list [expr {$seq_width + $resource_width}] [expr {$swb_router_height + $resource_height * $z + $pin_margin + $pin_pitch2 * $i}] $layer_bulk_intracell_in]
    set_pin_constraint -cell _kmcyy4g8mbb_2 -pins "bulk_intracell_out[[expr {$z + 1}]][$i]" -location [list [expr {$seq_width + $resource_width}] [expr {$swb_router_height + $resource_height * $z + $pin_margin + $pin_pitch2 * $i}] $layer_bulk_intracell_out]
    set_pin_constraint -cell _kmcyy4g8mbb_2 -pins "bulk_intracell_in[[expr {$z + 1}]][$i]" -location [list [expr {$seq_width + $resource_width}] [expr {$swb_router_height + $resource_height * $z + $pin_margin + $pin_pitch2 * $i}] $layer_bulk_intracell_in]
    set_pin_constraint -cell _kmcyy4g8mbb_7 -pins "bulk_intracell_out[[expr {$z + 1}]][$i]" -location [list [expr {$seq_width + $resource_width}] [expr {$swb_router_height + $resource_height * $z + $pin_margin + $pin_pitch2 * $i}] $layer_bulk_intracell_out]
    set_pin_constraint -cell _kmcyy4g8mbb_7 -pins "bulk_intracell_in[[expr {$z + 1}]][$i]" -location [list [expr {$seq_width + $resource_width}] [expr {$swb_router_height + $resource_height * $z + $pin_margin + $pin_pitch2 * $i}] $layer_bulk_intracell_in]
    set_pin_constraint -cell _kmcyy4g8mbb_8 -pins "bulk_intracell_out[[expr {$z + 1}]][$i]" -location [list [expr {$seq_width + $resource_width}] [expr {$swb_router_height + $resource_height * $z + $pin_margin + $pin_pitch2 * $i}] $layer_bulk_intracell_out]
    set_pin_constraint -cell _kmcyy4g8mbb_8 -pins "bulk_intracell_in[[expr {$z + 1}]][$i]" -location [list [expr {$seq_width + $resource_width}] [expr {$swb_router_height + $resource_height * $z + $pin_margin + $pin_pitch2 * $i}] $layer_bulk_intracell_in]
    }
}

for {set z 0} {$z < 15} {incr z} {
    for {set i 0} {$i < 16} {incr i} {
    set_pin_constraint -cell _kmcyy4g8mbb -pins "word_channels_out[[expr {$z + 1}]][$i]" -location [list [expr {$seq_width + $resource_width}] [expr {$swb_router_height + $resource_height * $z + $pin_margin + $pin_pitch3 * $i}] M7]
    set_pin_constraint -cell _kmcyy4g8mbb -pins "word_channels_in[[expr {$z + 1}]][$i]" -location [list [expr {$seq_width + $resource_width}] [expr {$swb_router_height + $resource_height * ($z + 1) - $pin_margin - $pin_pitch3 * $i}] M7]
    set_pin_constraint -cell _kmcyy4g8mbb_3 -pins "word_channels_out[[expr {$z + 1}]][$i]" -location [list [expr {$seq_width + $resource_width}] [expr {$swb_router_height + $resource_height * $z + $pin_margin + $pin_pitch3 * $i}] M7]
    set_pin_constraint -cell _kmcyy4g8mbb_3 -pins "word_channels_in[[expr {$z + 1}]][$i]" -location [list [expr {$seq_width + $resource_width}] [expr {$swb_router_height + $resource_height * ($z + 1) - $pin_margin - $pin_pitch3 * $i}] M7]
    set_pin_constraint -cell _kmcyy4g8mbb_4 -pins "word_channels_out[[expr {$z + 1}]][$i]" -location [list [expr {$seq_width + $resource_width}] [expr {$swb_router_height + $resource_height * $z + $pin_margin + $pin_pitch3 * $i}] M7]
    set_pin_constraint -cell _kmcyy4g8mbb_4 -pins "word_channels_in[[expr {$z + 1}]][$i]" -location [list [expr {$seq_width + $resource_width}] [expr {$swb_router_height + $resource_height * ($z + 1) - $pin_margin - $pin_pitch3 * $i}] M7]
    set_pin_constraint -cell _kmcyy4g8mbb_5 -pins "word_channels_out[[expr {$z + 1}]][$i]" -location [list [expr {$seq_width + $resource_width}] [expr {$swb_router_height + $resource_height * $z + $pin_margin + $pin_pitch3 * $i}] M7]
    set_pin_constraint -cell _kmcyy4g8mbb_5 -pins "word_channels_in[[expr {$z + 1}]][$i]" -location [list [expr {$seq_width + $resource_width}] [expr {$swb_router_height + $resource_height * ($z + 1) - $pin_margin - $pin_pitch3 * $i}] M7]
    set_pin_constraint -cell _kmcyy4g8mbb_1 -pins "word_channels_out[[expr {$z + 1}]][$i]" -location [list [expr {$seq_width + $resource_width}] [expr {$swb_router_height + $resource_height * $z + $pin_margin + $pin_pitch3 * $i}] M7]
    set_pin_constraint -cell _kmcyy4g8mbb_1 -pins "word_channels_in[[expr {$z + 1}]][$i]" -location [list [expr {$seq_width + $resource_width}] [expr {$swb_router_height + $resource_height * ($z + 1) - $pin_margin - $pin_pitch3 * $i}] M7]
    set_pin_constraint -cell _kmcyy4g8mbb_6 -pins "word_channels_out[[expr {$z + 1}]][$i]" -location [list [expr {$seq_width + $resource_width}] [expr {$swb_router_height + $resource_height * $z + $pin_margin + $pin_pitch3 * $i}] M7]
    set_pin_constraint -cell _kmcyy4g8mbb_6 -pins "word_channels_in[[expr {$z + 1}]][$i]" -location [list [expr {$seq_width + $resource_width}] [expr {$swb_router_height + $resource_height * ($z + 1) - $pin_margin - $pin_pitch3 * $i}] M7]
    set_pin_constraint -cell _kmcyy4g8mbb_2 -pins "word_channels_out[[expr {$z + 1}]][$i]" -location [list [expr {$seq_width + $resource_width}] [expr {$swb_router_height + $resource_height * $z + $pin_margin + $pin_pitch3 * $i}] M7]
    set_pin_constraint -cell _kmcyy4g8mbb_2 -pins "word_channels_in[[expr {$z + 1}]][$i]" -location [list [expr {$seq_width + $resource_width}] [expr {$swb_router_height + $resource_height * ($z + 1) - $pin_margin - $pin_pitch3 * $i}] M7]
    set_pin_constraint -cell _kmcyy4g8mbb_7 -pins "word_channels_out[[expr {$z + 1}]][$i]" -location [list [expr {$seq_width + $resource_width}] [expr {$swb_router_height + $resource_height * $z + $pin_margin + $pin_pitch3 * $i}] M7]
    set_pin_constraint -cell _kmcyy4g8mbb_7 -pins "word_channels_in[[expr {$z + 1}]][$i]" -location [list [expr {$seq_width + $resource_width}] [expr {$swb_router_height + $resource_height * ($z + 1) - $pin_margin - $pin_pitch3 * $i}] M7]
    set_pin_constraint -cell _kmcyy4g8mbb_8 -pins "word_channels_out[[expr {$z + 1}]][$i]" -location [list [expr {$seq_width + $resource_width}] [expr {$swb_router_height + $resource_height * $z + $pin_margin + $pin_pitch3 * $i}] M7]
    set_pin_constraint -cell _kmcyy4g8mbb_8 -pins "word_channels_in[[expr {$z + 1}]][$i]" -location [list [expr {$seq_width + $resource_width}] [expr {$swb_router_height + $resource_height * ($z + 1) - $pin_margin - $pin_pitch3 * $i}] M7]
    }
}



#constraints for instruction bus to resources from sequencer
for {set z 0} {$z < 15} {incr z} {
    for {set i 0} {$i < 27} {incr i} {
    set_pin_constraint -cell _bofiw7zs7vj -pins "instr_[expr {$z + 1}][$i]" -location [list [expr {$seq_width}] [expr {$resource_height * $z + $pin_margin + $pin_pitch2 * $i }] M3]
    set_pin_constraint -cell _bofiw7zs7vj_3 -pins "instr_[expr {$z + 1}][$i]" -location [list [expr {$seq_width}] [expr {$resource_height * $z + $pin_margin + $pin_pitch2 * $i }] M3]
    set_pin_constraint -cell _bofiw7zs7vj_4 -pins "instr_[expr {$z + 1}][$i]" -location [list [expr {$seq_width}] [expr {$resource_height * $z + $pin_margin + $pin_pitch2 * $i }] M3]
    set_pin_constraint -cell _bofiw7zs7vj_1 -pins "instr_[expr {$z + 1}][$i]" -location [list [expr {$seq_width}] [expr {$resource_height * $z + $pin_margin + $pin_pitch2 * $i }] M3]
    set_pin_constraint -cell _bofiw7zs7vj_5 -pins "instr_[expr {$z + 1}][$i]" -location [list [expr {$seq_width}] [expr {$resource_height * $z + $pin_margin + $pin_pitch2 * $i }] M3]
    set_pin_constraint -cell _bofiw7zs7vj_6 -pins "instr_[expr {$z + 1}][$i]" -location [list [expr {$seq_width}] [expr {$resource_height * $z + $pin_margin + $pin_pitch2 * $i }] M3]
    set_pin_constraint -cell _bofiw7zs7vj_2 -pins "instr_[expr {$z + 1}][$i]" -location [list [expr {$seq_width}] [expr {$resource_height * $z + $pin_margin + $pin_pitch2 * $i }] M3]
    set_pin_constraint -cell _bofiw7zs7vj_7 -pins "instr_[expr {$z + 1}][$i]" -location [list [expr {$seq_width}] [expr {$resource_height * $z + $pin_margin + $pin_pitch2 * $i }] M3]
    set_pin_constraint -cell _bofiw7zs7vj_8 -pins "instr_[expr {$z + 1}][$i]" -location [list [expr {$seq_width}] [expr {$resource_height * $z + $pin_margin + $pin_pitch2 * $i }] M3]
    }
}



#constraints for clk/rst/activate to resources from sequencer
for {set z 0} {$z < 15} {incr z} {
    set_pin_constraint -cell _bofiw7zs7vj -pins "clk_[expr {$z + 1}]" -location [list [expr {$seq_width}] [expr {$resource_height * $z + $pin_margin + $pin_pitch2 * 27 }] M3]
    set_pin_constraint -cell _bofiw7zs7vj -pins "rst_n_[expr {$z + 1}]" -location [list [expr {$seq_width}] [expr {$resource_height * $z + $pin_margin + $pin_pitch2 * 28 }] M3]
    set_pin_constraint -cell _bofiw7zs7vj -pins "activate_[expr {$z + 1}][0]" -location [list [expr {$seq_width}] [expr {$resource_height * $z + $pin_margin + $pin_pitch2 * 29 }] M3]
    set_pin_constraint -cell _bofiw7zs7vj -pins "activate_[expr {$z + 1}][1]" -location [list [expr {$seq_width}] [expr {$resource_height * $z + $pin_margin + $pin_pitch2 * 30 }] M3]
    set_pin_constraint -cell _bofiw7zs7vj -pins "activate_[expr {$z + 1}][2]" -location [list [expr {$seq_width}] [expr {$resource_height * $z + $pin_margin + $pin_pitch2 * 31 }] M3]
    set_pin_constraint -cell _bofiw7zs7vj -pins "activate_[expr {$z + 1}][3]" -location [list [expr {$seq_width}] [expr {$resource_height * $z + $pin_margin + $pin_pitch2 * 32 }] M3]
    set_pin_constraint -cell _bofiw7zs7vj -pins "instr_valid_[expr {$z + 1}]" -location [list [expr {$seq_width}] [expr {$resource_height * $z + $pin_margin + $pin_pitch2 * 33 }] M3]
    set_pin_constraint -cell _bofiw7zs7vj_3 -pins "clk_[expr {$z + 1}]" -location [list [expr {$seq_width}] [expr {$resource_height * $z + $pin_margin + $pin_pitch2 * 27 }] M3]
    set_pin_constraint -cell _bofiw7zs7vj_3 -pins "rst_n_[expr {$z + 1}]" -location [list [expr {$seq_width}] [expr {$resource_height * $z + $pin_margin + $pin_pitch2 * 28 }] M3]
    set_pin_constraint -cell _bofiw7zs7vj_3 -pins "activate_[expr {$z + 1}][0]" -location [list [expr {$seq_width}] [expr {$resource_height * $z + $pin_margin + $pin_pitch2 * 29 }] M3]
    set_pin_constraint -cell _bofiw7zs7vj_3 -pins "activate_[expr {$z + 1}][1]" -location [list [expr {$seq_width}] [expr {$resource_height * $z + $pin_margin + $pin_pitch2 * 30 }] M3]
    set_pin_constraint -cell _bofiw7zs7vj_3 -pins "activate_[expr {$z + 1}][2]" -location [list [expr {$seq_width}] [expr {$resource_height * $z + $pin_margin + $pin_pitch2 * 31 }] M3]
    set_pin_constraint -cell _bofiw7zs7vj_3 -pins "activate_[expr {$z + 1}][3]" -location [list [expr {$seq_width}] [expr {$resource_height * $z + $pin_margin + $pin_pitch2 * 32 }] M3]
    set_pin_constraint -cell _bofiw7zs7vj_3 -pins "instr_valid_[expr {$z + 1}]" -location [list [expr {$seq_width}] [expr {$resource_height * $z + $pin_margin + $pin_pitch2 * 33 }] M3]
    set_pin_constraint -cell _bofiw7zs7vj_4 -pins "clk_[expr {$z + 1}]" -location [list [expr {$seq_width}] [expr {$resource_height * $z + $pin_margin + $pin_pitch2 * 27 }] M3]
    set_pin_constraint -cell _bofiw7zs7vj_4 -pins "rst_n_[expr {$z + 1}]" -location [list [expr {$seq_width}] [expr {$resource_height * $z + $pin_margin + $pin_pitch2 * 28 }] M3]
    set_pin_constraint -cell _bofiw7zs7vj_4 -pins "activate_[expr {$z + 1}][0]" -location [list [expr {$seq_width}] [expr {$resource_height * $z + $pin_margin + $pin_pitch2 * 29 }] M3]
    set_pin_constraint -cell _bofiw7zs7vj_4 -pins "activate_[expr {$z + 1}][1]" -location [list [expr {$seq_width}] [expr {$resource_height * $z + $pin_margin + $pin_pitch2 * 30 }] M3]
    set_pin_constraint -cell _bofiw7zs7vj_4 -pins "activate_[expr {$z + 1}][2]" -location [list [expr {$seq_width}] [expr {$resource_height * $z + $pin_margin + $pin_pitch2 * 31 }] M3]
    set_pin_constraint -cell _bofiw7zs7vj_4 -pins "activate_[expr {$z + 1}][3]" -location [list [expr {$seq_width}] [expr {$resource_height * $z + $pin_margin + $pin_pitch2 * 32 }] M3]
    set_pin_constraint -cell _bofiw7zs7vj_4 -pins "instr_valid_[expr {$z + 1}]" -location [list [expr {$seq_width}] [expr {$resource_height * $z + $pin_margin + $pin_pitch2 * 33 }] M3]
    set_pin_constraint -cell _bofiw7zs7vj_1 -pins "clk_[expr {$z + 1}]" -location [list [expr {$seq_width}] [expr {$resource_height * $z + $pin_margin + $pin_pitch2 * 27 }] M3]
    set_pin_constraint -cell _bofiw7zs7vj_1 -pins "rst_n_[expr {$z + 1}]" -location [list [expr {$seq_width}] [expr {$resource_height * $z + $pin_margin + $pin_pitch2 * 28 }] M3]
    set_pin_constraint -cell _bofiw7zs7vj_1 -pins "activate_[expr {$z + 1}][0]" -location [list [expr {$seq_width}] [expr {$resource_height * $z + $pin_margin + $pin_pitch2 * 29 }] M3]
    set_pin_constraint -cell _bofiw7zs7vj_1 -pins "activate_[expr {$z + 1}][1]" -location [list [expr {$seq_width}] [expr {$resource_height * $z + $pin_margin + $pin_pitch2 * 30 }] M3]
    set_pin_constraint -cell _bofiw7zs7vj_1 -pins "activate_[expr {$z + 1}][2]" -location [list [expr {$seq_width}] [expr {$resource_height * $z + $pin_margin + $pin_pitch2 * 31 }] M3]
    set_pin_constraint -cell _bofiw7zs7vj_1 -pins "activate_[expr {$z + 1}][3]" -location [list [expr {$seq_width}] [expr {$resource_height * $z + $pin_margin + $pin_pitch2 * 32 }] M3]
    set_pin_constraint -cell _bofiw7zs7vj_1 -pins "instr_valid_[expr {$z + 1}]" -location [list [expr {$seq_width}] [expr {$resource_height * $z + $pin_margin + $pin_pitch2 * 33 }] M3]
    set_pin_constraint -cell _bofiw7zs7vj_5 -pins "clk_[expr {$z + 1}]" -location [list [expr {$seq_width}] [expr {$resource_height * $z + $pin_margin + $pin_pitch2 * 27 }] M3]
    set_pin_constraint -cell _bofiw7zs7vj_5 -pins "rst_n_[expr {$z + 1}]" -location [list [expr {$seq_width}] [expr {$resource_height * $z + $pin_margin + $pin_pitch2 * 28 }] M3]
    set_pin_constraint -cell _bofiw7zs7vj_5 -pins "activate_[expr {$z + 1}][0]" -location [list [expr {$seq_width}] [expr {$resource_height * $z + $pin_margin + $pin_pitch2 * 29 }] M3]
    set_pin_constraint -cell _bofiw7zs7vj_5 -pins "activate_[expr {$z + 1}][1]" -location [list [expr {$seq_width}] [expr {$resource_height * $z + $pin_margin + $pin_pitch2 * 30 }] M3]
    set_pin_constraint -cell _bofiw7zs7vj_5 -pins "activate_[expr {$z + 1}][2]" -location [list [expr {$seq_width}] [expr {$resource_height * $z + $pin_margin + $pin_pitch2 * 31 }] M3]
    set_pin_constraint -cell _bofiw7zs7vj_5 -pins "activate_[expr {$z + 1}][3]" -location [list [expr {$seq_width}] [expr {$resource_height * $z + $pin_margin + $pin_pitch2 * 32 }] M3]
    set_pin_constraint -cell _bofiw7zs7vj_5 -pins "instr_valid_[expr {$z + 1}]" -location [list [expr {$seq_width}] [expr {$resource_height * $z + $pin_margin + $pin_pitch2 * 33 }] M3]
    set_pin_constraint -cell _bofiw7zs7vj_6 -pins "clk_[expr {$z + 1}]" -location [list [expr {$seq_width}] [expr {$resource_height * $z + $pin_margin + $pin_pitch2 * 27 }] M3]
    set_pin_constraint -cell _bofiw7zs7vj_6 -pins "rst_n_[expr {$z + 1}]" -location [list [expr {$seq_width}] [expr {$resource_height * $z + $pin_margin + $pin_pitch2 * 28 }] M3]
    set_pin_constraint -cell _bofiw7zs7vj_6 -pins "activate_[expr {$z + 1}][0]" -location [list [expr {$seq_width}] [expr {$resource_height * $z + $pin_margin + $pin_pitch2 * 29 }] M3]
    set_pin_constraint -cell _bofiw7zs7vj_6 -pins "activate_[expr {$z + 1}][1]" -location [list [expr {$seq_width}] [expr {$resource_height * $z + $pin_margin + $pin_pitch2 * 30 }] M3]
    set_pin_constraint -cell _bofiw7zs7vj_6 -pins "activate_[expr {$z + 1}][2]" -location [list [expr {$seq_width}] [expr {$resource_height * $z + $pin_margin + $pin_pitch2 * 31 }] M3]
    set_pin_constraint -cell _bofiw7zs7vj_6 -pins "activate_[expr {$z + 1}][3]" -location [list [expr {$seq_width}] [expr {$resource_height * $z + $pin_margin + $pin_pitch2 * 32 }] M3]
    set_pin_constraint -cell _bofiw7zs7vj_6 -pins "instr_valid_[expr {$z + 1}]" -location [list [expr {$seq_width}] [expr {$resource_height * $z + $pin_margin + $pin_pitch2 * 33 }] M3]
    set_pin_constraint -cell _bofiw7zs7vj_2 -pins "clk_[expr {$z + 1}]" -location [list [expr {$seq_width}] [expr {$resource_height * $z + $pin_margin + $pin_pitch2 * 27 }] M3]
    set_pin_constraint -cell _bofiw7zs7vj_2 -pins "rst_n_[expr {$z + 1}]" -location [list [expr {$seq_width}] [expr {$resource_height * $z + $pin_margin + $pin_pitch2 * 28 }] M3]
    set_pin_constraint -cell _bofiw7zs7vj_2 -pins "activate_[expr {$z + 1}][0]" -location [list [expr {$seq_width}] [expr {$resource_height * $z + $pin_margin + $pin_pitch2 * 29 }] M3]
    set_pin_constraint -cell _bofiw7zs7vj_2 -pins "activate_[expr {$z + 1}][1]" -location [list [expr {$seq_width}] [expr {$resource_height * $z + $pin_margin + $pin_pitch2 * 30 }] M3]
    set_pin_constraint -cell _bofiw7zs7vj_2 -pins "activate_[expr {$z + 1}][2]" -location [list [expr {$seq_width}] [expr {$resource_height * $z + $pin_margin + $pin_pitch2 * 31 }] M3]
    set_pin_constraint -cell _bofiw7zs7vj_2 -pins "activate_[expr {$z + 1}][3]" -location [list [expr {$seq_width}] [expr {$resource_height * $z + $pin_margin + $pin_pitch2 * 32 }] M3]
    set_pin_constraint -cell _bofiw7zs7vj_2 -pins "instr_valid_[expr {$z + 1}]" -location [list [expr {$seq_width}] [expr {$resource_height * $z + $pin_margin + $pin_pitch2 * 33 }] M3]
    set_pin_constraint -cell _bofiw7zs7vj_7 -pins "clk_[expr {$z + 1}]" -location [list [expr {$seq_width}] [expr {$resource_height * $z + $pin_margin + $pin_pitch2 * 27 }] M3]
    set_pin_constraint -cell _bofiw7zs7vj_7 -pins "rst_n_[expr {$z + 1}]" -location [list [expr {$seq_width}] [expr {$resource_height * $z + $pin_margin + $pin_pitch2 * 28 }] M3]
    set_pin_constraint -cell _bofiw7zs7vj_7 -pins "activate_[expr {$z + 1}][0]" -location [list [expr {$seq_width}] [expr {$resource_height * $z + $pin_margin + $pin_pitch2 * 29 }] M3]
    set_pin_constraint -cell _bofiw7zs7vj_7 -pins "activate_[expr {$z + 1}][1]" -location [list [expr {$seq_width}] [expr {$resource_height * $z + $pin_margin + $pin_pitch2 * 30 }] M3]
    set_pin_constraint -cell _bofiw7zs7vj_7 -pins "activate_[expr {$z + 1}][2]" -location [list [expr {$seq_width}] [expr {$resource_height * $z + $pin_margin + $pin_pitch2 * 31 }] M3]
    set_pin_constraint -cell _bofiw7zs7vj_7 -pins "activate_[expr {$z + 1}][3]" -location [list [expr {$seq_width}] [expr {$resource_height * $z + $pin_margin + $pin_pitch2 * 32 }] M3]
    set_pin_constraint -cell _bofiw7zs7vj_7 -pins "instr_valid_[expr {$z + 1}]" -location [list [expr {$seq_width}] [expr {$resource_height * $z + $pin_margin + $pin_pitch2 * 33 }] M3]
    set_pin_constraint -cell _bofiw7zs7vj_8 -pins "clk_[expr {$z + 1}]" -location [list [expr {$seq_width}] [expr {$resource_height * $z + $pin_margin + $pin_pitch2 * 27 }] M3]
    set_pin_constraint -cell _bofiw7zs7vj_8 -pins "rst_n_[expr {$z + 1}]" -location [list [expr {$seq_width}] [expr {$resource_height * $z + $pin_margin + $pin_pitch2 * 28 }] M3]
    set_pin_constraint -cell _bofiw7zs7vj_8 -pins "activate_[expr {$z + 1}][0]" -location [list [expr {$seq_width}] [expr {$resource_height * $z + $pin_margin + $pin_pitch2 * 29 }] M3]
    set_pin_constraint -cell _bofiw7zs7vj_8 -pins "activate_[expr {$z + 1}][1]" -location [list [expr {$seq_width}] [expr {$resource_height * $z + $pin_margin + $pin_pitch2 * 30 }] M3]
    set_pin_constraint -cell _bofiw7zs7vj_8 -pins "activate_[expr {$z + 1}][2]" -location [list [expr {$seq_width}] [expr {$resource_height * $z + $pin_margin + $pin_pitch2 * 31 }] M3]
    set_pin_constraint -cell _bofiw7zs7vj_8 -pins "activate_[expr {$z + 1}][3]" -location [list [expr {$seq_width}] [expr {$resource_height * $z + $pin_margin + $pin_pitch2 * 32 }] M3]
    set_pin_constraint -cell _bofiw7zs7vj_8 -pins "instr_valid_[expr {$z + 1}]" -location [list [expr {$seq_width}] [expr {$resource_height * $z + $pin_margin + $pin_pitch2 * 33 }] M3]
}



#constraints for instruction bus to swb from sequencer
for {set i 0} {$i < 27} {incr i} {
    set_pin_constraint -cell _bofiw7zs7vj -pins "instr_0[$i]" -location [list [expr {$pin_margin + $pin_pitch2 * $i}] 0 M4]
    set_pin_constraint -cell _bofiw7zs7vj_3 -pins "instr_0[$i]" -location [list [expr {$pin_margin + $pin_pitch2 * $i}] 0 M4]
    set_pin_constraint -cell _bofiw7zs7vj_4 -pins "instr_0[$i]" -location [list [expr {$pin_margin + $pin_pitch2 * $i}] 0 M4]
    set_pin_constraint -cell _bofiw7zs7vj_1 -pins "instr_0[$i]" -location [list [expr {$pin_margin + $pin_pitch2 * $i}] 0 M4]
    set_pin_constraint -cell _bofiw7zs7vj_5 -pins "instr_0[$i]" -location [list [expr {$pin_margin + $pin_pitch2 * $i}] 0 M4]
    set_pin_constraint -cell _bofiw7zs7vj_6 -pins "instr_0[$i]" -location [list [expr {$pin_margin + $pin_pitch2 * $i}] 0 M4]
    set_pin_constraint -cell _bofiw7zs7vj_2 -pins "instr_0[$i]" -location [list [expr {$pin_margin + $pin_pitch2 * $i}] 0 M4]
    set_pin_constraint -cell _bofiw7zs7vj_7 -pins "instr_0[$i]" -location [list [expr {$pin_margin + $pin_pitch2 * $i}] 0 M4]
    set_pin_constraint -cell _bofiw7zs7vj_8 -pins "instr_0[$i]" -location [list [expr {$pin_margin + $pin_pitch2 * $i}] 0 M4]
}



#constraints for clk/rst/activate to swb from sequencer
set_pin_constraint -cell _bofiw7zs7vj -pins "clk_0" -location [list [expr {$pin_margin + $pin_pitch2 * 27}] 0 M4]
set_pin_constraint -cell _bofiw7zs7vj -pins "rst_n_0" -location [list [expr {$pin_margin + $pin_pitch2 * 28}] 0 M4]
set_pin_constraint -cell _bofiw7zs7vj -pins "activate_0[0]" -location [list [expr {$pin_margin + $pin_pitch2 * 29}] 0 M4]
set_pin_constraint -cell _bofiw7zs7vj -pins "activate_0[1]" -location [list [expr {$pin_margin + $pin_pitch2 * 30}] 0 M4]
set_pin_constraint -cell _bofiw7zs7vj -pins "activate_0[2]" -location [list [expr {$pin_margin + $pin_pitch2 * 31}] 0 M4]
set_pin_constraint -cell _bofiw7zs7vj -pins "activate_0[3]" -location [list [expr {$pin_margin + $pin_pitch2 * 32}] 0 M4]
set_pin_constraint -cell _bofiw7zs7vj -pins "instr_valid_0" -location [list [expr {$pin_margin + $pin_pitch2 * 33}] 0 M4]
set_pin_constraint -cell _bofiw7zs7vj_3 -pins "clk_0" -location [list [expr {$pin_margin + $pin_pitch2 * 27}] 0 M4]
set_pin_constraint -cell _bofiw7zs7vj_3 -pins "rst_n_0" -location [list [expr {$pin_margin + $pin_pitch2 * 28}] 0 M4]
set_pin_constraint -cell _bofiw7zs7vj_3 -pins "activate_0[0]" -location [list [expr {$pin_margin + $pin_pitch2 * 29}] 0 M4]
set_pin_constraint -cell _bofiw7zs7vj_3 -pins "activate_0[1]" -location [list [expr {$pin_margin + $pin_pitch2 * 30}] 0 M4]
set_pin_constraint -cell _bofiw7zs7vj_3 -pins "activate_0[2]" -location [list [expr {$pin_margin + $pin_pitch2 * 31}] 0 M4]
set_pin_constraint -cell _bofiw7zs7vj_3 -pins "activate_0[3]" -location [list [expr {$pin_margin + $pin_pitch2 * 32}] 0 M4]
set_pin_constraint -cell _bofiw7zs7vj_3 -pins "instr_valid_0" -location [list [expr {$pin_margin + $pin_pitch2 * 33}] 0 M4]
set_pin_constraint -cell _bofiw7zs7vj_4 -pins "clk_0" -location [list [expr {$pin_margin + $pin_pitch2 * 27}] 0 M4]
set_pin_constraint -cell _bofiw7zs7vj_4 -pins "rst_n_0" -location [list [expr {$pin_margin + $pin_pitch2 * 28}] 0 M4]
set_pin_constraint -cell _bofiw7zs7vj_4 -pins "activate_0[0]" -location [list [expr {$pin_margin + $pin_pitch2 * 29}] 0 M4]
set_pin_constraint -cell _bofiw7zs7vj_4 -pins "activate_0[1]" -location [list [expr {$pin_margin + $pin_pitch2 * 30}] 0 M4]
set_pin_constraint -cell _bofiw7zs7vj_4 -pins "activate_0[2]" -location [list [expr {$pin_margin + $pin_pitch2 * 31}] 0 M4]
set_pin_constraint -cell _bofiw7zs7vj_4 -pins "activate_0[3]" -location [list [expr {$pin_margin + $pin_pitch2 * 32}] 0 M4]
set_pin_constraint -cell _bofiw7zs7vj_4 -pins "instr_valid_0" -location [list [expr {$pin_margin + $pin_pitch2 * 33}] 0 M4]
set_pin_constraint -cell _bofiw7zs7vj_1 -pins "clk_0" -location [list [expr {$pin_margin + $pin_pitch2 * 27}] 0 M4]
set_pin_constraint -cell _bofiw7zs7vj_1 -pins "rst_n_0" -location [list [expr {$pin_margin + $pin_pitch2 * 28}] 0 M4]
set_pin_constraint -cell _bofiw7zs7vj_1 -pins "activate_0[0]" -location [list [expr {$pin_margin + $pin_pitch2 * 29}] 0 M4]
set_pin_constraint -cell _bofiw7zs7vj_1 -pins "activate_0[1]" -location [list [expr {$pin_margin + $pin_pitch2 * 30}] 0 M4]
set_pin_constraint -cell _bofiw7zs7vj_1 -pins "activate_0[2]" -location [list [expr {$pin_margin + $pin_pitch2 * 31}] 0 M4]
set_pin_constraint -cell _bofiw7zs7vj_1 -pins "activate_0[3]" -location [list [expr {$pin_margin + $pin_pitch2 * 32}] 0 M4]
set_pin_constraint -cell _bofiw7zs7vj_1 -pins "instr_valid_0" -location [list [expr {$pin_margin + $pin_pitch2 * 33}] 0 M4]
set_pin_constraint -cell _bofiw7zs7vj_5 -pins "clk_0" -location [list [expr {$pin_margin + $pin_pitch2 * 27}] 0 M4]
set_pin_constraint -cell _bofiw7zs7vj_5 -pins "rst_n_0" -location [list [expr {$pin_margin + $pin_pitch2 * 28}] 0 M4]
set_pin_constraint -cell _bofiw7zs7vj_5 -pins "activate_0[0]" -location [list [expr {$pin_margin + $pin_pitch2 * 29}] 0 M4]
set_pin_constraint -cell _bofiw7zs7vj_5 -pins "activate_0[1]" -location [list [expr {$pin_margin + $pin_pitch2 * 30}] 0 M4]
set_pin_constraint -cell _bofiw7zs7vj_5 -pins "activate_0[2]" -location [list [expr {$pin_margin + $pin_pitch2 * 31}] 0 M4]
set_pin_constraint -cell _bofiw7zs7vj_5 -pins "activate_0[3]" -location [list [expr {$pin_margin + $pin_pitch2 * 32}] 0 M4]
set_pin_constraint -cell _bofiw7zs7vj_5 -pins "instr_valid_0" -location [list [expr {$pin_margin + $pin_pitch2 * 33}] 0 M4]
set_pin_constraint -cell _bofiw7zs7vj_6 -pins "clk_0" -location [list [expr {$pin_margin + $pin_pitch2 * 27}] 0 M4]
set_pin_constraint -cell _bofiw7zs7vj_6 -pins "rst_n_0" -location [list [expr {$pin_margin + $pin_pitch2 * 28}] 0 M4]
set_pin_constraint -cell _bofiw7zs7vj_6 -pins "activate_0[0]" -location [list [expr {$pin_margin + $pin_pitch2 * 29}] 0 M4]
set_pin_constraint -cell _bofiw7zs7vj_6 -pins "activate_0[1]" -location [list [expr {$pin_margin + $pin_pitch2 * 30}] 0 M4]
set_pin_constraint -cell _bofiw7zs7vj_6 -pins "activate_0[2]" -location [list [expr {$pin_margin + $pin_pitch2 * 31}] 0 M4]
set_pin_constraint -cell _bofiw7zs7vj_6 -pins "activate_0[3]" -location [list [expr {$pin_margin + $pin_pitch2 * 32}] 0 M4]
set_pin_constraint -cell _bofiw7zs7vj_6 -pins "instr_valid_0" -location [list [expr {$pin_margin + $pin_pitch2 * 33}] 0 M4]
set_pin_constraint -cell _bofiw7zs7vj_2 -pins "clk_0" -location [list [expr {$pin_margin + $pin_pitch2 * 27}] 0 M4]
set_pin_constraint -cell _bofiw7zs7vj_2 -pins "rst_n_0" -location [list [expr {$pin_margin + $pin_pitch2 * 28}] 0 M4]
set_pin_constraint -cell _bofiw7zs7vj_2 -pins "activate_0[0]" -location [list [expr {$pin_margin + $pin_pitch2 * 29}] 0 M4]
set_pin_constraint -cell _bofiw7zs7vj_2 -pins "activate_0[1]" -location [list [expr {$pin_margin + $pin_pitch2 * 30}] 0 M4]
set_pin_constraint -cell _bofiw7zs7vj_2 -pins "activate_0[2]" -location [list [expr {$pin_margin + $pin_pitch2 * 31}] 0 M4]
set_pin_constraint -cell _bofiw7zs7vj_2 -pins "activate_0[3]" -location [list [expr {$pin_margin + $pin_pitch2 * 32}] 0 M4]
set_pin_constraint -cell _bofiw7zs7vj_2 -pins "instr_valid_0" -location [list [expr {$pin_margin + $pin_pitch2 * 33}] 0 M4]
set_pin_constraint -cell _bofiw7zs7vj_7 -pins "clk_0" -location [list [expr {$pin_margin + $pin_pitch2 * 27}] 0 M4]
set_pin_constraint -cell _bofiw7zs7vj_7 -pins "rst_n_0" -location [list [expr {$pin_margin + $pin_pitch2 * 28}] 0 M4]
set_pin_constraint -cell _bofiw7zs7vj_7 -pins "activate_0[0]" -location [list [expr {$pin_margin + $pin_pitch2 * 29}] 0 M4]
set_pin_constraint -cell _bofiw7zs7vj_7 -pins "activate_0[1]" -location [list [expr {$pin_margin + $pin_pitch2 * 30}] 0 M4]
set_pin_constraint -cell _bofiw7zs7vj_7 -pins "activate_0[2]" -location [list [expr {$pin_margin + $pin_pitch2 * 31}] 0 M4]
set_pin_constraint -cell _bofiw7zs7vj_7 -pins "activate_0[3]" -location [list [expr {$pin_margin + $pin_pitch2 * 32}] 0 M4]
set_pin_constraint -cell _bofiw7zs7vj_7 -pins "instr_valid_0" -location [list [expr {$pin_margin + $pin_pitch2 * 33}] 0 M4]
set_pin_constraint -cell _bofiw7zs7vj_8 -pins "clk_0" -location [list [expr {$pin_margin + $pin_pitch2 * 27}] 0 M4]
set_pin_constraint -cell _bofiw7zs7vj_8 -pins "rst_n_0" -location [list [expr {$pin_margin + $pin_pitch2 * 28}] 0 M4]
set_pin_constraint -cell _bofiw7zs7vj_8 -pins "activate_0[0]" -location [list [expr {$pin_margin + $pin_pitch2 * 29}] 0 M4]
set_pin_constraint -cell _bofiw7zs7vj_8 -pins "activate_0[1]" -location [list [expr {$pin_margin + $pin_pitch2 * 30}] 0 M4]
set_pin_constraint -cell _bofiw7zs7vj_8 -pins "activate_0[2]" -location [list [expr {$pin_margin + $pin_pitch2 * 31}] 0 M4]
set_pin_constraint -cell _bofiw7zs7vj_8 -pins "activate_0[3]" -location [list [expr {$pin_margin + $pin_pitch2 * 32}] 0 M4]
set_pin_constraint -cell _bofiw7zs7vj_8 -pins "instr_valid_0" -location [list [expr {$pin_margin + $pin_pitch2 * 33}] 0 M4]




