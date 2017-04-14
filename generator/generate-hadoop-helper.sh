#!/bin/bash

source config.sh
source ../lib/hamster-lib-helper

__SetupHadoopFileSystemStandard() {
    local fstype=$1
    shift
    local files=$@

    sed -i \
        -e 's/export HADOOP_FILESYSTEM_MODE="\(.*\)"/export HADOOP_FILESYSTEM_MODE="'"${fstype}"'"/' \
        ${files}
}
