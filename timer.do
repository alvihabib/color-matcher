# cd "C:/altera_lite/16.0/labFinalProject/ColorMatcher"

# Set the working dir, where all compiled Verilog goes.
vlib work

# Compile all Verilog modules in mux.v to working dir;
# could also have multiple Verilog files.
# The timescale argument defines default time unit
# (used when no unit is specified), while the second number
# defines precision (all times are rounded to this value)
vlog -timescale 1ns/1ns timer.v


# Load simulation using mux as the top level simulation module.
vsim timer

# Log all signals and add some signals to waveform window.
log {/*}
# add wave {/*} would add all items in top level simulation module.
add wave {/*}

# First test case
# Set input values using the force command, signal names need to be in {} brackets.

# Clock posedge every 2 ns
force {clk} 0 0, 1 2 -r 4
run 4ns

# Initialize
force {resetn} 0
force {enable} 0
run 50ns

force {resetn} 1
force {enable} 1
run 5000ns

force {resetn} 0
force {enable} 0
run 50ns
