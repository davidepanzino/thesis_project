#!/bin/bash

# Based on license: 
MAX_PARALLEL=36

TCL_PATH="../phy/scr/design_variables.tcl"

partition_list=$(tclsh <<EOF
source "$TCL_PATH"
puts \$partition_module_list
EOF
)

# Counter of active jobs
job_count=0

for partition in $partition_list; do
  echo "-------------------------------------------"
  echo "Processing partition: $partition"
  echo "-------------------------------------------"

  export PARTITION_NAME=$partition

  # Run Innovus in background
  innovus -stylus -batch -files run_partition_pnr.tcl 2>&1 | tee log_${partition}.txt &

  # Increment active job count
  ((job_count++))

  # If we reached MAX_PARALLEL, wait for jobs to finish
  if ((job_count >= MAX_PARALLEL)); then
    echo "🚦 Waiting for $MAX_PARALLEL parallel jobs to finish..."
    wait
    job_count=0
  fi
done

# Final wait for any remaining jobs
wait

echo "✅ All partitions processed successfully."

