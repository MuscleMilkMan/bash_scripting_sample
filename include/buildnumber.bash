#!/bin/bash
#
# Create Build Number functions.
#

#
# Script constants
#
BUILDNUMBER_FILE=bred_microblaze_core/include/buildnumber.h
METADATA_PATH=<URL>.xml

#
# Create build number based on previous build number stored in maven-metadata.xml
#
function buildnumber_create() {
    log "Creating next build number token"
    
    # using '~' as regex delimiter since '/' is part of XML close tag
    nextbuild=`curl -s  $METADATA_PATH \
    | grep -i '<buildNumber>' | sed 's~<buildNumber>~(~;s~</buildNumber>~+1)~'`
 
    # overwrite the stub file
    echo "#define VERSION_BUILD $nextbuild" > $BUILDNUMBER_FILE
}
