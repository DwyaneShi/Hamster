#!/bin/bash

source test-config.sh

__SubmitHadoopStandardTests_StandardTerasort() {
    local hadoopversion=$1

    BasicJobSubmit hamster.${submissiontype}-hadoop-${hadoopversion}-hdfsoverlustre-run-hadoopterasort
    BasicJobSubmit hamster.${submissiontype}-hadoop-${hadoopversion}-hdfsondisk-single-path-hadoopterasort
    BasicJobSubmit hamster.${submissiontype}-hadoop-${hadoopversion}-hdfsondisk-multiple-paths-run-hadoopterasort
    BasicJobSubmit hamster.${submissiontype}-hadoop-${hadoopversion}-hdfsovernetworkfs-run-hadoopterasort
    BasicJobSubmit hamster.${submissiontype}-hadoop-${hadoopversion}-hdfsoverlustre-localstore-single-path-run-hadoopterasort
    BasicJobSubmit hamster.${submissiontype}-hadoop-${hadoopversion}-hdfsoverlustre-localstore-multiple-paths-run-hadoopterasort
    BasicJobSubmit hamster.${submissiontype}-hadoop-${hadoopversion}-hdfsovernetworkfs-localstore-single-path-run-hadoopterasort
    BasicJobSubmit hamster.${submissiontype}-hadoop-${hadoopversion}-hdfsovernetworkfs-localstore-multiple-paths-run-hadoopterasort

    BasicJobSubmit hamster.${submissiontype}-hadoop-${hadoopversion}-hdfsoverlustre-run-hadoopfullvalidationterasort
    BasicJobSubmit hamster.${submissiontype}-hadoop-${hadoopversion}-hdfsondisk-single-path-hadoopfullvalidationterasort
    BasicJobSubmit hamster.${submissiontype}-hadoop-${hadoopversion}-hdfsondisk-multiple-paths-run-hadoopfullvalidationterasort
    BasicJobSubmit hamster.${submissiontype}-hadoop-${hadoopversion}-hdfsovernetworkfs-run-hadoopfullvalidationterasort
    BasicJobSubmit hamster.${submissiontype}-hadoop-${hadoopversion}-hdfsoverlustre-localstore-single-path-run-hadoopfullvalidationterasort
    BasicJobSubmit hamster.${submissiontype}-hadoop-${hadoopversion}-hdfsoverlustre-localstore-multiple-paths-run-hadoopfullvalidationterasort
    BasicJobSubmit hamster.${submissiontype}-hadoop-${hadoopversion}-hdfsovernetworkfs-localstore-single-path-run-hadoopfullvalidationterasort
    BasicJobSubmit hamster.${submissiontype}-hadoop-${hadoopversion}-hdfsovernetworkfs-localstore-multiple-paths-run-hadoopfullvalidationterasort

    BasicJobSubmit hamster.${submissiontype}-hadoop-${hadoopversion}-hdfsoverlustre-run-hadoopterasort-no-local-dir
    BasicJobSubmit hamster.${submissiontype}-hadoop-${hadoopversion}-hdfsondisk-single-path-hadoopterasort-no-local-dir
    BasicJobSubmit hamster.${submissiontype}-hadoop-${hadoopversion}-hdfsondisk-multiple-paths-run-hadoopterasort-no-local-dir
    BasicJobSubmit hamster.${submissiontype}-hadoop-${hadoopversion}-hdfsovernetworkfs-run-hadoopterasort-no-local-dir
    BasicJobSubmit hamster.${submissiontype}-hadoop-${hadoopversion}-hdfsoverlustre-localstore-single-path-run-hadoopterasort-no-local-dir
    BasicJobSubmit hamster.${submissiontype}-hadoop-${hadoopversion}-hdfsoverlustre-localstore-multiple-paths-run-hadoopterasort-no-local-dir
    BasicJobSubmit hamster.${submissiontype}-hadoop-${hadoopversion}-hdfsovernetworkfs-localstore-single-path-run-hadoopterasort-no-local-dir
    BasicJobSubmit hamster.${submissiontype}-hadoop-${hadoopversion}-hdfsovernetworkfs-localstore-multiple-paths-run-hadoopterasort-no-local-dir

    BasicJobSubmit hamster.${submissiontype}-hadoop-${hadoopversion}-hdfsoverlustre-run-hadoopfullvalidationterasort-no-local-dir
    BasicJobSubmit hamster.${submissiontype}-hadoop-${hadoopversion}-hdfsondisk-single-path-hadoopfullvalidationterasort-no-local-dir
    BasicJobSubmit hamster.${submissiontype}-hadoop-${hadoopversion}-hdfsondisk-multiple-paths-run-hadoopfullvalidationterasort-no-local-dir
    BasicJobSubmit hamster.${submissiontype}-hadoop-${hadoopversion}-hdfsovernetworkfs-run-hadoopfullvalidationterasort-no-local-dir
    BasicJobSubmit hamster.${submissiontype}-hadoop-${hadoopversion}-hdfsoverlustre-localstore-single-path-run-hadoopfullvalidationterasort-no-local-dir
    BasicJobSubmit hamster.${submissiontype}-hadoop-${hadoopversion}-hdfsoverlustre-localstore-multiple-paths-run-hadoopfullvalidationterasort-no-local-dir
    BasicJobSubmit hamster.${submissiontype}-hadoop-${hadoopversion}-hdfsovernetworkfs-localstore-single-path-run-hadoopfullvalidationterasort-no-local-dir
    BasicJobSubmit hamster.${submissiontype}-hadoop-${hadoopversion}-hdfsovernetworkfs-localstore-multiple-paths-run-hadoopfullvalidationterasort-no-local-dir
}

SubmitHadoopStandardTests() {
    for testfunction in __SubmitHadoopStandardTests_StandardTerasort
    do
        ${testfunction} ${HADOOP_VERSION}
    done
}

__SubmitHadoopDependencyTests_Dependency1() {
    local hadoopversion=$1

    BasicJobSubmit hamster.${submissiontype}-hadoop-DependencyHadoop1A-hadoop-${hadoopversion}-hdfsoverlustre-run-hadoopterasort
    DependentJobSubmit hamster.${submissiontype}-hadoop-DependencyHadoop1A-hadoop-${hadoopversion}-hdfsoverlustre-run-hadoopterasort

    BasicJobSubmit hamster.${submissiontype}-hadoop-DependencyHadoop1A-hadoop-${hadoopversion}-hdfsovernetworkfs-run-hadoopterasort
    DependentJobSubmit hamster.${submissiontype}-hadoop-DependencyHadoop1A-hadoop-${hadoopversion}-hdfsovernetworkfs-run-hadoopterasort
}

__SubmitHadoopDependencyTests_Dependency2() {
    local hadoopversion=$1

    BasicJobSubmit hamster.${submissiontype}-hadoop-${hadoopversion}-DependencyHadoop2A-hdfsoverlustre-run-hadoopterasort
    DependentJobSubmit hamster.${submissiontype}-hadoop-${hadoopversion}-DependencyHadoop2A-hdfs-more-nodes-hdfsoverlustre-run-hadoopterasort
    DependentJobSubmit hamster.${submissiontype}-hadoop-${hadoopversion}-DependencyHadoop2A-hdfs-fewer-nodes-hdfsoverlustre-expected-failure
    DependentJobSubmit hamster.${submissiontype}-hadoop-${hadoopversion}-DependencyHadoop2A-hdfs-more-nodes-decommissionhdfsnodes-hdfsoverlustre
    DependentJobSubmit hamster.${submissiontype}-hadoop-${hadoopversion}-DependencyHadoop2A-hdfsoverlustre-run-hadoopterasort

    BasicJobSubmit hamster.${submissiontype}-hadoop-${hadoopversion}-DependencyHadoop2A-hdfsovernetworkfs-run-hadoopterasort
    DependentJobSubmit hamster.${submissiontype}-hadoop-${hadoopversion}-DependencyHadoop2A-hdfs-more-nodes-hdfsovernetworkfs-run-hadoopterasort
    DependentJobSubmit hamster.${submissiontype}-hadoop-${hadoopversion}-DependencyHadoop2A-hdfs-fewer-nodes-hdfsovernetworkfs-expected-failure
    DependentJobSubmit hamster.${submissiontype}-hadoop-${hadoopversion}-DependencyHadoop2A-hdfs-more-nodes-decommissionhdfsnodes-hdfsovernetworkfs
    DependentJobSubmit hamster.${submissiontype}-hadoop-${hadoopversion}-DependencyHadoop2A-hdfsovernetworkfs-run-hadoopterasort
}

__SubmitHadoopDependencyTests_Dependency3() {
    local hadoopversion=$1

    BasicJobSubmit hamster.${submissiontype}-hadoop-${hadoopversion}-DependencyHadoop3A-hdfsoverlustre-run-scriptteragen
    DependentJobSubmit hamster.${submissiontype}-hadoop-${hadoopversion}-DependencyHadoop3A-hdfsoverlustre-run-scriptterasort
    DependentJobSubmit hamster.${submissiontype}-hadoop-${hadoopversion}-DependencyHadoop3A-hdfs-more-nodes-hdfsoverlustre-run-scriptterasort
    DependentJobSubmit hamster.${submissiontype}-hadoop-${hadoopversion}-DependencyHadoop3A-hdfs-fewer-nodes-hdfsoverlustre-expected-failure
    DependentJobSubmit hamster.${submissiontype}-hadoop-${hadoopversion}-DependencyHadoop3A-hdfs-more-nodes-decommissionhdfsnodes-hdfsoverlustre
    DependentJobSubmit hamster.${submissiontype}-hadoop-${hadoopversion}-DependencyHadoop3A-hdfsoverlustre-run-scriptterasort

    BasicJobSubmit hamster.${submissiontype}-hadoop-${hadoopversion}-DependencyHadoop3A-hdfsovernetworkfs-run-scriptteragen
    DependentJobSubmit hamster.${submissiontype}-hadoop-${hadoopversion}-DependencyHadoop3A-hdfsovernetworkfs-run-scriptterasort
    DependentJobSubmit hamster.${submissiontype}-hadoop-${hadoopversion}-DependencyHadoop3A-hdfs-more-nodes-hdfsovernetworkfs-run-scriptterasort
    DependentJobSubmit hamster.${submissiontype}-hadoop-${hadoopversion}-DependencyHadoop3A-hdfs-fewer-nodes-hdfsovernetworkfs-expected-failure
    DependentJobSubmit hamster.${submissiontype}-hadoop-${hadoopversion}-DependencyHadoop3A-hdfs-more-nodes-decommissionhdfsnodes-hdfsovernetworkfs
    DependentJobSubmit hamster.${submissiontype}-hadoop-${hadoopversion}-DependencyHadoop3A-hdfsovernetworkfs-run-scriptterasort
}

__SubmitHadoopDependencyTests_Dependency4() {
    local hadoopversion=$1

    BasicJobSubmit hamster.${submissiontype}-hadoop-${hadoopversion}-DependencyHadoop4A-hdfs-more-nodes-hdfsoverlustre-run-scriptteragen
    DependentJobSubmit hamster.${submissiontype}-hadoop-${hadoopversion}-DependencyHadoop4A-hdfs-more-nodes-hdfsoverlustre-run-scriptterasort
    DependentJobSubmit hamster.${submissiontype}-hadoop-${hadoopversion}-DependencyHadoop4A-hdfs-more-nodes-decommissionhdfsnodes-hdfsoverlustre
    DependentJobSubmit hamster.${submissiontype}-hadoop-${hadoopversion}-DependencyHadoop4A-hdfsoverlustre-run-scriptterasort

    BasicJobSubmit hamster.${submissiontype}-hadoop-${hadoopversion}-DependencyHadoop4A-hdfs-more-nodes-hdfsovernetworkfs-run-scriptteragen
    DependentJobSubmit hamster.${submissiontype}-hadoop-${hadoopversion}-DependencyHadoop4A-hdfs-more-nodes-hdfsovernetworkfs-run-scriptterasort
    DependentJobSubmit hamster.${submissiontype}-hadoop-${hadoopversion}-DependencyHadoop4A-hdfs-more-nodes-decommissionhdfsnodes-hdfsovernetworkfs
    DependentJobSubmit hamster.${submissiontype}-hadoop-${hadoopversion}-DependencyHadoop4A-hdfsovernetworkfs-run-scriptterasort
}

__SubmitHadoopDependencyTests_Dependency5 () {
    local dependencynumber=$1
    shift
    local silentsuccess=$1
    shift
    local firstversion=$1
    shift
    local restofversions=$@
    
    BasicJobSubmit hamster.${submissiontype}-hadoop-${firstversion}-DependencyHadoop${dependencynumber}-hdfsoverlustre-run-hadoopterasort

    for version in ${restofversions}
    do
        DependentJobSubmit hamster.${submissiontype}-hadoop-${version}-DependencyHadoop${dependencynumber}-hdfsoverlustre-hdfs-older-version-expected-failure
        if [ "${silentsuccess}" == "y" ]
        then
            DependentJobSubmit hamster.${submissiontype}-hadoop-${version}-DependencyHadoop${dependencynumber}-hdfsoverlustre-run-hadoopupgradehdfs-silentsuccess
        else
            DependentJobSubmit hamster.${submissiontype}-hadoop-${version}-DependencyHadoop${dependencynumber}-hdfsoverlustre-run-hadoopupgradehdfs
        fi
        
        DependentJobSubmit hamster.${submissiontype}-hadoop-${version}-DependencyHadoop${dependencynumber}-hdfsoverlustre-run-hadoopterasort
    done
    
    BasicJobSubmit hamster.${submissiontype}-hadoop-${firstversion}-DependencyHadoop${dependencynumber}-hdfsovernetworkfs-run-hadoopterasort
    
    for version in ${restofversions}
    do
        DependentJobSubmit hamster.${submissiontype}-hadoop-${version}-DependencyHadoop${dependencynumber}-hdfsovernetworkfs-hdfs-older-version-expected-failure

        if [ "${silentsuccess}" == "y" ]
        then
            DependentJobSubmit hamster.${submissiontype}-hadoop-${version}-DependencyHadoop${dependencynumber}-hdfsovernetworkfs-run-hadoopupgradehdfs-silentsuccess
        else
            DependentJobSubmit hamster.${submissiontype}-hadoop-${version}-DependencyHadoop${dependencynumber}-hdfsovernetworkfs-run-hadoopupgradehdfs
        fi

        DependentJobSubmit hamster.${submissiontype}-hadoop-${version}-DependencyHadoop${dependencynumber}-hdfsovernetworkfs-run-hadoopterasort
    done
}

__SubmitHadoopDependencyTests_DependencyDetectNewerHDFS() {
    local hadoopversionold=$1
    local hadoopversionnew=$2
    local dependencynumber=$3

    BasicJobSubmit hamster.${submissiontype}-hadoop-${hadoopversionnew}-DependencyHadoop${dependencynumber}-hdfsoverlustre-run-hadoopterasort
    DependentJobSubmit hamster.${submissiontype}-hadoop-${hadoopversionold}-DependencyHadoop${dependencynumber}-hdfsoverlustre-hdfs-newer-version-expected-failure

    BasicJobSubmit hamster.${submissiontype}-hadoop-${hadoopversionnew}-DependencyHadoop${dependencynumber}-hdfsovernetworkfs-run-hadoopterasort
    DependentJobSubmit hamster.${submissiontype}-hadoop-${hadoopversionold}-DependencyHadoop${dependencynumber}-hdfsovernetworkfs-hdfs-newer-version-expected-failure
}

SubmitHadoopDependencyTests() {
    for testfunction in __SubmitHadoopDependencyTests_Dependency1 __SubmitHadoopDependencyTests_Dependency2 __SubmitHadoopDependencyTests_Dependency3 __SubmitHadoopDependencyTests_Dependency4
    do
        for testgroup in ${hadoop_test_groups}
        do
            for testversion in ${!testgroup}
            do
                ${testfunction} ${testversion}
            done
        done
    done
}
