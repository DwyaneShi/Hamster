#!/bin/bash

source test-submit-cornercase.sh
source test-submit-default.sh
source test-submit-functionality.sh
source test-submit-hadoop.sh
source test-config.sh

# How to submit

verboseoutput=n
jobsubmissionfile=hamster-test.log

while [[ $# -gt 0 ]]
do
    key="$1"
    case $key in
        -v|--verbose)
            verboseoutput=y
            ;;
        *)
            echo "Usage: test-validate [-v]"
            exit 1
            ;;
    esac
    shift
done

# Test Setup

if [ "${submissiontype}" == "sbatch-srun" ]
then
    jobsubmitcmd="sbatch"
    jobsubmitcmdoption="-k"
    jobsubmitdependency="--dependency=afterany:\${previousjobid}"
    jobidstripcmd="awk '""{print \$4}""'"
fi

if [ -f "${jobsubmissionfile}" ]
then
    dateappend=`date +"%Y%m%d-%N"`
    mv ${jobsubmissionfile} ${jobsubmissionfile}.${dateappend}
fi
touch ${jobsubmissionfile}

BasicJobSubmit () {
    local jobsubmissionscript=$1

    if [ -f "${jobsubmissionscript}" ]
    then
        jobsubmitoutput=`eval "${jobsubmitcmd} ${jobsubmitcmdoption} ${jobsubmissionscript}"`
        jobidstripfullcommand="echo '${jobsubmitoutput}' | ${jobidstripcmd}"
        jobid=`eval ${jobidstripfullcommand}`
        
        echo "File ${jobsubmissionscript} submitted with ID ${jobid}" >> ${jobsubmissionfile}
        
        previousjobid=${jobid}
        jobsubmitdependencyexpand=`eval echo ${jobsubmitdependency}`
        previousjobsubmitted=y
    else
        if [ "${verboseoutput}" = "y" ]
        then
            echo "File ${jobsubmissionscript} not found" >> ${jobsubmissionfile}
        fi
        previousjobsubmitted=n
    fi
}

DependentJobSubmit () {
    local jobsubmissionscript=$1

    if [ "${previousjobsubmitted}" == "y" ]
    then
        if [ -f "${jobsubmissionscript}" ]
        then
            jobsubmitoutput=`eval "${jobsubmitcmd} ${jobsubmitdependencyexpand} ${jobsubmitcmdoption} ${jobsubmissionscript}"`
            jobidstripfullcommand="echo '${jobsubmitoutput}' | ${jobidstripcmd}"
            jobid=`eval ${jobidstripfullcommand}`
            
            echo "File ${jobsubmissionscript} submitted with ID ${jobid}, dependent on previous job ${previousjobid}" >> ${jobsubmissionfile}
            
            previousjobid=${jobid}
            jobsubmitdependencyexpand=`eval echo ${jobsubmitdependency}`
            previousjobsubmitted=y
        else
            if [ "${verboseoutput}" = "y" ]
            then
                echo "File ${jobsubmissionscript} not found" >> ${jobsubmissionfile}
            fi
            previousjobsubmitted=n
        fi
    else
        if [ -f "${jobsubmissionscript}" ]
        then
            if [ "${verboseoutput}" = "y" ]
            then
                echo "File ${jobsubmissionscript} not submitted - prior job in dependency chain not submitted" >> ${jobsubmissionfile}
            fi
            previousjobsubmitted=n
        else
            if [ "${verboseoutput}" = "y" ]
            then
                echo "File ${jobsubmissionscript} not found" >> ${jobsubmissionfile}
            fi
            previousjobsubmitted=n
        fi
    fi
}

SubmitDefaultStandardTests

SubmitCornerCaseTests

SubmitFunctionalityTests

SubmitHadoopStandardTests
SubmitHadoopDependencyTests
