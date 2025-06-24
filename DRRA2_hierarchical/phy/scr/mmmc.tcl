
create_library_set -name LIBSET_TC -timing [list $LIB_FILES_TC]
create_library_set -name LIBSET_BC -timing [list $LIB_FILES_BC]
create_library_set -name LIBSET_WC -timing [list $LIB_FILES_WC]

create_rc_corner -name rc_best \
    -pre_route_res 1 \
    -post_route_res 1 \
    -pre_route_cap 1 \
    -post_route_cap 1 \
    -post_route_cross_cap 1 \
    -post_route_clock_res 0 \
    -post_route_clock_cap 0 \
	  -qrc_tech $QRC_FILE_BC \

create_rc_corner -name rc_typ \
    -pre_route_res 1 \
    -post_route_res 1 \
    -pre_route_cap 1 \
    -post_route_cap 1 \
    -post_route_cross_cap 1 \
    -post_route_clock_res 0 \
    -post_route_clock_cap 0 \
    -qrc_tech $QRC_FILE_TC \

create_rc_corner -name rc_worst \
    -pre_route_res 1 \
    -post_route_res 1 \
    -pre_route_cap 1 \
    -post_route_cap 1 \
    -post_route_cross_cap 1 \
    -post_route_clock_res 0 \
    -post_route_clock_cap 0 \
    -qrc_tech $QRC_FILE_WC \

create_timing_condition \
    -name cond_best \
    -library_set LIBSET_BC \
    -opcond $OP_COD_BC \
    -opcond_library $OP_COD_LIB_BC

create_timing_condition \
    -name cond_typ \
    -library_set LIBSET_TC \
    -opcond $OP_COD_TC \
    -opcond_library $OP_COD_LIB_TC

create_timing_condition \
    -name cond_worst \
    -library_set LIBSET_WC \
    -opcond $OP_COD_WC \
    -opcond_library $OP_COD_LIB_WC

create_timing_condition \
    -name cond_sram_worst \
    -library_sets LIBSET_WC \
    -opcond $OP_COD_SRAM_WC \
    -opcond_library $OP_COD_LIB_SRAM_WC
create_timing_condition \
    -name cond_sram_typ \
    -library_sets LIBSET_TC \
    -opcond $OP_COD_SRAM_TC \
    -opcond_library $OP_COD_LIB_SRAM_TC
create_timing_condition \
    -name cond_sram_best \
    -library_sets LIBSET_BC \
    -opcond $OP_COD_SRAM_BC \
    -opcond_library $OP_COD_LIB_SRAM_BC

create_delay_corner \
    -name WC_dc \
    -rc_corner rc_worst \
    -timing_condition {cond_worst cond_sram_worst}

create_delay_corner \
    -name TC_dc \
    -rc_corner rc_typ \
    -timing_condition {cond_typ cond_sram_typ}

create_delay_corner \
    -name BC_dc \
    -rc_corner rc_best \
    -timing_condition {cond_best cond_sram_best}

create_constraint_mode -name CM -sdc_files [list $SDC_FILES]
#create_constraint_mode -name CM_POST -sdc_files [list $SDC_FILES_POSTCTS]

create_analysis_view -name AV_WC_RCWORST -constraint_mode CM -delay_corner WC_dc
create_analysis_view -name AV_BC_RCBEST  -constraint_mode CM -delay_corner BC_dc
create_analysis_view -name AV_TC_RCTYP   -constraint_mode CM -delay_corner TC_dc
#create_analysis_view -name AV_WC_RCWORST_POST -constraint_mode CM_POST -delay_corner WC_dc
#create_analysis_view -name AV_BC_RCBEST_POST  -constraint_mode CM_POST -delay_corner BC_dc
#create_analysis_view -name AV_TC_RCTYP_POST   -constraint_mode CM_POST -delay_corner TC_dc

#set_analysis_view -setup "AV_WC_RCWORST AV_WC_RCWORST_POST" -hold "AV_WC_RCWORST AV_BC_RCBEST AV_TC_RCTYP AV_WC_RCWORST_POST AV_BC_RCBEST_POST AV_TC_RCTYP_POST"

set_analysis_view -setup "AV_WC_RCWORST" -hold "AV_WC_RCWORST AV_BC_RCBEST"

