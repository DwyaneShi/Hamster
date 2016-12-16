#!/bin/bash

# This script will download Hadoop for Hamster, and put it in a directory 
# based on settings below, and apply patches as needed.

# The path you'd like to be installed into

INSTALL_PATH="$HOME/workspace/bigdata/"

# Configurations needed to rebuild all launching scripts to be pre-populated 
# with INSTALL_PATH and several other paths & settings appropriately.  

JAVA_HOME="/opt/java/1.8.0_25"
HOME_DIR_PATH="$HOME"
LUSTRE_DIR_PATH="/lustre/$USER"
NETWORKFS_DIR_PATH="/scratch/$USER"
RAWNETWORKFS_DIR_PATH="/lustre/${USER}"
LOCAL_DIR_PATH="/tmp/bigdata/"
LOCAL_DRIVE_PATH="/tmp/bigdata/"

# The range shown in nodelist is node[001, 004], but the actual hostname is
# node001.cluster, ..., node004.cluster, then you need to set up this variable
# to fix.
HOSTNAME_SUFFIX=".cluster"

# Patches are based on the package version number.

# HADOOP_VERSION="2.7.3"
HADOOP_VERSION="3.0.0-alpha1"
HADOOP_PACKAGE="hadoop/common/hadoop-${HADOOP_VERSION}/hadoop-${HADOOP_VERSION}.tar.gz"

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

if [ ! -f ${INSTALL_PATH}/${HADOOP_PACKAGE##*/} ]
then
    __download_package "${HADOOP_PACKAGE}"
fi

PACKAGE_BASENAME=`basename ${HADOOP_PACKAGE}`
echo "Untarring ${PACKAGE_BASENAME}"

cd ${INSTALL_PATH}
tar -xzf ${PACKAGE_BASENAME}

HADOOP_PACKAGE_BASEDIR=$(echo `basename ${HADOOP_PACKAGE}` | sed 's/\(.*\)\.\(.*\)\.\(.*\)/\1/g')
__apply_patches_if_exist ${HADOOP_PACKAGE_BASEDIR} \
    ${HAMSTER_SCRIPTS_HOME}/patches/${HADOOP_PACKAGE_BASEDIR}.patch

HAMSTER_SCRIPTS_HOME_DIRNAME=`dirname ${HAMSTER_SCRIPTS_HOME}`
Hamster_mkdir ${HAMSTER_SCRIPTS_HOME}/scripts/submission/hadoop-${HADOOP_VERSION}
cp ${HAMSTER_SCRIPTS_HOME}/scripts/submission/templates/Makefile ${HAMSTER_SCRIPTS_HOME}/scripts/submission/hadoop-${HADOOP_VERSION}/
hamsterscriptshomedirnamesubst=`echo ${HAMSTER_SCRIPTS_HOME_DIRNAME} | sed "s/\\//\\\\\\\\\//g"`
sed -i -e "s/HAMSTER_SCRIPTS_DIR_PREFIX=\(.*\)/HAMSTER_SCRIPTS_DIR_PREFIX=${hamsterscriptshomedirnamesubst}/" ${HAMSTER_SCRIPTS_HOME}/scripts/submission/hadoop-${HADOOP_VERSION}/Makefile

installpathsubst=`echo ${INSTALL_PATH} | sed "s/\\//\\\\\\\\\//g"`
sed -i -e "s/HADOOP_DIR_PREFIX=\(.*\)/HADOOP_DIR_PREFIX=${installpathsubst}/" ${HAMSTER_SCRIPTS_HOME}/scripts/submission/hadoop-${HADOOP_VERSION}/Makefile
sed -i -e "s/HADOOP_VERSION=\(.*\)/HADOOP_VERSION=${HADOOP_VERSION}/" ${HAMSTER_SCRIPTS_HOME}/scripts/submission/hadoop-${HADOOP_VERSION}/Makefile

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

if [ "${LUSTRE_DIR_PATH}X" != "X" ]
then
    lustredirpathsubst=`echo ${LUSTRE_DIR_PATH} | sed "s/\\//\\\\\\\\\//g"`
    sed -i -e "s/LUSTRE_DIR_PREFIX=\(.*\)/LUSTRE_DIR_PREFIX=${lustredirpathsubst}/" ${HAMSTER_SCRIPTS_HOME}/scripts/submission/hadoop-${HADOOP_VERSION}/Makefile
fi 

if [ "${RAWNETWORKFS_DIR_PATH}X" != "X" ]
then
    rawnetworkfsdirpathsubst=`echo ${RAWNETWORKFS_DIR_PATH} | sed "s/\\//\\\\\\\\\//g"`
    sed -i -e "s/RAWNETWORKFS_DIR_PREFIX=\(.*\)/RAWNETWORKFS_DIR_PREFIX=${rawnetworkfsdirpathsubst}/" ${HAMSTER_SCRIPTS_HOME}/scripts/submission/hadoop-${HADOOP_VERSION}/Makefile
fi 

if [ "${NETWORKFS_DIR_PATH}X" != "X" ]
then
    networkfsdirpathsubst=`echo ${NETWORKFS_DIR_PATH} | sed "s/\\//\\\\\\\\\//g"`
    sed -i -e "s/NETWORKFS_DIR_PREFIX=\(.*\)/NETWORKFS_DIR_PREFIX=${networkfsdirpathsubst}/" ${HAMSTER_SCRIPTS_HOME}/scripts/submission/hadoop-${HADOOP_VERSION}/Makefile
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

hostnamesuffixsubst=`echo ${HOSTNAME_SUFFIX} | sed "s/\\//\\\\\\\\\//g"`
sed -i -e "s/HOSTNAME_SUFFIX=\(.*\)/HOSTNAME_SUFFIX=${hostnamesuffixsubst}/" ${HAMSTER_SCRIPTS_HOME}/scripts/submission/hadoop-${HADOOP_VERSION}/Makefile
