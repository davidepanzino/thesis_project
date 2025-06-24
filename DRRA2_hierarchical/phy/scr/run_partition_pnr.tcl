# Read partition name from shell environment
set partition_name $::env(PARTITION_NAME)

puts "===> Running PnR for partition: $partition_name"

# Navigate to partition database directory
cd ../phy/db/part/${partition_name}.enc.dat/

# Load the design
read_db .

# Standard PnR flow
place_opt_design
opt_design -pre_cts
clock_opt_design
opt_design -post_cts
opt_design -post_cts -hold
opt_design -post_cts -setup -hold
route_design
opt_design -post_route
opt_design -post_route
opt_design -post_route -hold
opt_design -post_route -setup -hold

# Save the updated design
write_db ./pnr/

# Write ILM for partition
write_ilm

