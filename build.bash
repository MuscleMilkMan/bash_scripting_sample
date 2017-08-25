#!/bin/bash
#
# Performs firmware build and uploads it to maven.
#

# Stop and exit on any script error
set -e

#
# Command line switches
#
switch_bsp=
switch_push=false
switch_release=

#
# Main function, script entry point.
#
main() {
    # Set the switches from the command line arguments
    set_command_line_switches $@

    # Load all files in the include folder
    for include_file in bred_builder/include/*; do
        source $include_file
    done

    # Initialize the Xilinx environment
    xilinx_init

    # Delete/clone repositories
    git_delete_all
    git_clone_all $switch_bsp $switch_release

    # Set the build version information
    version_set_repo_all
    
    # Set the build number - using last number
    buildnumber_create
    
    # Build the hardware bsp
    bsp_build_all
    
    # Import the eclipse projects, then build the apps
    eclipse_delete_workspace
    eclipse_import_all
    eclipse_build_all
    
    # Push artifacts to maven
    if [ "$switch_push" = true ] ; then
        maven_push_all $switch_release
    fi
}

#
# Parses command line arguments. Sets the command line switches into switch_* variables.
#
# @param Variable argument, all commmand line arguments to script.
#
function set_command_line_switches() {
    # Parse the arguments using the expected command line options
    parsed_options=`getopt -o b:pr: --long bsp:,push,release: -n 'parse-options' -- "$@"`
    if [ $? != 0 ] ; then echo "Failed parsing options." >&2 ; exit 1 ; fi
    
    # Print out then set the options
    echo "Options: $parsed_options"
    eval set -- "$parsed_options"

    # Set each switch
    while true; do
        case "$1" in
            -b | --bsp ) switch_bsp=$2; shift; shift ;;
            -p | --push ) switch_push=true; shift ;;
            -r | --release ) switch_release=$2; shift; shift ;;
            -- ) shift; break ;;
            * ) break ;;
        esac
    done
    
    # Check for required options
    if [ -z $switch_bsp ]; then
        echo "Error: -b|--bsp required, BSP to use must be specified"
        exit 1
    fi
}

# Execute the main function
main "$@"
