#!/bin/bash

# Job Submission Config

submissiontype=sbatch-srun

sbatchsrunpartition=All

# Test config
#
# base node counts for job submission
#
# base node count of 8 means most jobs will be job size of 9, the
# additional 1 will be added later for the master.
#
# optional tweaks to test defaults to make some run faster
basenodecount=4
hadoopterasortsize=10000000

# Configure Makefile 

# Remember to escape $ w/ \ if you want the environment variables
# placed into the submission scripts instead of being expanded out

DEFAULT_HADOOP_FILESYSTEM_MODE="hdfs"

LOCAL_DIR_PATH="/tmp/\${USER}"
HOME_DIR_PATH="\${HOME}"
LUSTRE_DIR_PATH="/p/lcratery/\${USER}/testing"
NETWORKFS_DIR_PATH="/p/lcratery/\${USER}/testing"
RAWNETWORKFS_DIR_PATH="/p/lcratery/\${USER}/testing"
SSD_DIR_PATH="/ssd/tmp1/\${USER}"

HADOOP_DIR_PATH="\${HOME}/workspace/bigdata"
HADOOP_VERSION=2.7.3

JAVA_HOME="/usr/java/jdk1.7.0"

DEFAULT_LOCAL_REQUIREMENTS=n
DEFAULT_LOCAL_REQUIREMENTS_FILE=/tmp/mylocal

# Adjust accordingly.  On very busy clusters/machines, SHUTDOWN_TIME may need to be larger.
STARTUP_TIME=5
SHUTDOWN_TIME=15

# Don't edit these, calculated based on the above
basenodesmorenodescount=`expr ${basenodecount} \* 2 + 1`
basenodescount=`expr ${basenodecount} + 1`
