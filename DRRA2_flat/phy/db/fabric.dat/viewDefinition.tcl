if {![namespace exists ::IMEX]} { namespace eval ::IMEX {} }
set ::IMEX::dataVar [file dirname [file normalize [info script]]]
set ::IMEX::libVar ${::IMEX::dataVar}/libs

create_library_set -name LIBSET_BC\
   -timing\
    [list [list ${::IMEX::libVar}/mmmc/tcbn28hpcplusbwp30p140ffg1p05vm40c.lib\
          ${::IMEX::libVar}/mmmc/tsdn28hpcpuhdb64x128m4mwa_170a_ffg1p05vm40c.lib\
          ${::IMEX::libVar}/mmmc/tsdn28hpcpuhdb64x64m4mwa_170a_ffg1p05vm40c.lib\
          ${::IMEX::libVar}/mmmc/ts6n28hpcphvta16x16m2fwbso_200b_ffg1p05vm40c.lib\
          ${::IMEX::libVar}/mmmc/ts6n28hpcphvta16x32m2fwbso_200b_ffg1p05vm40c.lib\
          ${::IMEX::libVar}/mmmc/tphn28hpcpgv18ffg0p99v1p98vm40c.lib]]
create_library_set -name LIBSET_WC\
   -timing\
    [list [list ${::IMEX::libVar}/mmmc/tcbn28hpcplusbwp30p140ssg0p72v125c.lib\
          ${::IMEX::libVar}/mmmc/tsdn28hpcpuhdb64x128m4mwa_170a_ssg0p81v125c.lib\
          ${::IMEX::libVar}/mmmc/tsdn28hpcpuhdb64x64m4mwa_170a_ssg0p81v125c.lib\
          ${::IMEX::libVar}/mmmc/ts6n28hpcphvta16x16m2fwbso_200b_ssg0p81v125c.lib\
          ${::IMEX::libVar}/mmmc/ts6n28hpcphvta16x32m2fwbso_200b_ssg0p81v125c.lib\
          ${::IMEX::libVar}/mmmc/tphn28hpcpgv18ssg0p81v1p62v125c.lib]]
create_library_set -name LIBSET_TC\
   -timing\
    [list [list ${::IMEX::libVar}/mmmc/tcbn28hpcplusbwp30p140tt0p9v25c.lib\
          ${::IMEX::libVar}/mmmc/tsdn28hpcpuhdb64x128m4mwa_170a_tt0p9v25c.lib\
          ${::IMEX::libVar}/mmmc/tsdn28hpcpuhdb64x64m4mwa_170a_tt0p9v25c.lib\
          ${::IMEX::libVar}/mmmc/ts6n28hpcphvta16x16m2fwbso_200b_tt0p9v25c.lib\
          ${::IMEX::libVar}/mmmc/ts6n28hpcphvta16x32m2fwbso_200b_tt0p9v25c.lib\
          ${::IMEX::libVar}/mmmc/tphn28hpcpgv18tt0p9v1p8v25c.lib]]
create_timing_condition -name cond_typ\
   -library_sets [list LIBSET_TC]\
   -opcond tt0p9v25c\
   -opcond_library tcbn28hpcplusbwp30p140tt0p9v25c
create_timing_condition -name cond_sram_typ\
   -library_sets [list LIBSET_TC]\
   -opcond tt0p9v25c\
   -opcond_library tsdn28hpcpuhdb64x128m4mwa_170a_tt0p9v25c
create_timing_condition -name cond_worst\
   -library_sets [list LIBSET_WC]\
   -opcond ssg0p72v125c\
   -opcond_library tcbn28hpcplusbwp30p140ssg0p72v125c
create_timing_condition -name cond_sram_worst\
   -library_sets [list LIBSET_WC]\
   -opcond ssg0p81v125c\
   -opcond_library tsdn28hpcpuhdb64x128m4mwa_170a_ssg0p81v125c
create_timing_condition -name cond_best\
   -library_sets [list LIBSET_BC]\
   -opcond ff1p05vm40c\
   -opcond_library tcbn28hpcplusbwp30p140ffg1p05vm40c
create_timing_condition -name cond_sram_best\
   -library_sets [list LIBSET_BC]\
   -opcond ff1p05vm40c\
   -opcond_library tsdn28hpcpuhdb64x128m4mwa_170a_ffg1p05vm40c
create_rc_corner -name rc_typ\
   -pre_route_res 1\
   -post_route_res 1\
   -pre_route_cap 1\
   -post_route_cap 1\
   -post_route_cross_cap 1\
   -pre_route_clock_res 0\
   -pre_route_clock_cap 0\
   -qrc_tech ${::IMEX::libVar}/mmmc/rc_typ/qrcTechFile
create_rc_corner -name rc_best\
   -pre_route_res 1\
   -post_route_res 1\
   -pre_route_cap 1\
   -post_route_cap 1\
   -post_route_cross_cap 1\
   -pre_route_clock_res 0\
   -pre_route_clock_cap 0\
   -qrc_tech ${::IMEX::libVar}/mmmc/rc_best/qrcTechFile
create_rc_corner -name rc_worst\
   -pre_route_res 1\
   -post_route_res 1\
   -pre_route_cap 1\
   -post_route_cap 1\
   -post_route_cross_cap 1\
   -pre_route_clock_res 0\
   -pre_route_clock_cap 0\
   -qrc_tech ${::IMEX::libVar}/mmmc/rc_worst/qrcTechFile
create_delay_corner -name WC_dc\
   -timing_condition {cond_worst}\
   -rc_corner rc_worst
create_delay_corner -name TC_dc\
   -timing_condition {cond_typ}\
   -rc_corner rc_typ
create_delay_corner -name BC_dc\
   -timing_condition {cond_best}\
   -rc_corner rc_best
create_constraint_mode -name CM\
   -sdc_files\
    [list ${::IMEX::dataVar}/mmmc/modes/CM/CM.sdc]
create_analysis_view -name AV_WC_RCWORST -constraint_mode CM -delay_corner WC_dc -latency_file ${::IMEX::dataVar}/mmmc/views/AV_WC_RCWORST/latency.sdc
create_analysis_view -name AV_TC_RCTYP -constraint_mode CM -delay_corner TC_dc
create_analysis_view -name AV_BC_RCBEST -constraint_mode CM -delay_corner BC_dc -latency_file ${::IMEX::dataVar}/mmmc/views/AV_BC_RCBEST/latency.sdc
set_analysis_view -setup [list AV_WC_RCWORST] -hold [list AV_WC_RCWORST AV_BC_RCBEST]
