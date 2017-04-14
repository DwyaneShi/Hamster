#!/bin/bash

source generate-common.sh
source config.sh
source generate-hadoop-helper.sh
source ../lib/hamster-lib-helper

GenerateHadoopStandardTests() {

    cd ${HAMSTER_SCRIPTS_HOME}/generator/

    echo "Making Hadoop Standard Tests"

    for testfunction in __GenerateHadoopStandardTests_StandardTerasort
    do
        ${testfunction} ${HADOOP_VERSION}
    done
}

GenerateHadoopPostProcessing() {
    files=`find . -maxdepth 1 -name "hamster.${submissiontype}*run*"`
    if [ -n "${files}" ]
    then
        sed -i -e "s/FILENAMESEARCHREPLACEKEY/run-hadoop-${HADOOP_VERSION}-FILENAMESEARCHREPLACEKEY/" ${files}
    fi
}
