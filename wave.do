# cd "C:/altera_lite/16.0/labFinalProject/ColorMatcher"

# Set the working dir, where all compiled Verilog goes.
vlib work

# Compile all Verilog modules in mux.v to working dir;
# could also have multiple Verilog files.
# The timescale argument defines default time unit
# (used when no unit is specified), while the second number
# defines precision (all times are rounded to this value)
vlog -timescale 1ns/1ns ColorMatcher.v
vlog -timescale 1ns/1ns control.v
vlog -timescale 1ns/1ns CardDisplay.v
vlog -timescale 1ns/1ns timer.v


# Load simulation using mux as the top level simulation module.
vsim ColorMatcher

# Log all signals and add some signals to waveform window.
log {/*}
# add wave {/*} would add all items in top level simulation module.
add wave {/*}

# First test case
# Set input values using the force command, signal names need to be in {} brackets.

# Clock posedge every 2 ns
force {CLOCK_50} 0 0, 1 2 -r 4
run 4ns

# Initialize SW and KEY
force {SW[2:0]} 000
force {KEY[3:0]} 1111
run 50ns

# Select level
force {SW[2:0]} 010
run 50ns

# Press Q
force {scan_code} 8'h15
run 17ns

# Press KEY3 and let go
force {KEY[3:0]} 0111
run 17ns
force {KEY[3:0]} 1111
run 16ns

# Press A
force {scan_code} 8'h1C
run 17ns

# Press KEY3 and let go
force {KEY[3:0]} 0111
run 17ns
force {KEY[3:0]} 1111
run 16ns

# Incorrect, press KEY3 and let go
force {KEY[3:0]} 0111
run 17ns
force {KEY[3:0]} 1111
run 16ns

# Press Q
force {scan_code} 8'h15
run 17ns

# Press KEY3 and let go
force {KEY[3:0]} 0111
run 17ns
force {KEY[3:0]} 1111
run 16ns

# Press S
force {scan_code} 8'h1B
run 17ns

# Press KEY3 and let go
force {KEY[3:0]} 0111
run 17ns
force {KEY[3:0]} 1111
run 16ns

# Press W
force {scan_code} 8'h1D
run 17ns

# Press KEY3 and let go
force {KEY[3:0]} 0111
run 17ns
force {KEY[3:0]} 1111
run 16ns

# Press E
force {scan_code} 8'h24
run 17ns

# Press KEY3 and let go
force {KEY[3:0]} 0111
run 17ns
force {KEY[3:0]} 1111
run 16ns

# Press A
force {scan_code} 8'h1C
run 17ns

# Press KEY3 and let go
force {KEY[3:0]} 0111
run 17ns
force {KEY[3:0]} 1111
run 16ns

# Press D
force {scan_code} 8'h23
run 17ns

# Press KEY3 and let go
force {KEY[3:0]} 0111
run 17ns
force {KEY[3:0]} 1111
run 166ns

# Turn SW off
force {SW[2:0]} 000
run 50ns

# Wipe screen @ SW 000
force {KEY[3:0]} 1110
run 25ns
force {KEY[3:0]} 1111
run 25ns

