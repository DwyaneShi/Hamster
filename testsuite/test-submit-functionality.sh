#!/bin/bash

source test-config.sh

__SubmitFunctionalityTests_LegacySubmissionType() {
    BasicJobSubmit hamster.${submissiontype}-hadoop-run-hadoopterasort-functionality-legacysubmissiontype
}

__SubmitFunctionalityTests_BadJobNames () {
    BasicJobSubmit hamster.${submissiontype}-hadoop-run-hadoopterasort-functionality-job-name-whitespace
    BasicJobSubmit hamster.${submissiontype}-hadoop-run-hadoopterasort-functionality-job-name-dollarsign
}

__SubmitFunctionalityTests_AltJobTimes () {
    BasicJobSubmit hamster.${submissiontype}-hadoop-run-hadoopterasort-functionality-altjobtime-sbatchsrun-minutes-seconds
    BasicJobSubmit hamster.${submissiontype}-hadoop-run-hadoopterasort-functionality-altjobtime-sbatchsrun-hours-minutes-seconds
    BasicJobSubmit hamster.${submissiontype}-hadoop-run-hadoopterasort-functionality-altjobtime-sbatchsrun-days-hours
    BasicJobSubmit hamster.${submissiontype}-hadoop-run-hadoopterasort-functionality-altjobtime-sbatchsrun-days-hours-minutes
    BasicJobSubmit hamster.${submissiontype}-hadoop-run-hadoopterasort-functionality-altjobtime-sbatchsrun-days-hours-minutes-seconds
}

__SubmitFunctionalityTests_AltConfFilesDir () {
    BasicJobSubmit hamster.${submissiontype}-hadoop-run-hadoopterasort-functionality-altconffilesdir
}

__SubmitFunctionalityTests_TestAll() {
    BasicJobSubmit hamster.${submissiontype}-hadoop-run-hadoopterasort-functionality-testall
}

__SubmitFunctionalityTests_InteractiveMode () {
    BasicJobSubmit hamster.${submissiontype}-hadoop-functionality-interactive-mode
}

__SubmitFunctionalityTests_SetuponlyMode () {
    BasicJobSubmit hamster.${submissiontype}-hadoop-functionality-setuponly-mode
}

__SubmitFunctionalityTests_JobTimeout () {
    BasicJobSubmit hamster.${submissiontype}-hadoop-functionality-jobtimeout
}

__SubmitFunctionalityTests_HamsterExports() {
    BasicJobSubmit hamster.${submissiontype}-hadoop-hdfs-functionality-checkexports
    BasicJobSubmit hamster.${submissiontype}-hadoop-rawnetworkfs-functionality-checkexports
}

__SubmitFunctionalityTests_PrePostRunScripts() {
    BasicJobSubmit hamster.${submissiontype}-hadoop-run-hadoopterasort-functionality-prepostrunscripts
}

__SubmitFunctionalityTests_PreRunScriptError() {
    BasicJobSubmit hamster.${submissiontype}-hadoop-functionality-prerunscripterror
}

SubmitFunctionalityTests() {
    __SubmitFunctionalityTests_LegacySubmissionType
    __SubmitFunctionalityTests_BadJobNames
    __SubmitFunctionalityTests_AltJobTimes
    __SubmitFunctionalityTests_AltConfFilesDir
    __SubmitFunctionalityTests_TestAll
    __SubmitFunctionalityTests_InteractiveMode
    __SubmitFunctionalityTests_SetuponlyMode
    __SubmitFunctionalityTests_JobTimeout
    __SubmitFunctionalityTests_HamsterExports
    __SubmitFunctionalityTests_PrePostRunScripts
    __SubmitFunctionalityTests_PreRunScriptError
}
