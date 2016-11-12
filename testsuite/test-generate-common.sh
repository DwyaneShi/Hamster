#!/bin/bash

source test-config.sh
source ../lib/hamster-lib-helper

GetMinutesJob () {
    local addminutes=$1
    __minutesjob=`expr $STARTUP_TIME + $SHUTDOWN_TIME + $addminutes`
    timeoutputforjob=$__minutesjob
}

GetSecondsJob () {
    local addminutes=$1
    GetMinutesJob $addminutes
    secondsjob=`expr $__minutesjob \* 60`
    timeoutputforjob=$secondsjob
}

GetHoursMinutesJob () {
    local addminutes=$1
    GetMinutesJob $1
    local hours=`expr $__minutesjob / 60`
    local minutesleft=`expr $__minutesjob % 60`
    timeoutputforjob=`printf "%d:%02d" ${hours} ${minutesleft}`
}

CheckForDependency() {
    local project=$1
    local projectcheck=$2
    local checkversion=$3

    local checkversionunderscore=`echo ${checkversion} | sed -e "s/\./_/g" -e "s/-/_/g"`
    local projectchecklowercase=`echo ${projectcheck} | tr '[:upper:]' '[:lower:]'`
    local variabletocheck="${projectchecklowercase}_${checkversionunderscore}"

    if [ "${!variabletocheck}" != "y" ]
    then
        echo "Cannot generate ${project} tests that depend on ${projectcheck} ${checkversion}, it's not enabled"
        continue
    fi
}

RemoveTestsCheck() {
    local project=$1
    local version=$2

    local versionunderscore=`echo ${version} | sed -e "s/\./_/g" | sed -e "s/-/_/g"`
    local projectlowercase=`echo ${project} | tr '[:upper:]' '[:lower:]'`
    local variabletocheck="${projectlowercase}_${versionunderscore}"

    if [ "${!variabletocheck}" == "n" ]
    then
        rm -f hamster.${submissiontype}*${project}-${version}*
    fi
}
