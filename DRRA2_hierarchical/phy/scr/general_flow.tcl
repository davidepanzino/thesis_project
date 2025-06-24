

#The -hold option is not available with -pre_cts.
#-incremental does not work with setup and hold together

place_design
opt_design -pre_cts -incremental
clock_opt_design
opt_design -post_cts -incremental
route_design
opt_design -post_route -setup -hold


