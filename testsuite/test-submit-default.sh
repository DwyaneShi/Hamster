#!/bin/bash

source test-config.sh

SubmitDefaultStandardTests() {
    BasicJobSubmit hamster.${submissiontype}-hadoop-default-run-hadoopterasort
    BasicJobSubmit hamster.${submissiontype}-hadoop-default-run-hadoopterasort-no-local-dir
}
