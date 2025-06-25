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
          ${::IMEX::libVar}/mmmc/tphn28hpcpgv18ffg0p99v1p98vm40c.lib]\
    ${::IMEX::libVar}/mmmc/_auoccatktx4_2_AV_BC_RCBEST.lib.gz\
    ${::IMEX::libVar}/mmmc/_kmcyy4g8mbb_8_AV_BC_RCBEST.lib.gz\
    ${::IMEX::libVar}/mmmc/_bofiw7zs7vj_8_AV_BC_RCBEST.lib.gz\
    ${::IMEX::libVar}/mmmc/_auoccatktx4_1_AV_BC_RCBEST.lib.gz\
    ${::IMEX::libVar}/mmmc/_kmcyy4g8mbb_7_AV_BC_RCBEST.lib.gz\
    ${::IMEX::libVar}/mmmc/_bofiw7zs7vj_7_AV_BC_RCBEST.lib.gz\
    ${::IMEX::libVar}/mmmc/_auoccatktx4_AV_BC_RCBEST.lib.gz\
    ${::IMEX::libVar}/mmmc/_kmcyy4g8mbb_2_AV_BC_RCBEST.lib.gz\
    ${::IMEX::libVar}/mmmc/_bofiw7zs7vj_2_AV_BC_RCBEST.lib.gz\
    ${::IMEX::libVar}/mmmc/_pnkjyubmn1c_2_AV_BC_RCBEST.lib.gz\
    ${::IMEX::libVar}/mmmc/_dyqn9udjnhi_8_AV_BC_RCBEST.lib.gz\
    ${::IMEX::libVar}/mmmc/_dyqn9udjnhi_7_AV_BC_RCBEST.lib.gz\
    ${::IMEX::libVar}/mmmc/_dyqn9udjnhi_6_AV_BC_RCBEST.lib.gz\
    ${::IMEX::libVar}/mmmc/_kmcyy4g8mbb_6_AV_BC_RCBEST.lib.gz\
    ${::IMEX::libVar}/mmmc/_bofiw7zs7vj_6_AV_BC_RCBEST.lib.gz\
    ${::IMEX::libVar}/mmmc/_pnkjyubmn1c_1_AV_BC_RCBEST.lib.gz\
    ${::IMEX::libVar}/mmmc/_dyqn9udjnhi_5_AV_BC_RCBEST.lib.gz\
    ${::IMEX::libVar}/mmmc/_dyqn9udjnhi_4_AV_BC_RCBEST.lib.gz\
    ${::IMEX::libVar}/mmmc/_dyqn9udjnhi_3_AV_BC_RCBEST.lib.gz\
    ${::IMEX::libVar}/mmmc/_kmcyy4g8mbb_1_AV_BC_RCBEST.lib.gz\
    ${::IMEX::libVar}/mmmc/_bofiw7zs7vj_5_AV_BC_RCBEST.lib.gz\
    ${::IMEX::libVar}/mmmc/_pnkjyubmn1c_AV_BC_RCBEST.lib.gz\
    ${::IMEX::libVar}/mmmc/_dyqn9udjnhi_2_AV_BC_RCBEST.lib.gz\
    ${::IMEX::libVar}/mmmc/_dyqn9udjnhi_1_AV_BC_RCBEST.lib.gz\
    ${::IMEX::libVar}/mmmc/_dyqn9udjnhi_AV_BC_RCBEST.lib.gz\
    ${::IMEX::libVar}/mmmc/_kmcyy4g8mbb_5_AV_BC_RCBEST.lib.gz\
    ${::IMEX::libVar}/mmmc/_bofiw7zs7vj_1_AV_BC_RCBEST.lib.gz\
    ${::IMEX::libVar}/mmmc/_fuznrwegsgm_2_AV_BC_RCBEST.lib.gz\
    ${::IMEX::libVar}/mmmc/_kmcyy4g8mbb_4_AV_BC_RCBEST.lib.gz\
    ${::IMEX::libVar}/mmmc/_bofiw7zs7vj_4_AV_BC_RCBEST.lib.gz\
    ${::IMEX::libVar}/mmmc/_fuznrwegsgm_1_AV_BC_RCBEST.lib.gz\
    ${::IMEX::libVar}/mmmc/_kmcyy4g8mbb_3_AV_BC_RCBEST.lib.gz\
    ${::IMEX::libVar}/mmmc/_bofiw7zs7vj_3_AV_BC_RCBEST.lib.gz\
    ${::IMEX::libVar}/mmmc/_fuznrwegsgm_AV_BC_RCBEST.lib.gz\
    ${::IMEX::libVar}/mmmc/_kmcyy4g8mbb_AV_BC_RCBEST.lib.gz\
    ${::IMEX::libVar}/mmmc/_bofiw7zs7vj_AV_BC_RCBEST.lib.gz]
create_library_set -name LIBSET_WC_budgeting_min\
   -timing\
    [list [list ${::IMEX::libVar}/mmmc/tcbn28hpcplusbwp30p140ssg0p72v125c.lib\
          ${::IMEX::libVar}/mmmc/tsdn28hpcpuhdb64x128m4mwa_170a_ssg0p81v125c.lib\
          ${::IMEX::libVar}/mmmc/tsdn28hpcpuhdb64x64m4mwa_170a_ssg0p81v125c.lib\
          ${::IMEX::libVar}/mmmc/ts6n28hpcphvta16x16m2fwbso_200b_ssg0p81v125c.lib\
          ${::IMEX::libVar}/mmmc/ts6n28hpcphvta16x32m2fwbso_200b_ssg0p81v125c.lib\
          ${::IMEX::libVar}/mmmc/tphn28hpcpgv18ssg0p81v1p62v125c.lib]\
    ${::IMEX::libVar}/mmmc/_auoccatktx4_2_AV_WC_RCWORST_min.lib.gz\
    ${::IMEX::libVar}/mmmc/_kmcyy4g8mbb_8_AV_WC_RCWORST_min.lib.gz\
    ${::IMEX::libVar}/mmmc/_bofiw7zs7vj_8_AV_WC_RCWORST_min.lib.gz\
    ${::IMEX::libVar}/mmmc/_auoccatktx4_1_AV_WC_RCWORST_min.lib.gz\
    ${::IMEX::libVar}/mmmc/_kmcyy4g8mbb_7_AV_WC_RCWORST_min.lib.gz\
    ${::IMEX::libVar}/mmmc/_bofiw7zs7vj_7_AV_WC_RCWORST_min.lib.gz\
    ${::IMEX::libVar}/mmmc/_auoccatktx4_AV_WC_RCWORST_min.lib.gz\
    ${::IMEX::libVar}/mmmc/_kmcyy4g8mbb_2_AV_WC_RCWORST_min.lib.gz\
    ${::IMEX::libVar}/mmmc/_bofiw7zs7vj_2_AV_WC_RCWORST_min.lib.gz\
    ${::IMEX::libVar}/mmmc/_pnkjyubmn1c_2_AV_WC_RCWORST_min.lib.gz\
    ${::IMEX::libVar}/mmmc/_dyqn9udjnhi_8_AV_WC_RCWORST_min.lib.gz\
    ${::IMEX::libVar}/mmmc/_dyqn9udjnhi_7_AV_WC_RCWORST_min.lib.gz\
    ${::IMEX::libVar}/mmmc/_dyqn9udjnhi_6_AV_WC_RCWORST_min.lib.gz\
    ${::IMEX::libVar}/mmmc/_kmcyy4g8mbb_6_AV_WC_RCWORST_min.lib.gz\
    ${::IMEX::libVar}/mmmc/_bofiw7zs7vj_6_AV_WC_RCWORST_min.lib.gz\
    ${::IMEX::libVar}/mmmc/_pnkjyubmn1c_1_AV_WC_RCWORST_min.lib.gz\
    ${::IMEX::libVar}/mmmc/_dyqn9udjnhi_5_AV_WC_RCWORST_min.lib.gz\
    ${::IMEX::libVar}/mmmc/_dyqn9udjnhi_4_AV_WC_RCWORST_min.lib.gz\
    ${::IMEX::libVar}/mmmc/_dyqn9udjnhi_3_AV_WC_RCWORST_min.lib.gz\
    ${::IMEX::libVar}/mmmc/_kmcyy4g8mbb_1_AV_WC_RCWORST_min.lib.gz\
    ${::IMEX::libVar}/mmmc/_bofiw7zs7vj_5_AV_WC_RCWORST_min.lib.gz\
    ${::IMEX::libVar}/mmmc/_pnkjyubmn1c_AV_WC_RCWORST_min.lib.gz\
    ${::IMEX::libVar}/mmmc/_dyqn9udjnhi_2_AV_WC_RCWORST_min.lib.gz\
    ${::IMEX::libVar}/mmmc/_dyqn9udjnhi_1_AV_WC_RCWORST_min.lib.gz\
    ${::IMEX::libVar}/mmmc/_dyqn9udjnhi_AV_WC_RCWORST_min.lib.gz\
    ${::IMEX::libVar}/mmmc/_kmcyy4g8mbb_5_AV_WC_RCWORST_min.lib.gz\
    ${::IMEX::libVar}/mmmc/_bofiw7zs7vj_1_AV_WC_RCWORST_min.lib.gz\
    ${::IMEX::libVar}/mmmc/_fuznrwegsgm_2_AV_WC_RCWORST_min.lib.gz\
    ${::IMEX::libVar}/mmmc/_kmcyy4g8mbb_4_AV_WC_RCWORST_min.lib.gz\
    ${::IMEX::libVar}/mmmc/_bofiw7zs7vj_4_AV_WC_RCWORST_min.lib.gz\
    ${::IMEX::libVar}/mmmc/_fuznrwegsgm_1_AV_WC_RCWORST_min.lib.gz\
    ${::IMEX::libVar}/mmmc/_kmcyy4g8mbb_3_AV_WC_RCWORST_min.lib.gz\
    ${::IMEX::libVar}/mmmc/_bofiw7zs7vj_3_AV_WC_RCWORST_min.lib.gz\
    ${::IMEX::libVar}/mmmc/_fuznrwegsgm_AV_WC_RCWORST_min.lib.gz\
    ${::IMEX::libVar}/mmmc/_kmcyy4g8mbb_AV_WC_RCWORST_min.lib.gz\
    ${::IMEX::libVar}/mmmc/_bofiw7zs7vj_AV_WC_RCWORST_min.lib.gz]
create_library_set -name LIBSET_WC_budgeting_max\
   -timing\
    [list [list ${::IMEX::libVar}/mmmc/tcbn28hpcplusbwp30p140ssg0p72v125c.lib\
          ${::IMEX::libVar}/mmmc/tsdn28hpcpuhdb64x128m4mwa_170a_ssg0p81v125c.lib\
          ${::IMEX::libVar}/mmmc/tsdn28hpcpuhdb64x64m4mwa_170a_ssg0p81v125c.lib\
          ${::IMEX::libVar}/mmmc/ts6n28hpcphvta16x16m2fwbso_200b_ssg0p81v125c.lib\
          ${::IMEX::libVar}/mmmc/ts6n28hpcphvta16x32m2fwbso_200b_ssg0p81v125c.lib\
          ${::IMEX::libVar}/mmmc/tphn28hpcpgv18ssg0p81v1p62v125c.lib]\
    ${::IMEX::libVar}/mmmc/_auoccatktx4_2_AV_WC_RCWORST_max.lib.gz\
    ${::IMEX::libVar}/mmmc/_kmcyy4g8mbb_8_AV_WC_RCWORST_max.lib.gz\
    ${::IMEX::libVar}/mmmc/_bofiw7zs7vj_8_AV_WC_RCWORST_max.lib.gz\
    ${::IMEX::libVar}/mmmc/_auoccatktx4_1_AV_WC_RCWORST_max.lib.gz\
    ${::IMEX::libVar}/mmmc/_kmcyy4g8mbb_7_AV_WC_RCWORST_max.lib.gz\
    ${::IMEX::libVar}/mmmc/_bofiw7zs7vj_7_AV_WC_RCWORST_max.lib.gz\
    ${::IMEX::libVar}/mmmc/_auoccatktx4_AV_WC_RCWORST_max.lib.gz\
    ${::IMEX::libVar}/mmmc/_kmcyy4g8mbb_2_AV_WC_RCWORST_max.lib.gz\
    ${::IMEX::libVar}/mmmc/_bofiw7zs7vj_2_AV_WC_RCWORST_max.lib.gz\
    ${::IMEX::libVar}/mmmc/_pnkjyubmn1c_2_AV_WC_RCWORST_max.lib.gz\
    ${::IMEX::libVar}/mmmc/_dyqn9udjnhi_8_AV_WC_RCWORST_max.lib.gz\
    ${::IMEX::libVar}/mmmc/_dyqn9udjnhi_7_AV_WC_RCWORST_max.lib.gz\
    ${::IMEX::libVar}/mmmc/_dyqn9udjnhi_6_AV_WC_RCWORST_max.lib.gz\
    ${::IMEX::libVar}/mmmc/_kmcyy4g8mbb_6_AV_WC_RCWORST_max.lib.gz\
    ${::IMEX::libVar}/mmmc/_bofiw7zs7vj_6_AV_WC_RCWORST_max.lib.gz\
    ${::IMEX::libVar}/mmmc/_pnkjyubmn1c_1_AV_WC_RCWORST_max.lib.gz\
    ${::IMEX::libVar}/mmmc/_dyqn9udjnhi_5_AV_WC_RCWORST_max.lib.gz\
    ${::IMEX::libVar}/mmmc/_dyqn9udjnhi_4_AV_WC_RCWORST_max.lib.gz\
    ${::IMEX::libVar}/mmmc/_dyqn9udjnhi_3_AV_WC_RCWORST_max.lib.gz\
    ${::IMEX::libVar}/mmmc/_kmcyy4g8mbb_1_AV_WC_RCWORST_max.lib.gz\
    ${::IMEX::libVar}/mmmc/_bofiw7zs7vj_5_AV_WC_RCWORST_max.lib.gz\
    ${::IMEX::libVar}/mmmc/_pnkjyubmn1c_AV_WC_RCWORST_max.lib.gz\
    ${::IMEX::libVar}/mmmc/_dyqn9udjnhi_2_AV_WC_RCWORST_max.lib.gz\
    ${::IMEX::libVar}/mmmc/_dyqn9udjnhi_1_AV_WC_RCWORST_max.lib.gz\
    ${::IMEX::libVar}/mmmc/_dyqn9udjnhi_AV_WC_RCWORST_max.lib.gz\
    ${::IMEX::libVar}/mmmc/_kmcyy4g8mbb_5_AV_WC_RCWORST_max.lib.gz\
    ${::IMEX::libVar}/mmmc/_bofiw7zs7vj_1_AV_WC_RCWORST_max.lib.gz\
    ${::IMEX::libVar}/mmmc/_fuznrwegsgm_2_AV_WC_RCWORST_max.lib.gz\
    ${::IMEX::libVar}/mmmc/_kmcyy4g8mbb_4_AV_WC_RCWORST_max.lib.gz\
    ${::IMEX::libVar}/mmmc/_bofiw7zs7vj_4_AV_WC_RCWORST_max.lib.gz\
    ${::IMEX::libVar}/mmmc/_fuznrwegsgm_1_AV_WC_RCWORST_max.lib.gz\
    ${::IMEX::libVar}/mmmc/_kmcyy4g8mbb_3_AV_WC_RCWORST_max.lib.gz\
    ${::IMEX::libVar}/mmmc/_bofiw7zs7vj_3_AV_WC_RCWORST_max.lib.gz\
    ${::IMEX::libVar}/mmmc/_fuznrwegsgm_AV_WC_RCWORST_max.lib.gz\
    ${::IMEX::libVar}/mmmc/_kmcyy4g8mbb_AV_WC_RCWORST_max.lib.gz\
    ${::IMEX::libVar}/mmmc/_bofiw7zs7vj_AV_WC_RCWORST_max.lib.gz]
create_timing_condition -name cond_worst_budgeting_max\
   -library_sets [list LIBSET_WC_budgeting_max]\
   -opcond ssg0p72v125c\
   -opcond_library tcbn28hpcplusbwp30p140ssg0p72v125c
create_timing_condition -name cond_worst_budgeting_min\
   -library_sets [list LIBSET_WC_budgeting_min]\
   -opcond ssg0p72v125c\
   -opcond_library tcbn28hpcplusbwp30p140ssg0p72v125c
create_timing_condition -name cond_best\
   -library_sets [list LIBSET_BC]\
   -opcond ff1p05vm40c\
   -opcond_library tcbn28hpcplusbwp30p140ffg1p05vm40c
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
   -early_timing_condition {cond_worst_budgeting_min}\
   -late_timing_condition {cond_worst_budgeting_max}\
   -rc_corner rc_worst
create_delay_corner -name BC_dc\
   -timing_condition {cond_best}\
   -rc_corner rc_best
create_constraint_mode -name CM\
   -sdc_files\
    [list ${::IMEX::dataVar}/mmmc/modes/CM/CM.sdc.gz]\
   -ilm_sdc_files\
    [list ${::IMEX::libVar}/mmmc/CM.sdc.gz]
create_constraint_mode -name CM_AV_WC_RCWORST\
   -sdc_files\
    [list ${::IMEX::dataVar}/mmmc/modes/CM_AV_WC_RCWORST/CM_AV_WC_RCWORST.sdc.gz]\
   -ilm_sdc_files\
    [list ${::IMEX::libVar}/mmmc/CM_AV_WC_RCWORST.sdc.gz]
create_analysis_view -name AV_WC_RCWORST -constraint_mode CM_AV_WC_RCWORST -delay_corner WC_dc
create_analysis_view -name AV_BC_RCBEST -constraint_mode CM -delay_corner BC_dc
set_analysis_view -setup [list AV_WC_RCWORST] -hold [list AV_WC_RCWORST AV_BC_RCBEST]
catch {set_interactive_constraint_mode [list CM CM_AV_WC_RCWORST] } 
