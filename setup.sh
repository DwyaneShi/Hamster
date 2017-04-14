#!/bin/bash

# This script will download Hadoop for Hamster, and put it in a directory
# based on settings below, and apply patches as needed.

# The path you'd like to be installed into

# set -o xtrace
INSTALL_PATH="$HOME/workspace/bigdata/"

# Configurations needed to rebuild all launching scripts to be pre-populated
# with INSTALL_PATH and several other paths & settings appropriately.

# LOCAL_PREFIX="/data/drive1/haiyangshi/"
LOCAL_PREFIX="/data/ssd1/haiyangshi/"
JAVA_HOME="$HOME/tools/jdk1.8.0"
HOME_DIR_PATH="$HOME"
# HAMSTER_LOCAL_DIR & HADOOP_LOCAL_DIR
LOCAL_DIR_PATH="${LOCAL_PREFIX}"
# HADOOP_HDFS_PATH
LOCAL_DRIVE_PATH="${LOCAL_PREFIX}"

# The range shown in nodelist is node[001, 004], but the actual hostname is
# node001.cluster, ..., node004.cluster, then you need to set up this variable
# to fix.
HOSTNAME_SUFFIX="-ib.cluster"


# projects
# HAMSTER_PROJECTS="HADOOP HIVE"
HAMSTER_PROJECTS="HADOOP"

# Patches are based on the package version number.

# HADOOP_VERSION="2.7.3"
HADOOP_VERSION="3.0.0-alpha1"
# HADOOP_VERSION="3.0.0-alpha1-NOWLAB"
HADOOP_PACKAGE="hadoop/common/hadoop-${HADOOP_VERSION}/hadoop-${HADOOP_VERSION}.tar.gz"

HIVE_VERSION="2.1.1"
HIVE_PACKAGE="hive/hive-${HIVE_VERSION}/apache-hive-${HIVE_VERSION}-bin.tar.gz"
HIVE_DEPENDENCIES="ZOOKEEPER"

ZOOKEEPER_VERSION="3.4.9"
ZOOKEEPER_PACKAGE="zookeeper/zookeeper-${ZOOKEEPER_VERSION}/zookeeper-${ZOOKEEPER_VERSION}.tar.gz"
ZOOKEEPER_DATADIR=${HOME}/datadir
ZOOKEEPER_PORT="22231"

# Check some basics

if [ ! -d "${INSTALL_PATH}" ]
then
    echo "${INSTALL_PATH} not a directory"
    exit 1
fi

HAMSTER_SCRIPTS_HOME=$(cd "`dirname "$0"`"; pwd)
source ${HAMSTER_SCRIPTS_HOME}/util/hamster-io

if [ ! -d "${HAMSTER_SCRIPTS_HOME}/patches" ]
then
    echo "${HAMSTER_SCRIPTS_HOME}/patches not a directory"
    exit 1
fi

if [ ! -d "${HAMSTER_SCRIPTS_HOME}/scripts/submission/templates" ]
then
    echo "${HAMSTER_SCRIPTS_HOME}/scripts/submission/templates not a directory"
    exit 1
fi

APACHE_DOWNLOAD_BASE="http://www.apache.org/dyn/closer.cgi"

__download_package () {
    local package=$1

    APACHE_DOWNLOAD_PACKAGE="${APACHE_DOWNLOAD_BASE}/${package}"

    DOWNLOAD_URL=`wget -q -O - ${APACHE_DOWNLOAD_PACKAGE} | grep "${package}" | head -n 1 | grep -o '<a href=['"'"'"][^"'"'"']*['"'"'"]' | sed -e 's/^<a href=["'"'"']//' -e 's/["'"'"']$//'`

    echo "Downloading from ${DOWNLOAD_URL}"

    PACKAGE_BASENAME=`basename ${package}`

    wget -O ${INSTALL_PATH}/${PACKAGE_BASENAME} ${DOWNLOAD_URL}
}

__apply_patches_if_exist () {
    local basedir=$1
    shift
    local patchfiles=$@

    cd ${INSTALL_PATH}/${basedir}

    for patchfile in ${patchfiles}
    do
        if [ -f ${patchfile} ]
        then
            patch -p1 < ${patchfile}
        fi
    done
}

HAMSTER_SETUP="HADOOP"
__hamster_pipeline () {
    local project=$1
    if [ "${project}X" != "HADOOPX" ]
    then
        HAMSTER_SETUP="${HAMSTER_SETUP} ${project}"
    fi

    eval "package=\$${project}_PACKAGE"
    if [ ! -f ${INSTALL_PATH}/${package##*/} ]
    then
        __download_package "${package}"
    fi

    PACKAGE_BASENAME=`basename ${package}`
    echo "Untarring ${package}"

    cd ${INSTALL_PATH}
    tar -xzf ${PACKAGE_BASENAME}
    cd -

    PACKAGE_BASEDIR=$(echo `basename ${package}` | sed 's/\(.*\)\.\(.*\)\.\(.*\)/\1/g')
    __apply_patches_if_exist ${PACKAGE_BASEDIR} \
        ${HAMSTER_SCRIPTS_HOME}/patches/${PACKAGE_BASEDIR}.patch

    eval "dependencies=\$${project}_DEPENDENCIES"
    if [ "${dependencies}X" != "X" ]
    then
        for dependency in ${dependencies}
        do
            __hamster_pipeline ${dependency}
        done
    fi
}

for project in ${HAMSTER_PROJECTS}
do
    __hamster_pipeline ${project}
done

HAMSTER_SCRIPTS_HOME_DIRNAME=`dirname ${HAMSTER_SCRIPTS_HOME}`
rm -rf ${HAMSTER_SCRIPTS_HOME}/scripts/submission/hadoop-${HADOOP_VERSION}
Hamster_mkdir ${HAMSTER_SCRIPTS_HOME}/scripts/submission/hadoop-${HADOOP_VERSION}
cp ${HAMSTER_SCRIPTS_HOME}/scripts/submission/templates/Makefile ${HAMSTER_SCRIPTS_HOME}/scripts/submission/hadoop-${HADOOP_VERSION}/
hamsterscriptshomedirnamesubst=`echo ${HAMSTER_SCRIPTS_HOME_DIRNAME} | sed "s/\\//\\\\\\\\\//g"`
sed -i -e "s/HAMSTER_SCRIPTS_DIR_PREFIX=\(.*\)/HAMSTER_SCRIPTS_DIR_PREFIX=${hamsterscriptshomedirnamesubst}/" ${HAMSTER_SCRIPTS_HOME}/scripts/submission/hadoop-${HADOOP_VERSION}/Makefile

installpathsubst=`echo ${INSTALL_PATH} | sed "s/\\//\\\\\\\\\//g"`
sed -i -e "s/HADOOP_DIR_PREFIX=\(.*\)/HADOOP_DIR_PREFIX=${installpathsubst}/" ${HAMSTER_SCRIPTS_HOME}/scripts/submission/hadoop-${HADOOP_VERSION}/Makefile
sed -i -e "s/HADOOP_VERSION=\(.*\)/HADOOP_VERSION=${HADOOP_VERSION}/" ${HAMSTER_SCRIPTS_HOME}/scripts/submission/hadoop-${HADOOP_VERSION}/Makefile
sed -i -e "s/HIVE_VERSION=\(.*\)/HIVE_VERSION=${HIVE_VERSION}/" ${HAMSTER_SCRIPTS_HOME}/scripts/submission/hadoop-${HADOOP_VERSION}/Makefile
sed -i -e "s/ZOOKEEPER_VERSION=\(.*\)/ZOOKEEPER_VERSION=${ZOOKEEPER_VERSION}/" ${HAMSTER_SCRIPTS_HOME}/scripts/submission/hadoop-${HADOOP_VERSION}/Makefile
zkdatadirsubst=`echo ${ZOOKEEPER_DATADIR} | sed "s/\\//\\\\\\\\\//g"`
sed -i -e "s/ZOOKEEPER_DATADIR=\(.*\)/ZOOKEEPER_DATADIR=${zkdatadirsubst}/" ${HAMSTER_SCRIPTS_HOME}/scripts/submission/hadoop-${HADOOP_VERSION}/Makefile
sed -i -e "s/ZOOKEEPER_PORT=\(.*\)/ZOOKEEPER_PORT=${ZOOKEEPER_PORT}/" ${HAMSTER_SCRIPTS_HOME}/scripts/submission/hadoop-${HADOOP_VERSION}/Makefile

if [ "${JAVA_HOME}X" != "X" ]
then
    javadefaultpathsubst=`echo ${JAVA_HOME} | sed "s/\\//\\\\\\\\\//g"`
    sed -i -e "s/JAVA_HOME=\(.*\)/JAVA_HOME=${javadefaultpathsubst}/" ${HAMSTER_SCRIPTS_HOME}/scripts/submission/hadoop-${HADOOP_VERSION}/Makefile
fi

if [ "${HOME_DIR_PATH}X" != "X" ]
then
    homedirpathsubst=`echo ${HOME_DIR_PATH} | sed "s/\\//\\\\\\\\\//g"`
    sed -i -e "s/HOME_DIR_PREFIX=\(.*\)/HOME_DIR_PREFIX=${homedirpathsubst}/" ${HAMSTER_SCRIPTS_HOME}/scripts/submission/hadoop-${HADOOP_VERSION}/Makefile
fi

if [ "${LOCAL_DIR_PATH}X" != "X" ]
then
    localdirpathsubst=`echo ${LOCAL_DIR_PATH} | sed "s/\\//\\\\\\\\\//g"`
    sed -i -e "s/LOCAL_DIR_PREFIX=\(.*\)/LOCAL_DIR_PREFIX=${localdirpathsubst}/" ${HAMSTER_SCRIPTS_HOME}/scripts/submission/hadoop-${HADOOP_VERSION}/Makefile
fi


if [ "${LOCAL_DRIVE_PATH}X" != "X" ]
then
    localdrivepathsubst=`echo ${LOCAL_DRIVE_PATH} | sed "s/\\//\\\\\\\\\//g"`
    sed -i -e "s/LOCAL_DRIVE_PREFIX=\(.*\)/LOCAL_DRIVE_PREFIX=${localdrivepathsubst}/" ${HAMSTER_SCRIPTS_HOME}/scripts/submission/hadoop-${HADOOP_VERSION}/Makefile
fi

sed -i -e "s/^HAMSTER_PROJECTS=\(.*\)/HAMSTER_PROJECTS=\"${HAMSTER_PROJECTS}\"/" ${HAMSTER_SCRIPTS_HOME}/scripts/submission/hadoop-${HADOOP_VERSION}/Makefile
sed -i -e "s/^HAMSTER_SETUP=\(.*\)/HAMSTER_SETUP=\"${HAMSTER_SETUP}\"/" ${HAMSTER_SCRIPTS_HOME}/scripts/submission/hadoop-${HADOOP_VERSION}/Makefile

hostnamesuffixsubst=`echo ${HOSTNAME_SUFFIX} | sed "s/\\//\\\\\\\\\//g"`
sed -i -e "s/HOSTNAME_SUFFIX=\(.*\)/HOSTNAME_SUFFIX=${hostnamesuffixsubst}/" ${HAMSTER_SCRIPTS_HOME}/scripts/submission/hadoop-${HADOOP_VERSION}/Makefile
