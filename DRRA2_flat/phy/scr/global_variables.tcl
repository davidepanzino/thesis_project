set STDC_NLDM_DIR "/opt/pdk/tsmc28/CMOS/HPC+/stclib/9-track/tcbn28hpcplusbwp30p140-set/tcbn28hpcplusbwp30p140_190a_FE/TSMCHOME/digital/Front_End/timing_power_noise/NLDM"
set SRAM_NLDM_DIR "/opt/pdk/tsmc28/SRAM/macros/tsdn28hpcpuhdb64x128m4mwa_170a/NLDM"
set SRAM1_NLDM_DIR "/opt/pdk/tsmc28/SRAM/macros/tsdn28hpcpuhdb64x64m4mwa_170a/NLDM"
set RF_NLDM_DIR "/opt/pdk/tsmc28/SRAM/macros/ts6n28hpcphvta16x16m2fwbso_200b/NLDM"
set RF1_NLDM_DIR "/opt/pdk/tsmc28/SRAM/macros/ts6n28hpcphvta16x32m2fwbso_200b/NLDM"
set IO_NLDM_DIR "/opt/pdk/tsmc28/CMOS/HPC+/IO1.8V/iolib/STAGGERED/tphn28hpcpgv18_170d_FE/TSMCHOME/digital/Front_End/timing_power_noise/NLDM"
set TECH_LEF_DIR "/opt/pdk/tsmc28/CMOS/util/PRTF_EDI_28nm_Cad_V19_1a"
set STDC_LEF_DIR  "/opt/pdk/tsmc28/CMOS/HPC+/stclib/9-track/tcbn28hpcplusbwp30p140-set/tcbn28hpcplusbwp30p140_190a_FE/TSMCHOME/digital/Back_End/lef"
set SRAM_LEF_DIR  "/opt/pdk/tsmc28/SRAM/macros/tsdn28hpcpuhdb64x128m4mwa_170a/LEF"
set SRAM1_LEF_DIR  "/opt/pdk/tsmc28/SRAM/macros/tsdn28hpcpuhdb64x64m4mwa_170a/LEF"
set RF_LEF_DIR "/opt/pdk/tsmc28/SRAM/macros/ts6n28hpcphvta16x16m2fwbso_200b/LEF"
set RF1_LEF_DIR "/opt/pdk/tsmc28/SRAM/macros/ts6n28hpcphvta16x32m2fwbso_200b/LEF"
set IO_LEF_DIR "/opt/pdk/tsmc28/CMOS/HPC+/IO1.8V/iolib/STAGGERED/tphn28hpcpgv18_170d_FE/TSMCHOME/digital/Back_End/lef"
set IO_BONDPAD_LEF_DIR "/opt/pdk/tsmc28/iolib/tpbn28v_160a_FE/TSMCHOME/digital/Back_End/lef"
set STDC_QRC_DIR  "/opt/pdk/tsmc28/QRC"

set LEF_FILE "${TECH_LEF_DIR}/tsmcn28_9lm5X1Y1Z1UUTRDL.tlef \
              ${STDC_LEF_DIR}/tcbn28hpcplusbwp30p140_110a/lef/tcbn28hpcplusbwp30p140.lef \
              ${SRAM_LEF_DIR}/tsdn28hpcpuhdb64x128m4mwa_170a.lef \
              ${SRAM1_LEF_DIR}/tsdn28hpcpuhdb64x64m4mwa_170a.lef \
              ${RF_LEF_DIR}/ts6n28hpcphvta16x16m2fwbso_200b.lef \
              ${RF1_LEF_DIR}/ts6n28hpcphvta16x32m2fwbso_200b.lef \
              ${IO_LEF_DIR}/tphn28hpcpgv18_110a/mt_2/8lm/lef/tphn28hpcpgv18_8lm.lef \
              ${IO_BONDPAD_LEF_DIR}/tpbn28v_160a/cup/9m/9M_5X1Y1Z1U/lef/tpbn28v_9lm.lef"

set LIB_FILES_BC "${STDC_NLDM_DIR}/tcbn28hpcplusbwp30p140_180a/tcbn28hpcplusbwp30p140ffg1p05vm40c.lib \
                  ${SRAM_NLDM_DIR}/tsdn28hpcpuhdb64x128m4mwa_170a_ffg1p05vm40c.lib \
                  ${SRAM1_NLDM_DIR}/tsdn28hpcpuhdb64x64m4mwa_170a_ffg1p05vm40c.lib \
                  ${RF_NLDM_DIR}/ts6n28hpcphvta16x16m2fwbso_200b_ffg1p05vm40c.lib \
                  ${RF1_NLDM_DIR}/ts6n28hpcphvta16x32m2fwbso_200b_ffg1p05vm40c.lib \
                  ${IO_NLDM_DIR}/tphn28hpcpgv18_170a/tphn28hpcpgv18ffg0p99v1p98vm40c.lib"
set LIB_FILES_TC "${STDC_NLDM_DIR}/tcbn28hpcplusbwp30p140_180a/tcbn28hpcplusbwp30p140tt0p9v25c.lib \
                  ${SRAM_NLDM_DIR}/tsdn28hpcpuhdb64x128m4mwa_170a_tt0p9v25c.lib \
                  ${SRAM1_NLDM_DIR}/tsdn28hpcpuhdb64x64m4mwa_170a_tt0p9v25c.lib \
                  ${RF_NLDM_DIR}/ts6n28hpcphvta16x16m2fwbso_200b_tt0p9v25c.lib \
                  ${RF1_NLDM_DIR}/ts6n28hpcphvta16x32m2fwbso_200b_tt0p9v25c.lib \
                  ${IO_NLDM_DIR}/tphn28hpcpgv18_170a/tphn28hpcpgv18tt0p9v1p8v25c.lib"
set LIB_FILES_WC "${STDC_NLDM_DIR}/tcbn28hpcplusbwp30p140_180a/tcbn28hpcplusbwp30p140ssg0p72v125c.lib \
                  ${SRAM_NLDM_DIR}/tsdn28hpcpuhdb64x128m4mwa_170a_ssg0p81v125c.lib \
                  ${SRAM1_NLDM_DIR}/tsdn28hpcpuhdb64x64m4mwa_170a_ssg0p81v125c.lib \
                  ${RF_NLDM_DIR}/ts6n28hpcphvta16x16m2fwbso_200b_ssg0p81v125c.lib \
                  ${RF1_NLDM_DIR}/ts6n28hpcphvta16x32m2fwbso_200b_ssg0p81v125c.lib \
                  ${IO_NLDM_DIR}/tphn28hpcpgv18_170a/tphn28hpcpgv18ssg0p81v1p62v125c.lib"

set OP_COD_LIB_BC "tcbn28hpcplusbwp30p140ffg1p05vm40c"
set OP_COD_LIB_TC "tcbn28hpcplusbwp30p140tt0p9v25c"
set OP_COD_LIB_WC "tcbn28hpcplusbwp30p140ssg0p72v125c"

set OP_COD_LIB_SRAM_BC "tsdn28hpcpuhdb64x128m4mwa_170a_ffg1p05vm40c"
set OP_COD_LIB_SRAM_TC "tsdn28hpcpuhdb64x128m4mwa_170a_tt0p9v25c"
set OP_COD_LIB_SRAM_WC "tsdn28hpcpuhdb64x128m4mwa_170a_ssg0p81v125c"

set OP_COD_LIB_SRAM1_BC "tsdn28hpcpuhdb64x64m4mwa_170a_ffg1p05vm40c"
set OP_COD_LIB_SRAM1_TC "tsdn28hpcpuhdb64x64m4mwa_170a_tt0p9v25c"
set OP_COD_LIB_SRAM1_WC "tsdn28hpcpuhdb64x64m4mwa_170a_ssg0p81v125c"

set OP_COD_LIB_RF_BC "ts6n28hpcphvta16x16m2fwbso_200b_ffg1p05vm40c"
set OP_COD_LIB_RF_TC "ts6n28hpcphvta16x16m2fwbso_200b_tt0p9v25c"
set OP_COD_LIB_RF_WC "ts6n28hpcphvta16x16m2fwbso_200b_ssg0p81v125c"

set OP_COD_LIB_RF1_BC "ts6n28hpcphvta16x32m2fwbso_200b_ffg1p05vm40c"
set OP_COD_LIB_RF1_TC "ts6n28hpcphvta16x32m2fwbso_200b_tt0p9v25c"
set OP_COD_LIB_RF1_WC "ts6n28hpcphvta16x32m2fwbso_200b_ssg0p81v125c"

set OP_COD_LIB_IO_BC "tphn28hpcpgv18ffg0p99v1p98vm40c"
set OP_COD_LIB_IO_TC "tphn28hpcpgv18tt0p9v1p8v25c"
set OP_COD_LIB_IO_WC "tphn28hpcpgv18ssg0p81v1p62v125c"

set OP_COD_BC "ff1p05vm40c"
set OP_COD_TC "tt0p9v25c"
set OP_COD_WC "ssg0p72v125c"
set OP_COD_SRAM_BC "ff1p05vm40c"
set OP_COD_SRAM_TC "tt0p9v25c"
set OP_COD_SRAM_WC "ssg0p81v125c"
set OP_COD_SRAM1_BC "ff1p05vm40c"
set OP_COD_SRAM1_TC "tt0p9v25c"
set OP_COD_SRAM1_WC "ssg0p81v125c"
set OP_COD_RF_BC "ffg1p05vm40c"
set OP_COD_RF_TC "tt0p9v25c"
set OP_COD_RF_WC "ssg0p81v125c"
set OP_COD_RF1_BC "ffg1p05vm40c"
set OP_COD_RF1_TC "tt0p9v25c"
set OP_COD_RF1_WC "ssg0p81v125c"
set OP_COD_IO_BC "ffg0p99v1p98vm40c"
set OP_COD_IO_TC "tt0p9v1p8v25c"
set OP_COD_IO_WC "ssg0p81v1p62v125c"

set QRC_FILE_BC "${STDC_QRC_DIR}/RC_QRC_crn28hpc+_1p09m+ut-alrdl_5x1y1z1u_rcbest/qrcTechFile"
set QRC_FILE_TC "${STDC_QRC_DIR}/RC_QRC_crn28hpc+_1p09m+ut-alrdl_5x1y1z1u_typical/qrcTechFile"
set QRC_FILE_WC "${STDC_QRC_DIR}/RC_QRC_crn28hpc+_1p09m+ut-alrdl_5x1y1z1u_rcworst/qrcTechFile"

#set lib_name tcbn28hpcplusbwp30p140ssg0p72v125c
#set op_conds ssg0p72v125c

set PROCESS_NODE 28

set NUM_CPUS 8

set TOP_NAME fabric

# Directories
set OUT_NAME   "${TOP_NAME}"
set VERSION    "eco_3.54"
set OUTPUT_DIR "../phy/db"
set SAVE_DIR   "../phy/save"
set RPT_DIR    "../phy/rpt"
set SCR_DIR    "../phy/scr"
set PART_DIR   "../phy/db/part"
set SRC_DIR    "../syn/db"


set MMMC_FILE          "${SCR_DIR}/mmmc.tcl"
set NETLIST_FILE       "${SRC_DIR}/${TOP_NAME}.v"
set SDC_FILES_POSTCTS  "${SRC_DIR}/${TOP_NAME}_postcts.sdc"
set SDC_FILES          "${SRC_DIR}/constraints.sdc"

