#! /bin/bash

# check if in exe directory
if [[ "$(basename $(pwd))" != "exe" ]]; then
    echo "Please run this script from the root directory of the project."
    return 1
fi

genus -f ../syn/scr/global_variables.tcl \
      -f ../syn/scr/library_variables.tcl \
      -f ../syn/scr/genus_topdown.tcl

