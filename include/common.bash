#!/bin/bash
#
# Common functions.
#

#
# Script constants.
#
XILINX=/Xilinx/SDK/2015.2
ECLIPSE=$XILINX/eclipse/lnx64.o/eclipse
JVM=$XILINX/tps/lnx64/jre/bin

#
# Initialize the Xilinx SDK environment.
#
function xilinx_init() {
    # Check if in windows environment
    if uname | grep -iq "mingw"; then
        # Currently on windows, change the xilinx directories
        log "Setting directories for windows environment"
        XILINX=/c/Xilinx/SDK/2015.2
        ECLIPSE=$XILINX/eclipse/win64.o/eclipsec.exe
        JVM=$XILINX/tps/win64/jre/bin
        
        # For windows also add GNU utilities to path, in particular need 'make'
        PATH=$PATH:$XILINX/gnuwin/bin
    fi

    # Load the xilinx sdk environment settings
    log "Loading xilinx sdk settings"
    source "$XILINX/settings64.sh"
}

#
# Log message.
#
# @param message Message to log.
#
function log () {
    printf "\n${FUNCNAME[1]}: $1\n"
}
