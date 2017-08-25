#!/bin/bash
#
# Git functions.
#

#
# Delete all repositories. 
#
function git_delete_all() {
    log "Deleting all repositories"
    git_delete "bred_microblaze_core"
    git_delete "fpga_bigred_hdl"
    git_delete "sensor-pod-sdk-c"
    git_delete "stm-fw"
}

#
# Clone all repositories.
#
# @param bsp_branch BSP branch to use.
# @param release_branch Release branch to use, empty for snapshot.
#
function git_clone_all() {
    bsp_branch=$1
    release_branch=$2

    # Build from develop unless release was specified
    firmware_branch="develop"
    if ! [ -z $release_branch ]; then
        firmware_branch=$release_branch
    fi
    
    log "Cloning all repositories bsp=$bsp_branch firmware_branch=$firmware_branch"
    git_ssh_start
    git_clone "big" "bred_microblaze_core" $firmware_branch
    git_clone "big" "fpga_bigred_hdl"  $bsp_branch
    git_clone "idkt" "sensor-pod-sdk-c" $firmware_branch
    git_clone "big" "stm-fw" $firmware_branch
    git_ssh_stop
}

#
# Delete repository.
#
# @param repo_path Repository path.
#
function git_delete() {
    repo_path=$1
    log "Deleting repository=$repo_path"

    # Delete the repository
    rm -rf "$repo_path"
}

#
# Clone repository.
#
# @param project Bitbucket project key.
# @param repo_name Repository name.
# @param branch Branch to clone.
#
function git_clone() {
    project=$1
    repo_name=$2
    branch=$3
    log "Cloning $repo_name ($branch)"
    
    # Clone the repository
    git clone "ssh://<gitRepoURL>${project}/${repo_name}.git"
    
    # Checkout the branch (need to do this as separate step with git 1.7 on server)
    git --git-dir=$repo_name/.git --work-tree=$repo_name checkout "$branch"
    
    # Log most recent commit on branch
    last_commit=`git --git-dir=$repo_name/.git --work-tree=$repo_name log -n 1 --pretty=format:%H`
    log "Clone completed, commit=$last_commit"
}

#
# Start the SSH agent for git operations.
#
function git_ssh_start() {
    log "Starting the ssh agent"
    
    # Start the agent, then add the builder.daemon key
    eval `ssh-agent -s`
    ssh-add bred_builder/ssh/id_rsa
}

#
# Stop the SSH agent.
#
function git_ssh_stop() {
    log "Killing the ssh agent"
    
    # Stop the agent
    ssh-agent -k
}
