#!/bin/bash
#
# Version functions.
#

#
# Script constants
#
REPOSITORY_FILE=bred_microblaze_core/include/commithash.h

#
# Set all repository information in header file.
#
function version_set_repo_all() {
    log "Setting all repository information"
    version_set_repo "bred_microblaze_core" "MBCORE"
    version_set_repo "fpga_bigred_hdl" "FPGA"
    version_set_repo "sensor-pod-sdk-c" "CSDK"
    version_set_repo "stm-fw" "STMFW"
}

#
# Set the repository information in the header file.
#
# @param repo_path Repository path on disk.
# @param repo_key Key in header file.
#
function version_set_repo() {
    repo_path=$1
    repo_key=$2
    log "Setting header info for repository=$repo_path"
    
    # Get the last commit and branch
    commit=`git --git-dir=$repo_path/.git --work-tree=$repo_path log -n 1 --pretty=format:%H`
    branch=`git --git-dir=$repo_path/.git --work-tree=$repo_path rev-parse --abbrev-ref HEAD`

    # If the branch came back as 'HEAD' we are on a detached tag
    if [ "$branch" == "HEAD" ]; then
        branch=`git --git-dir=$repo_path/.git --work-tree=$repo_path describe --tags`
    fi

    log "commit: $commit"
    log "branch: $branch"
    
    # Make sure the key pattern to replace exists
    if grep -iq "$repo_key \"\"" $REPOSITORY_FILE; then
        # Update the header file for the given key with the commit/branch
        sed -i "s/$repo_key \"\"/$repo_key \"$commit ($branch)\"/g" $REPOSITORY_FILE
    else 
        echo "Error: could not find key $repo_key in $REPOSITORY_FILE"
        exit 1
    fi
}
