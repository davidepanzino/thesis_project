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
