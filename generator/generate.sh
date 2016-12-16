#!/bin/bash

source generate-default.sh
source generate-hadoop.sh
source generate-common.sh
source config.sh

# Toggle y/n for different test types

defaulttests=y
standardtests=n

HAMSTER_SCRIPTS_HOME=$(cd "`dirname "$0"`"/..; pwd)

if [ ! -d "${HAMSTER_SCRIPTS_HOME}/scripts/submission/templates" ]
then
    echo "${HAMSTER_SCRIPTS_HOME}/scripts/submission/templates not a directory"
    exit 1
fi

hamsterscriptshomesubst=`echo ${HAMSTER_SCRIPTS_HOME} | sed "s/\\//\\\\\\\\\//g"`

mkdir -p ${HAMSTER_SCRIPTS_HOME}/scripts/submission/generator
cp ${HAMSTER_SCRIPTS_HOME}/scripts/submission/hadoop-${HADOOP_VERSION}/Makefile ${HAMSTER_SCRIPTS_HOME}/scripts/submission/generator/Makefile

HAMSTER_SCRIPTS_HOME_DIRNAME=`dirname ${HAMSTER_SCRIPTS_HOME}`
hamsterscriptshomedirnamesubst=`echo ${HAMSTER_SCRIPTS_HOME_DIRNAME} | sed "s/\\//\\\\\\\\\//g"`
sed -i -e "s/HAMSTER_SCRIPTS_DIR_PREFIX=\(.*\)/HAMSTER_SCRIPTS_DIR_PREFIX=${hamsterscriptshomedirnamesubst}/" ${HAMSTER_SCRIPTS_HOME}/scripts/submission/generator/Makefile

localdirpathsubst=`echo ${LOCAL_DIR_PATH} | sed "s/\\//\\\\\\\\\//g"`
sed -i -e "s/LOCAL_DIR_PREFIX=\(.*\)/LOCAL_DIR_PREFIX=${localdirpathsubst}/" ${HAMSTER_SCRIPTS_HOME}/scripts/submission/generator/Makefile

homedirpathsubst=`echo ${HOME_DIR_PATH} | sed "s/\\//\\\\\\\\\//g"`
sed -i -e "s/HOME_DIR_PREFIX=\(.*\)/HOME_DIR_PREFIX=${homedirpathsubst}/" ${HAMSTER_SCRIPTS_HOME}/scripts/submission/generator/Makefile

lustredirpathsubst=`echo ${LUSTRE_DIR_PATH} | sed "s/\\//\\\\\\\\\//g"`
sed -i -e "s/LUSTRE_DIR_PREFIX=\(.*\)/LUSTRE_DIR_PREFIX=${lustredirpathsubst}/" ${HAMSTER_SCRIPTS_HOME}/scripts/submission/generator/Makefile

networkfsdirpathsubst=`echo ${NETWORKFS_DIR_PATH} | sed "s/\\//\\\\\\\\\//g"`
sed -i -e "s/NETWORKFS_DIR_PREFIX=\(.*\)/NETWORKFS_DIR_PREFIX=${networkfsdirpathsubst}/" ${HAMSTER_SCRIPTS_HOME}/scripts/submission/generator/Makefile

rawnetworkfsdirpathsubst=`echo ${RAWNETWORKFS_DIR_PATH} | sed "s/\\//\\\\\\\\\//g"`
sed -i -e "s/RAWNETWORKFS_DIR_PREFIX=\(.*\)/RAWNETWORKFS_DIR_PREFIX=${rawnetworkfsdirpathsubst}/" ${HAMSTER_SCRIPTS_HOME}/scripts/submission/generator/Makefile

ssddirpathsubst=`echo ${SSD_DIR_PATH} | sed "s/\\//\\\\\\\\\//g"`
sed -i -e "s/SSD_DIR_PREFIX=\(.*\)/SSD_DIR_PREFIX=${ssddirpathsubst}/" ${HAMSTER_SCRIPTS_HOME}/scripts/submission/generator/Makefile

sed -i -e "s/HAMSTER_NO_LOCAL_DIR=n/HAMSTER_NO_LOCAL_DIR=y/" ${HAMSTER_SCRIPTS_HOME}/scripts/submission/generator/Makefile

hadoopdirpathsubst=`echo ${HADOOP_DIR_PATH} | sed "s/\\//\\\\\\\\\//g"`
sed -i -e "s/HADOOP_DIR_PREFIX=\(.*\)/HADOOP_DIR_PREFIX=${hadoopdirpathsubst}/" ${HAMSTER_SCRIPTS_HOME}/scripts/submission/generator/Makefile

defaultlocalreqpathsubstr=`echo ${DEFAULT_LOCAL_REQUIREMENTS_FILE} | sed "s/\\//\\\\\\\\\//g"`
sed -i -e "s/LOCAL_REQUIREMENTS=n/LOCAL_REQUIREMENTS=${DEFAULT_LOCAL_REQUIREMENTS}/" ${HAMSTER_SCRIPTS_HOME}/scripts/submission/generator/Makefile
sed -i -e "s/LOCAL_REQUIREMENTS_FILE=\(.*\)/LOCAL_REQUIREMENTS_FILE=${defaultlocalreqpathsubstr}/" ${HAMSTER_SCRIPTS_HOME}/scripts/submission/generator/Makefile

sed -i -e "s/HADOOP_FILESYSTEM_MODE=\"\(.*\)\"/HADOOP_FILESYSTEM_MODE=\"${DEFAULT_HADOOP_FILESYSTEM_MODE}\"/" ${HAMSTER_SCRIPTS_HOME}/scripts/submission/generator/Makefile

sed -i -e "s/HADOOP_DEFAULT_TERASORT_SIZE=\(.*\)/HADOOP_DEFAULT_TERASORT_SIZE=${hadoopterasortsize}/" ${HAMSTER_SCRIPTS_HOME}/scripts/submission/generator/Makefile

defaultjavahomesubst=`echo ${JAVA_HOME} | sed "s/\\//\\\\\\\\\//g"`
sed -i -e "s/JAVA_HOME=\(.*\)/JAVA_HOME=${defaultjavahomesubst}/" ${HAMSTER_SCRIPTS_HOME}/scripts/submission/generator/Makefile

# Replace output filename with common strings so we can do the same
# search & replace later on regardless of the job submission type.

defaultjoboutputfile=FILENAMESEARCHREPLACEPREFIX-FILENAMESEARCHREPLACEKEY.out
sed -i -e "s/SBATCH_SRUN_DEFAULT_JOB_FILE=\(.*\)/SBATCH_SRUN_DEFAULT_JOB_FILE=${defaultjoboutputfile}/" ${HAMSTER_SCRIPTS_HOME}/scripts/submission/generator/Makefile

if [ "${submissiontype}" == "sbatch-srun" ]
then
    timestringtoreplace="<my time in minutes>"
    functiontogettimeoutput="GetMinutesJob"
fi

cd ${HAMSTER_SCRIPTS_HOME}/scripts/submission/generator/

echo "Making launching scripts"

make ${submissiontype} &> /dev/null

cd ${HAMSTER_SCRIPTS_HOME}/generator/

if [ "${defaulttests}" == "y" ]; then
    GenerateDefaultStandardTests
fi

if [ "${standardtests}" == "y" ]; then
    GenerateHadoopStandardTests
fi

# No if checks, may process files created outside of these files
# e.g. like functionality tests of default tests
GenerateHadoopPostProcessing

# Seds for all tests

echo "Finishing up test creation"

# Names important, will be used in validation

files=`find . -maxdepth 1 -name "hamster.${submissiontype}*no-local-dir*"`
if [ -n "${files}" ]
then
    sed -i -e 's/# export HAMSTER_NO_LOCAL_DIR="yes"/export HAMSTER_NO_LOCAL_DIR="yes"/' ${files}
fi

files=`find . -maxdepth 1 -name "hamster.${submissiontype}*"`
if [ -n "${files}" ]
then
    sed -i -e "s/<my node count>/${basenodescount}/" ${files}

    sed -i -e "s/<my job name>/test/" ${files}

    sed -i -e 's/# export HAMSTER_POST_JOB_RUN="\(.*\)"/export HAMSTER_POST_JOB_RUN="'"${hamsterscriptshomesubst}"'\/scripts\/job\/post-job-run-scripts\/gather-config-files-and-logs-script.sh"/' ${files}

    sed -i -e 's/# export HAMSTER_STARTUP_TIME=.*/export HAMSTER_STARTUP_TIME='"${STARTUP_TIME}"'/' ${files}
    sed -i -e 's/# export HAMSTER_SHUTDOWN_TIME=.*/export HAMSTER_SHUTDOWN_TIME='"${SHUTDOWN_TIME}"'/' ${files}

    # Guarantee atleast 30 mins for all remaining jobs
    ${functiontogettimeoutput} 30
    sed -i -e "s/${timestringtoreplace}/${timeoutputforjob}/" ${files}

    if [ "${submissiontype}" == "sbatch-srun" ]
    then
        sed -i -e "s/FILENAMESEARCHREPLACEPREFIX/slurm/" ${files}
        sed -i -e "s/FILENAMESEARCHREPLACEKEY/%j/" ${files}

        sed -i -e "s/<my partition>/${sbatchsrunpartition}/" ${files}
    fi
fi
