#!/bin/bash

source test-config.sh

__SubmitCornerCaseTests_NoSetJava() {
    BasicJobSubmit hamster.${submissiontype}-hadoop-cornercase-nosetjava
}

__SubmitCornerCaseTests_BadSetJava() {
    BasicJobSubmit hamster.${submissiontype}-hadoop-cornercase-badsetjava
}

__SubmitCornerCaseTests_NoSetVersion() {
    BasicJobSubmit hamster.${submissiontype}-hadoop-cornercase-nosetversion
}

__SubmitCornerCaseTests_NoSetHome() {
    BasicJobSubmit hamster.${submissiontype}-hadoop-cornercase-nosethome
}

__SubmitCornerCaseTests_BadSetHome() {
    BasicJobSubmit hamster.${submissiontype}-hadoop-cornercase-badsethome
}

__SubmitCornerCaseTests_NoSetLocalDir() {
    BasicJobSubmit hamster.${submissiontype}-hadoop-cornercase-nosetlocaldir
}

__SubmitCornerCaseTests_BadSetLocalDir() {
    BasicJobSubmit hamster.${submissiontype}-hadoop-cornercase-badlocaldir
}

__SubmitCornerCaseTests_NoSetScript() {
    BasicJobSubmit hamster.${submissiontype}-hamster-cornercase-nosetscript
    BasicJobSubmit hamster.${submissiontype}-hadoop-cornercase-nosetscript
}

__SubmitCornerCaseTests_BadSetScript() {
    BasicJobSubmit hamster.${submissiontype}-hamster-cornercase-badsetscript-1
    BasicJobSubmit hamster.${submissiontype}-hamster-cornercase-badsetscript-2
    BasicJobSubmit hamster.${submissiontype}-hamster-cornercase-badsetscript-3
    BasicJobSubmit hamster.${submissiontype}-hadoop-cornercase-badsetscript
}

__SubmitCornerCaseTests_BadJobTime() {
    BasicJobSubmit hamster.${submissiontype}-hadoop-cornercase-badjobtime

    BasicJobSubmit hamster.${submissiontype}-hadoop-cornercase-badjobtime-sbatchsrun-minutes-seconds
    BasicJobSubmit hamster.${submissiontype}-hadoop-cornercase-badjobtime-sbatchsrun-hours-minutes-seconds
    BasicJobSubmit hamster.${submissiontype}-hadoop-cornercase-badjobtime-sbatchsrun-days-hours
    BasicJobSubmit hamster.${submissiontype}-hadoop-cornercase-badjobtime-sbatchsrun-days-hours-minutes
    BasicJobSubmit hamster.${submissiontype}-hadoop-cornercase-badjobtime-sbatchsrun-days-hours-minutes-seconds
}

__SubmitCornerCaseTests_BadStartupTime() {
    BasicJobSubmit hamster.${submissiontype}-hadoop-cornercase-badstartuptime
}

__SubmitCornerCaseTests_BadShutdownTime() {
    BasicJobSubmit hamster.${submissiontype}-hadoop-cornercase-badshutdowntime
}

__SubmitCornerCaseTests_BadNodeCount() {
    BasicJobSubmit hamster.${submissiontype}-hadoop-cornercase-badnodecount-small
}

__SubmitCornerCaseTests_NoCoreSettings() {
    BasicJobSubmit hamster.${submissiontype}-hamster-cornercase-nocoresettings-1
    BasicJobSubmit hamster.${submissiontype}-hamster-cornercase-nocoresettings-2
    BasicJobSubmit hamster.${submissiontype}-hadoop-cornercase-nocoresettings-1
    BasicJobSubmit hamster.${submissiontype}-hadoop-cornercase-nocoresettings-2
    BasicJobSubmit hamster.${submissiontype}-hadoop-cornercase-nocoresettings-3
}

__SubmitCornerCaseTests_BadCoreSettings() {
    BasicJobSubmit hamster.${submissiontype}-hamster-cornercase-badcoresettings-1
    BasicJobSubmit hamster.${submissiontype}-hamster-cornercase-badcoresettings-2
    BasicJobSubmit hamster.${submissiontype}-hadoop-cornercase-badcoresettings-1
    BasicJobSubmit hamster.${submissiontype}-hadoop-cornercase-badcoresettings-2
    BasicJobSubmit hamster.${submissiontype}-hadoop-cornercase-badcoresettings-3
}

__SubmitCornerCaseTests_RequireHDFS() {
    BasicJobSubmit hamster.${submissiontype}-hadoop-cornercase-requirehdfs-1
    BasicJobSubmit hamster.${submissiontype}-hadoop-cornercase-requirehdfs-2
}

__SubmitCornerCaseTests_RequireYarn() {
    BasicJobSubmit hamster.${submissiontype}-hadoop-cornercase-requireyarn
}

__SubmitCornerCaseTests_BadComboSettings() {
    BasicJobSubmit hamster.${submissiontype}-hadoop-cornercase-badcombosettings-1
    BasicJobSubmit hamster.${submissiontype}-hadoop-cornercase-badcombosettings-2
    BasicJobSubmit hamster.${submissiontype}-hadoop-cornercase-badcombosettings-3
    BasicJobSubmit hamster.${submissiontype}-hadoop-cornercase-badcombosettings-4
    BasicJobSubmit hamster.${submissiontype}-hadoop-cornercase-badcombosettings-5
    BasicJobSubmit hamster.${submissiontype}-hadoop-cornercase-badcombosettings-6
}

__SubmitCornerCaseTests_BadDirectories() {
    BasicJobSubmit hamster.${submissiontype}-hadoop-cornercase-baddirectories-1
    BasicJobSubmit hamster.${submissiontype}-hadoop-cornercase-baddirectories-2
    BasicJobSubmit hamster.${submissiontype}-hadoop-cornercase-baddirectories-3
    BasicJobSubmit hamster.${submissiontype}-hadoop-cornercase-baddirectories-4
    BasicJobSubmit hamster.${submissiontype}-hadoop-cornercase-baddirectories-5
}

SubmitCornerCaseTests() {
    # Special
    javasave=${JAVA_HOME}
    if [ "${javasave}X" != "X" ]
    then
        unset JAVA_HOME
    fi
    __SubmitCornerCaseTests_NoSetJava
    if [ "${javasave}X" != "X" ]
    then
        export JAVA_HOME="${javasave}"
    fi

    __SubmitCornerCaseTests_BadSetJava
    __SubmitCornerCaseTests_NoSetVersion
    __SubmitCornerCaseTests_NoSetHome
    __SubmitCornerCaseTests_BadSetHome
    __SubmitCornerCaseTests_NoSetLocalDir
    __SubmitCornerCaseTests_BadSetLocalDir
    __SubmitCornerCaseTests_NoSetScript
    __SubmitCornerCaseTests_BadSetScript

    __SubmitCornerCaseTests_BadJobTime
    __SubmitCornerCaseTests_BadStartupTime
    __SubmitCornerCaseTests_BadShutdownTime

    __SubmitCornerCaseTests_BadNodeCount

    __SubmitCornerCaseTests_NoCoreSettings
    __SubmitCornerCaseTests_BadCoreSettings

    __SubmitCornerCaseTests_RequireHDFS
    __SubmitCornerCaseTests_RequireYarn

    __SubmitCornerCaseTests_BadComboSettings

    __SubmitCornerCaseTests_BadDirectories
}
