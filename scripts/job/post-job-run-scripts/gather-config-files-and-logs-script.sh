#!/bin/sh

# This is script collects config and log files after your job is
# completed.
#
# It is a convenient script to use in the post of your job.  You can
# set it with the HAMSTER_POST_JOB_RUN environment variable in
# the main job submission file.
#
# By default it stores into
# $HOME/$HAMSTER_JOB_NAME/$HAMSTER_JOB_ID, but you may wish
# to change that.


# export out targetdir
Gather_common () {
    local project=$1
    local saveconfdir=$2
    local savelogdir=$3

    local NODENAME=`hostname`
    local projectuppercase=`echo ${project} | tr '[:lower:]' '[:upper:]'`
    local projectconfdir="${projectuppercase}_CONF_DIR"
    local projectlogdir="${projectuppercase}_LOG_DIR"

    targetdir=${HOME}/${HAMSTER_JOB_NAME}/${HAMSTER_JOB_ID}/${project}/nodes/${NODENAME}
    
    if [ "${saveconfdir}" == "y" ]
    then
        if [ "${!projectconfdir}X" != "X" ] && [ -d ${!projectconfdir}/ ] && [ "$(ls -A ${!projectconfdir}/)" ]
        then
            mkdir -p ${targetdir}/conf
            cp -a ${!projectconfdir}/* ${targetdir}/conf
        fi
    fi

    if [ "${savelogdir}" == "y" ]
    then
        if [ "${!projectlogdir}X" != "X" ] && [ -d ${!projectlogdir}/ ] && [ "$(ls -A ${!projectlogdir}/)" ]
        then
            mkdir -p ${targetdir}/log
            cp -a ${!projectlogdir}/* ${targetdir}/log
        fi
    fi
}

for project in ${HAMSTER_PROJECTS}
do
    Gather_common ${project} "y" "y"
done

exit 0
