#!/bin/bash
#
# Maven functions.
#

#
# Push all maven artifacts.
#
# @param release_branch Release branch to use, empty for snapshot.
#
function maven_push_all() {
    release_branch=$1
    log "Pushing all artifacts"
    
    # Push to snapshots unless release was specified
    repository="snapshots"
    if ! [ -z $release_branch ]; then
        repository="releases"
    fi
    
    maven_push "bred-firmware" "bred_microblaze_core/Debug/bred_microblaze_core.elf" "elf" $repository
}

#
# Push artifact to maven.
#
# @param artifact_id Artifict ID in maven repository.
# @param file_path Path to file on disk.
# @param packaging File packaging.
# @param repository Maven repository.
#
function maven_push() {
    artifact_id=$1
    file_path=$2
    packaging=$3
    repository=$4
    log "Pushing $artifact_id to $repository" 
    
    # Push artifact to maven
    mvn deploy:deploy-file \
        -DgroupId=com.sonavation \
        -DartifactId=$artifact_id \
        -Dversion=1.0.0-SNAPSHOT \
        -Dpackaging=$packaging \
        -Dfile=$file_path \
        -DrepositoryId=sonavation \
        -Durl=http://<urlREPO>/content/repositories/$repository
}