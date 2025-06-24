#!/bin/bash

# Absolute or relative path to the design_variables.tcl
TCL_PATH="../phy/scr/design_variables.tcl"

# Extract the partition list using tclsh
partition_list=$(tclsh <<EOF
source "$TCL_PATH"
puts \$partition_module_list
EOF
)

# Loop through each partition
for partition in $partition_list; do
  echo "-------------------------------------------"
  echo "Processing partition: $partition"
  echo "-------------------------------------------"

  # Export partition name as an env var
  export PARTITION_NAME=$partition

  # Run Innovus in batch mode (sequential version)
  innovus -stylus -batch -files run_partition_pnr.tcl 2>&1 | tee log_${partition}.txt
done

echo "✅ All partitions processed successfully."

