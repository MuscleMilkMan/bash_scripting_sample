#!/bin/bash
#
# Eclipse functions.
#

#
# Script constants.
#
WORKSPACE=workspace

#
# Delete the eclipse workspace.
#
function eclipse_delete_workspace {
    # Delete the workspace folder
    log "Deleting workspace folder"
    rm -rf "$WORKSPACE"
}

#
# Import all eclipse projects.
#
function eclipse_import_all() {
    log "Importing all projects to workspace"
    eclipse_import "bred_microblaze_core"
    eclipse_import "fpga_bigred_hdl/fpga/fpga.sdk/standalone_bsp_0"
    eclipse_import "fpga_bigred_hdl/fpga/fpga.sdk/top_hw_platform_0"
    eclipse_import "sensor-pod-sdk-c"
    eclipse_import "stm-fw"
}

#
# Build all app projects.
# 
function eclipse_build_all() {
    log "Building all app projects"
    eclipse_build "bred_csdk" "Debug"
    eclipse_build "bred_microblaze_core" "Debug"
}

#
# Import project to workspace.
#
# @param project_path Path to project.
#
function eclipse_import() {
    project_path=$1
    log "Importing project=$project_path" 
    
    $ECLIPSE -vm $JVM --launcher.suppressErrors -nosplash \
        -application org.eclipse.cdt.managedbuilder.core.headlessbuild \
        -import $project_path -data $WORKSPACE
}

#
# Build application.
#
# @param app_name Application name.
# @param app_config Application configuration to use.
#
function eclipse_build() {
    app_name=$1
    app_config=$2
    log "Building app=$app_name/$app_config" 
    
    $ECLIPSE -vm $JVM --launcher.suppressErrors -nosplash \
        -application org.eclipse.cdt.managedbuilder.core.headlessbuild \
        -cleanBuild $app_name/$app_config -data $WORKSPACE
}
