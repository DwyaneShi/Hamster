#!/bin/bash

source test-generate-common.sh
source test-config.sh

GenerateDefaultStandardTests() {

    cd ${HAMSTER_SCRIPTS_HOME}/testsuite/

    echo "Making Default Standard Tests"

    # Default Tests
    cp ../submission-scripts/testsuite/script-${submissiontype}/hamster.${submissiontype} hamster.${submissiontype}-hadoop-default-run-hadoopterasort
    cp ../submission-scripts/testsuite/script-${submissiontype}/hamster.${submissiontype} hamster.${submissiontype}-hadoop-default-run-hadoopterasort-no-local-dir
}
