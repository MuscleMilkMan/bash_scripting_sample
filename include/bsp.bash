#!/bin/bash
#
# Hardware BSP functions.
#

#
# Build all BSP projects.
#
function bsp_build_all() {
    log "Building all BSP projects"
    bsp_build "fpga_bigred_hdl/fpga/fpga.sdk/standalone_bsp_0"
}

#
# Build hardware BSP.
#
# @param bsp_path BSP path.
#
function bsp_build() {
    bsp_path=$1
    log "Building bsp=$bsp_path"
    
    # Save current working directory, then go to bsp path
    saved_directory=$PWD
    cd $bsp_path
    
    # Build the BSP
    make clean all
    
    # Return to the original working directory
    cd $saved_directory
}
