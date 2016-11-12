#!/bin/bash

source test-generate-common.sh
source test-config.sh
source test-generate-hadoop-helper.sh
source ../lib/hamster-lib-helper

__GenerateHadoopStandardTests_StandardTerasort() {
    local hadoopversion=$1

# Note, b/c of MAPREDUCE-5528, not testing rawnetworkfs w/ terasort

    cp ../submission-scripts/testsuite/script-${submissiontype}/hamster.${submissiontype} hamster.${submissiontype}-hadoop-${hadoopversion}-hdfsoverlustre-run-hadoopterasort
    cp ../submission-scripts/testsuite/script-${submissiontype}/hamster.${submissiontype} hamster.${submissiontype}-hadoop-${hadoopversion}-hdfsondisk-single-path-hadoopterasort
    cp ../submission-scripts/testsuite/script-${submissiontype}/hamster.${submissiontype} hamster.${submissiontype}-hadoop-${hadoopversion}-hdfsondisk-multiple-paths-run-hadoopterasort
    cp ../submission-scripts/testsuite/script-${submissiontype}/hamster.${submissiontype} hamster.${submissiontype}-hadoop-${hadoopversion}-hdfsovernetworkfs-run-hadoopterasort
    cp ../submission-scripts/testsuite/script-${submissiontype}/hamster.${submissiontype} hamster.${submissiontype}-hadoop-${hadoopversion}-hdfsoverlustre-localstore-single-path-run-hadoopterasort
    cp ../submission-scripts/testsuite/script-${submissiontype}/hamster.${submissiontype} hamster.${submissiontype}-hadoop-${hadoopversion}-hdfsoverlustre-localstore-multiple-paths-run-hadoopterasort
    cp ../submission-scripts/testsuite/script-${submissiontype}/hamster.${submissiontype} hamster.${submissiontype}-hadoop-${hadoopversion}-hdfsovernetworkfs-localstore-single-path-run-hadoopterasort
    cp ../submission-scripts/testsuite/script-${submissiontype}/hamster.${submissiontype} hamster.${submissiontype}-hadoop-${hadoopversion}-hdfsovernetworkfs-localstore-multiple-paths-run-hadoopterasort

    cp ../submission-scripts/testsuite/script-${submissiontype}/hamster.${submissiontype} hamster.${submissiontype}-hadoop-${hadoopversion}-hdfsoverlustre-run-hadoopfullvalidationterasort
    cp ../submission-scripts/testsuite/script-${submissiontype}/hamster.${submissiontype} hamster.${submissiontype}-hadoop-${hadoopversion}-hdfsondisk-single-path-hadoopfullvalidationterasort
    cp ../submission-scripts/testsuite/script-${submissiontype}/hamster.${submissiontype} hamster.${submissiontype}-hadoop-${hadoopversion}-hdfsondisk-multiple-paths-run-hadoopfullvalidationterasort
    cp ../submission-scripts/testsuite/script-${submissiontype}/hamster.${submissiontype} hamster.${submissiontype}-hadoop-${hadoopversion}-hdfsovernetworkfs-run-hadoopfullvalidationterasort
    cp ../submission-scripts/testsuite/script-${submissiontype}/hamster.${submissiontype} hamster.${submissiontype}-hadoop-${hadoopversion}-hdfsoverlustre-localstore-single-path-run-hadoopfullvalidationterasort
    cp ../submission-scripts/testsuite/script-${submissiontype}/hamster.${submissiontype} hamster.${submissiontype}-hadoop-${hadoopversion}-hdfsoverlustre-localstore-multiple-paths-run-hadoopfullvalidationterasort
    cp ../submission-scripts/testsuite/script-${submissiontype}/hamster.${submissiontype} hamster.${submissiontype}-hadoop-${hadoopversion}-hdfsovernetworkfs-localstore-single-path-run-hadoopfullvalidationterasort
    cp ../submission-scripts/testsuite/script-${submissiontype}/hamster.${submissiontype} hamster.${submissiontype}-hadoop-${hadoopversion}-hdfsovernetworkfs-localstore-multiple-paths-run-hadoopfullvalidationterasort
    
    cp ../submission-scripts/testsuite/script-${submissiontype}/hamster.${submissiontype} hamster.${submissiontype}-hadoop-${hadoopversion}-hdfsoverlustre-run-hadoopterasort-no-local-dir
    cp ../submission-scripts/testsuite/script-${submissiontype}/hamster.${submissiontype} hamster.${submissiontype}-hadoop-${hadoopversion}-hdfsondisk-single-path-hadoopterasort-no-local-dir
    cp ../submission-scripts/testsuite/script-${submissiontype}/hamster.${submissiontype} hamster.${submissiontype}-hadoop-${hadoopversion}-hdfsondisk-multiple-paths-run-hadoopterasort-no-local-dir
    cp ../submission-scripts/testsuite/script-${submissiontype}/hamster.${submissiontype} hamster.${submissiontype}-hadoop-${hadoopversion}-hdfsovernetworkfs-run-hadoopterasort-no-local-dir
    cp ../submission-scripts/testsuite/script-${submissiontype}/hamster.${submissiontype} hamster.${submissiontype}-hadoop-${hadoopversion}-hdfsoverlustre-localstore-single-path-run-hadoopterasort-no-local-dir
    cp ../submission-scripts/testsuite/script-${submissiontype}/hamster.${submissiontype} hamster.${submissiontype}-hadoop-${hadoopversion}-hdfsoverlustre-localstore-multiple-paths-run-hadoopterasort-no-local-dir
    cp ../submission-scripts/testsuite/script-${submissiontype}/hamster.${submissiontype} hamster.${submissiontype}-hadoop-${hadoopversion}-hdfsovernetworkfs-localstore-single-path-run-hadoopterasort-no-local-dir
    cp ../submission-scripts/testsuite/script-${submissiontype}/hamster.${submissiontype} hamster.${submissiontype}-hadoop-${hadoopversion}-hdfsovernetworkfs-localstore-multiple-paths-run-hadoopterasort-no-local-dir

    cp ../submission-scripts/testsuite/script-${submissiontype}/hamster.${submissiontype} hamster.${submissiontype}-hadoop-${hadoopversion}-hdfsoverlustre-run-fullvalidationterasort-no-local-dir
    cp ../submission-scripts/testsuite/script-${submissiontype}/hamster.${submissiontype} hamster.${submissiontype}-hadoop-${hadoopversion}-hdfsondisk-single-path-fullvalidationterasort-no-local-dir
    cp ../submission-scripts/testsuite/script-${submissiontype}/hamster.${submissiontype} hamster.${submissiontype}-hadoop-${hadoopversion}-hdfsondisk-multiple-paths-run-fullvalidationterasort-no-local-dir
    cp ../submission-scripts/testsuite/script-${submissiontype}/hamster.${submissiontype} hamster.${submissiontype}-hadoop-${hadoopversion}-hdfsovernetworkfs-run-fullvalidationterasort-no-local-dir
    cp ../submission-scripts/testsuite/script-${submissiontype}/hamster.${submissiontype} hamster.${submissiontype}-hadoop-${hadoopversion}-hdfsoverlustre-localstore-single-path-run-fullvalidationterasort-no-local-dir
    cp ../submission-scripts/testsuite/script-${submissiontype}/hamster.${submissiontype} hamster.${submissiontype}-hadoop-${hadoopversion}-hdfsoverlustre-localstore-multiple-paths-run-fullvalidationterasort-no-local-dir
    cp ../submission-scripts/testsuite/script-${submissiontype}/hamster.${submissiontype} hamster.${submissiontype}-hadoop-${hadoopversion}-hdfsovernetworkfs-localstore-single-path-run-fullvalidationterasort-no-local-dir
    cp ../submission-scripts/testsuite/script-${submissiontype}/hamster.${submissiontype} hamster.${submissiontype}-hadoop-${hadoopversion}-hdfsovernetworkfs-localstore-multiple-paths-run-fullvalidationterasort-no-local-dir
        
    sed -i -e 's/export HADOOP_VERSION="\(.*\)"/export HADOOP_VERSION="'"${hadoopversion}"'"/' hamster.${submissiontype}-hadoop-${hadoopversion}*
    
    sed -i -e 's/export HADOOP_FILESYSTEM_MODE="\(.*\)"/export HADOOP_FILESYSTEM_MODE="hdfs"/' hamster.${submissiontype}-hadoop-${hadoopversion}-hdfsondisk*
    sed -i -e 's/export HADOOP_HDFS_PATH="\(.*\)"/export HADOOP_HDFS_PATH="'"${ssddirpathsubst}"'\/a"/' hamster.${submissiontype}-hadoop-${hadoopversion}-hdfsondisk-single-path*
    sed -i -e 's/export HADOOP_HDFS_PATH="\(.*\)"/export HADOOP_HDFS_PATH="'"${ssddirpathsubst}"'\/a,'"${ssddirpathsubst}"'\/b,'"${ssddirpathsubst}"'\/c"/' hamster.${submissiontype}-hadoop-${hadoopversion}-hdfsondisk-multiple-paths*

    sed -i -e 's/# export HADOOP_HDFS_PATH_CLEAR="\(.*\)"/export HADOOP_HDFS_PATH_CLEAR="yes"/' hamster.${submissiontype}-hadoop-${hadoopversion}-hdfsondisk*

    SetupHDFSoverLustreStandard `ls \
        hamster.${submissiontype}-hadoop-${hadoopversion}-hdfsoverlustre*`

    SetupHDFSoverNetworkFSStandard `ls \
        hamster.${submissiontype}-hadoop-${hadoopversion}-hdfsovernetworkfs*`
    
    sed -i -e 's/# export HADOOP_LOCALSTORE="\(.*\)"/export HADOOP_LOCALSTORE="'"${ssddirpathsubst}"'\/localstore\/"/' hamster.${submissiontype}-hadoop-${hadoopversion}*localstore-single-path*
    
    sed -i -e 's/# export HADOOP_LOCALSTORE="\(.*\)"/export HADOOP_LOCALSTORE="'"${ssddirpathsubst}"'\/localstore\/a,'"${ssddirpathsubst}"'\/localstore\/b,'"${ssddirpathsubst}"'\/localstore\/c"/' hamster.${submissiontype}-hadoop-${hadoopversion}*localstore-multiple-paths*
    
    sed -i -e 's/# export HADOOP_LOCALSTORE_CLEAR="\(.*\)"/export HADOOP_LOCALSTORE_CLEAR="yes"/' hamster.${submissiontype}-hadoop-${hadoopversion}*localstore*

    sed -i \
        -e 's/# export HADOOP_TERASORT_RUN_TERACHECKSUM=no/export HADOOP_TERASORT_RUN_TERACHECKSUM=yes/' \
        -e 's/# export HADOOP_TERASORT_RUN_TERAVALIDATE=no/export HADOOP_TERASORT_RUN_TERAVALIDATE=yes/' \
        hamster.${submissiontype}-hadoop-${hadoopversion}*run-hadoopfullvalidationterasort*
}

GenerateHadoopStandardTests() {

    cd ${HAMSTER_SCRIPTS_HOME}/testsuite/

    echo "Making Hadoop Standard Tests"

    for testfunction in __GenerateHadoopStandardTests_StandardTerasort
    do
        ${testfunction} ${HADOOP_VERSION}
    done
}

GenerateHadoopPostProcessing() {
    files=`find . -maxdepth 1 -name "hamster.${submissiontype}*run-hadoopterasort*"`
    if [ -n "${files}" ]
    then
        sed -i -e "s/FILENAMESEARCHREPLACEKEY/run-hadoopterasort-FILENAMESEARCHREPLACEKEY/" ${files}
    fi

    files=`find . -maxdepth 1 -name "hamster.${submissiontype}*run-hadoopfullvalidationterasort*"`
    if [ -n "${files}" ]
    then
        sed -i -e "s/FILENAMESEARCHREPLACEKEY/run-hadoopfullvalidationterasort-FILENAMESEARCHREPLACEKEY/" ${files}
    fi

    files=`find . -maxdepth 1 -name "hamster.${submissiontype}-hadoop*run-scriptteragen*"`
    if [ -n "${files}" ]
    then
        sed -i -e "s/FILENAMESEARCHREPLACEKEY/run-scriptteragen-FILENAMESEARCHREPLACEKEY/" ${files}
    fi

    files=`find . -maxdepth 1 -name "hamster.${submissiontype}-hadoop*run-scriptterasort*"`
    if [ -n "${files}" ]
    then
        sed -i -e "s/FILENAMESEARCHREPLACEKEY/run-scriptterasort-FILENAMESEARCHREPLACEKEY/" ${files}
    fi

    files=`find . -maxdepth 1 -name "hamster.${submissiontype}-hadoop*run-hadoopupgradehdfs*"`
    if [ -n "${files}" ]
    then
        sed -i -e "s/FILENAMESEARCHREPLACEKEY/run-hadoopupgradehdfs-FILENAMESEARCHREPLACEKEY/" ${files}
    fi

    files=`find . -maxdepth 1 -name "hamster.${submissiontype}-hadoop*run-hadoopupgradehdfs*silentsuccess*"`
    if [ -n "${files}" ]
    then
        sed -i -e "s/FILENAMESEARCHREPLACEKEY/silentsuccess-FILENAMESEARCHREPLACEKEY/" ${files}
    fi

    files=`find . -maxdepth 1 -name "hamster.${submissiontype}*decommissionhdfsnodes*"`
    if [ -n "${files}" ]
    then
        sed -i -e "s/FILENAMESEARCHREPLACEKEY/decommissionhdfsnodes-FILENAMESEARCHREPLACEKEY/" ${files}
    fi

    files=`find . -maxdepth 1 -name "hamster.${submissiontype}*hdfs-fewer-nodes*expected-failure*"`
    if [ -n "${files}" ]
    then
        sed -i -e "s/FILENAMESEARCHREPLACEKEY/hdfs-fewer-nodes-expected-failure-FILENAMESEARCHREPLACEKEY/" ${files}
    fi

    files=`find . -maxdepth 1 -name "hamster.${submissiontype}*hdfs-older-version*expected-failure*"`
    if [ -n "${files}" ]
    then
        sed -i -e "s/FILENAMESEARCHREPLACEKEY/hdfs-older-version-expected-failure-FILENAMESEARCHREPLACEKEY/" ${files}
    fi

    files=`find . -maxdepth 1 -name "hamster.${submissiontype}*hdfs-newer-version*expected-failure*"`
    if [ -n "${files}" ]
    then
        sed -i -e "s/FILENAMESEARCHREPLACEKEY/hdfs-newer-version-expected-failure-FILENAMESEARCHREPLACEKEY/" ${files}
    fi

    files=`find . -maxdepth 1 -name "hamster.${submissiontype}-hadoop*hdfs-more-nodes*"`
    if [ -n "${files}" ]
    then
        sed -i -e "s/FILENAMESEARCHREPLACEKEY/hdfs-more-nodes-FILENAMESEARCHREPLACEKEY/" ${files}
    fi

    files=`find . -maxdepth 1 -name "hamster.${submissiontype}*" | grep -v Dependency`
    if [ -n "${files}" ]
    then
        sed -i -e 's/# export HADOOP_PER_JOB_HDFS_PATH="\(.*\)"/export HADOOP_PER_JOB_HDFS_PATH="yes"/' ${files}
    fi

    files=`find . -maxdepth 1 -name "hamster.${submissiontype}-hadoop*hdfs-more-nodes*"`
    if [ -n "${files}" ]
    then
        sed -i -e "s/<my node count>/${basenodesmorenodescount}/" ${files}
    fi

    files=`find . -maxdepth 1 -name "hamster.${submissiontype}-hadoop*hdfs-fewer-nodes*"`
    if [ -n "${files}" ]
    then
        sed -i -e "s/<my node count>/${basenodescount}/" ${files}
    fi
}
