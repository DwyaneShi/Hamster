#!/bin/bash

source generate-common.sh
source config.sh

GenerateDefaultStandardTests() {

    cd ${HAMSTER_SCRIPTS_HOME}/generator/

    echo "Making Default Standard Tests"

    # Default Tests
    cp ../scripts/submission/generator/script-${submissiontype}/hamster.${submissiontype} hamster.${submissiontype}-hadoop-default-run-hadoopterasort
    cp ../scripts/submission/generator/script-${submissiontype}/hamster.${submissiontype} hamster.${submissiontype}-hadoop-default-run-hadoopterasort-no-local-dir
}
