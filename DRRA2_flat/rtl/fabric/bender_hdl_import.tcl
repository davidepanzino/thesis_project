# This script was generated automatically by bender.
if [ info exists search_path ] {
    set search_path_initial $search_path
} else {
    set search_path_initial {}
}
set ROOT "/home/finazzi/Desktop/9_june/rtl/fabric"

set search_path $search_path_initial
set_db init_hdl_search_path $search_path

read_hdl -language sv \
    -define { \
        TARGET_GENUS \
        TARGET_SYNTHESIS \
    } \
    [list \
        "/home/finazzi/Desktop/9_june/rtl/common/agu/./rtl/agu.sv" \
    ]

set search_path $search_path_initial
set_db init_hdl_search_path $search_path

read_hdl -language sv \
    -define { \
        TARGET_GENUS \
        TARGET_SYNTHESIS \
    } \
    [list \
        "/home/finazzi/Desktop/9_june/rtl/common/fsm/./rtl/fsm.sv" \
    ]

set search_path $search_path_initial
set_db init_hdl_search_path $search_path

read_hdl -language sv \
    -define { \
        TARGET_GENUS \
        TARGET_SYNTHESIS \
        TARGET_TSMC28 \
    } \
    [list \
        "/home/finazzi/Desktop/9_june/rtl/common/sram/./rtl/sram:tsmc28.sv" \
    ]

set search_path $search_path_initial
set_db init_hdl_search_path $search_path

read_hdl -language sv \
    -define { \
        TARGET_GENUS \
        TARGET_SYNTHESIS \
    } \
    [list \
        "/home/finazzi/Desktop/9_june/rtl/resources/dpu_impl__pnkjyubmn1c/./rtl/dpu_pkg.sv" \
        "/home/finazzi/Desktop/9_june/rtl/resources/dpu_impl__pnkjyubmn1c/./rtl/adder.sv" \
        "/home/finazzi/Desktop/9_june/rtl/resources/dpu_impl__pnkjyubmn1c/./rtl/multiplier.sv" \
        "/home/finazzi/Desktop/9_june/rtl/resources/dpu_impl__pnkjyubmn1c/./rtl/dpu.sv" \
    ]

set search_path $search_path_initial
set_db init_hdl_search_path $search_path

read_hdl -language sv \
    -define { \
        TARGET_GENUS \
        TARGET_SYNTHESIS \
    } \
    [list \
        "/home/finazzi/Desktop/9_june/rtl/resources/iosram_btm_impl__auoccatktx4/./rtl/iosram_btm_pkg.sv" \
        "/home/finazzi/Desktop/9_june/rtl/resources/iosram_btm_impl__auoccatktx4/./rtl/iosram_btm.sv" \
    ]

set search_path $search_path_initial
set_db init_hdl_search_path $search_path

read_hdl -language sv \
    -define { \
        TARGET_GENUS \
        TARGET_SYNTHESIS \
    } \
    [list \
        "/home/finazzi/Desktop/9_june/rtl/resources/iosram_top_impl__fuznrwegsgm/./rtl/iosram_top_pkg.sv" \
        "/home/finazzi/Desktop/9_june/rtl/resources/iosram_top_impl__fuznrwegsgm/./rtl/iosram_top.sv" \
    ]

set search_path $search_path_initial
set_db init_hdl_search_path $search_path

read_hdl -language sv \
    -define { \
        TARGET_GENUS \
        TARGET_SYNTHESIS \
    } \
    [list \
        "/home/finazzi/Desktop/9_june/rtl/resources/rf_impl__dyqn9udjnhi/./rtl/rf_pkg.sv" \
        "/home/finazzi/Desktop/9_june/rtl/resources/rf_impl__dyqn9udjnhi/./rtl/rf.sv" \
    ]

set search_path $search_path_initial
set_db init_hdl_search_path $search_path

read_hdl -language sv \
    -define { \
        TARGET_GENUS \
        TARGET_SYNTHESIS \
    } \
    [list \
        "/home/finazzi/Desktop/9_june/rtl/controllers/sequencer_impl__bofiw7zs7vj/./rtl/sequencer.sv" \
    ]

set search_path $search_path_initial
set_db init_hdl_search_path $search_path

read_hdl -language sv \
    -define { \
        TARGET_GENUS \
        TARGET_SYNTHESIS \
    } \
    [list \
        "/home/finazzi/Desktop/9_june/rtl/resources/swb_impl__kmcyy4g8mbb/./rtl/swb_pkg.sv" \
        "/home/finazzi/Desktop/9_june/rtl/resources/swb_impl__kmcyy4g8mbb/./rtl/swb.sv" \
    ]

set search_path $search_path_initial
set_db init_hdl_search_path $search_path

read_hdl -language sv \
    -define { \
        TARGET_GENUS \
        TARGET_SYNTHESIS \
    } \
    [list \
        "/home/finazzi/Desktop/9_june/rtl/cells/cell_btm_impl__utrqvpzgeyt/./rtl/cell_btm.sv" \
    ]

set search_path $search_path_initial
set_db init_hdl_search_path $search_path

read_hdl -language sv \
    -define { \
        TARGET_GENUS \
        TARGET_SYNTHESIS \
    } \
    [list \
        "/home/finazzi/Desktop/9_june/rtl/cells/cell_mid_impl__jz3bdsce94z/./rtl/cell_mid.sv" \
    ]

set search_path $search_path_initial
set_db init_hdl_search_path $search_path

read_hdl -language sv \
    -define { \
        TARGET_GENUS \
        TARGET_SYNTHESIS \
    } \
    [list \
        "/home/finazzi/Desktop/9_june/rtl/cells/cell_top_impl__wd4bmxzzxrs/./rtl/cell_top.sv" \
    ]

set search_path $search_path_initial
set_db init_hdl_search_path $search_path

read_hdl -language sv \
    -define { \
        TARGET_GENUS \
        TARGET_SYNTHESIS \
    } \
    [list \
        "$ROOT/./rtl/fabric.sv" \
    ]

set search_path $search_path_initial
