#!/bin/bash

source test-config.sh

verboseoutput=n
deprecateoutput=n

while [[ $# -gt 0 ]]
do
    key="$1"
    case $key in
        -v|--verbose)
            verboseoutput=y
            ;;
        -e|--deprecate)
            deprecateoutput=y
            ;;
        *)
            echo "Usage: test-validate [-v] [-e]"
            exit 1
            ;;
    esac
    shift
done

if [ "${submissiontype}" == "sbatch-srun" ]
then
    outputprefix="slurm"
fi

__get_test_files () {
    local filekeys=$@

    test_validate_files=""
    for str in $filekeys
    do
        filestmp=`find . -maxdepth 1 -name "${outputprefix}*${str}*"`
        if [ -n "${filestmp}" ]
        then
            test_validate_files="${test_validate_files}${test_validate_files:+" "}${filestmp}"
        fi
    done

    if [ "${test_validate_files}X" != "X" ]
    then
        return 0
    fi

    return 1
}

__test_yarn_shutdown () {
    local file=$1
    num=`grep -e "stopping yarn daemons" $file | wc -l`
    if [ "${num}" != "1" ]; then
        echo "Yarn shutdown error in $file"
    fi

    num=`grep -e "stopping resourcemanager" $file | wc -l`
    if [ "${num}" != "1" ]; then
        echo "Yarn shutdown error in $file"
    fi

    num=`grep -e "stopping nodemanager" $file | wc -l`
    if echo ${file} | grep -q "hdfs-more-nodes"
    then
        numcompare=`expr ${basenodecount} \* 2`
    else
        numcompare=${basenodecount}
    fi
    if [ "${num}" != "$numcompare" ]; then
        echo "Yarn nodemanager shutdown error in $file"
    fi
}

__test_hdfs_shutdown () {
    local file=$1
    num=`grep -e "stopping namenode" $file | wc -l`
    if [ "${num}" != "1" ]; then
        echo "Namenode shutdown error in $file"
    fi

    num=`grep -e "stopping datanode" $file | wc -l`
    if echo ${file} | grep -q "hdfs-more-nodes"
    then
        numcompare=`expr ${basenodecount} \* 2`
    else
        numcompare=${basenodecount}
    fi
    if [ "${num}" != "$numcompare" ]; then
        echo "Datanode shutdown error in $file"
    fi

    num=`grep -e "stopping secondarynamenode" $file | wc -l`
    if [ "${num}" != "1" ]; then
        echo "secondary namenode shutdown error in $file"
    fi
}

__test_hadoop_shutdown () {
    local file=$1

    __test_yarn_shutdown $file

    __test_hdfs_shutdown $file
}

__test_no_hdfs_shutdown () {
    local file=$1
    num=`grep -e "stopping namenode" $file | wc -l`
    if [ "${num}" != "0" ]; then
        echo "Namenode shutdown error in $file"
    fi

    num=`grep -e "stopping datanode" $file | wc -l`
    if [ "${num}" != "0" ]; then
        echo "Datanode shutdown error in $file"
    fi

    num=`grep -e "stopping secondarynamenode" $file | wc -l`
    if [ "${num}" != "0" ]; then
        echo "secondary namenode shutdown error in $file"
    fi
}

__test_generic () {
    num=`grep -e "Hamster Internal" $file | wc -l`
    if [ "${num}" != "0" ]; then
        echo "Internal Hamster error detected in $file"
    fi

    if [ "${deprecateoutput}" == "y" ]
    then
        num=`grep -i -e "deprecated" $file | wc -l`
        if [ "${num}" != "0" ]; then
            echo "Deprecated keyword detected in $file"
        fi
    fi
}

__test_output_finalize () {
    local file=$1

    if [ "${verboseoutput}" == "y" ]
    then
        echo "File ${file} run through validation"
    fi
}

__get_test_files interactivemode setuponlymode
if [ $? -eq 0 ]
then
    for file in ${test_validate_files}
    do
        if echo ${file} | grep -q "interactivemode"
        then
            num=`grep -e "Entering \(.*\) interactive mode" $file | wc -l`
        else
            num=`grep -e "Entering \(.*\) setuponly mode" $file | wc -l`
        fi
        if [ "${num}" != "1" ]; then
            echo "Error in $file"
        fi

        num=`grep -e "*** Warning - 1 minute left" $file | wc -l`
        if [ "${num}" != "1" ]; then
            echo "Error in $file"
        fi

        if echo ${file} | grep -q "interactivemode"
        then
            num=`grep -e "End of 'interactive' mode" $file | wc -l`
            if [ "${num}" != "1" ]; then
                echo "Error in $file"
            fi
        fi

        __test_generic $file
        __test_output_finalize $file
    done
fi

__get_test_files jobtimeout
if [ $? -eq 0 ]
then
    for file in ${test_validate_files}
    do
        num=`grep -e "Killing script, did not exit within time limit" $file | wc -l`
        if [ "${num}" != "1" ]; then
            echo "Error in $file"
        fi

        __test_generic $file
        __test_output_finalize $file
    done
fi

__get_test_files catchprojectdependency
if [ $? -eq 0 ]
then
    for file in ${test_validate_files}
    do
        # This is the more common catch
        num1=`grep -e "\(.*\) requires \(.*\) to be setup, set \(.*\) to yes" $file | wc -l`
        # Possible nothing has been enabled that can run, also likely catch
        num2=`grep -e "there is nothing to setup" $file | wc -l`
        # This error is specific to Hadoop accidentally not enabled
        num3=`grep -e "must be set if Hadoop is not setup" $file | wc -l`
        if [ "${num1}" == "0" ] && [ "${num2}" == "0" ] && [ "${num3}" == "0" ]
        then
            echo "Error in $file"
        fi

        __test_generic $file
        __test_output_finalize $file
    done
fi

__get_test_files nosetjava nosetversion nosethome nosetlocaldir nosetscript nocoresettings badcoresettings requirehdfs requireyarn badcombosettings
if [ $? -eq 0 ]
then
    for file in ${test_validate_files}
    do
        num=`grep -e "must be set" $file | wc -l`
        if [ "${num}" == "0" ]
        then
            echo "Error in $file"
        fi

        __test_generic $file
        __test_output_finalize $file
    done
fi

__get_test_files badsetjava badsethome
if [ $? -eq 0 ]
then
    for file in ${test_validate_files}
    do
        num=`grep -e "does not point to a directory" $file | wc -l`
        if [ "${num}" == "0" ]
        then
            echo "Error in $file"
        fi

        __test_generic $file
        __test_output_finalize $file
    done
fi

__get_test_files badlocaldir baddirectories
if [ $? -eq 0 ]
then
    for file in ${test_validate_files}
    do
        num=`grep -e "mkdir failed making" $file | wc -l`
        if [ "${num}" == "0" ]
        then
            echo "Error in $file"
        fi

        __test_generic $file
        __test_output_finalize $file
    done
fi

__get_test_files badsetscript
if [ $? -eq 0 ]
then
    for file in ${test_validate_files}
    do
        num1=`grep -e "does not point to a regular file" $file | wc -l`
        num2=`grep -e "does not have execute permissions" $file | wc -l`
        if [ "${num1}" == "0" ] && [ "${num2}" == "0" ]
        then
            echo "Error in $file"
        fi

        __test_generic $file
        __test_output_finalize $file
    done
fi

__get_test_files badjobtime
if [ $? -eq 0 ]
then
    for file in ${test_validate_files}
    do
        num=`grep -e "timelimit must be atleast the sum of HAMSTER_STARTUP_TIME & HAMSTER_SHUTDOWN_TIME" $file | wc -l`
        if [ "${num}" == "0" ]
        then
            echo "Error in $file"
        fi

        __test_generic $file
        __test_output_finalize $file
    done
fi

__get_test_files badstartuptime
if [ $? -eq 0 ]
then
    for file in ${test_validate_files}
    do
        num=`grep -e "HAMSTER_STARTUP_TIME must be >= 5 minutes if HAMSTER_PRE_JOB_RUN is set" $file | wc -l`
        if [ "${num}" == "0" ]
        then
            echo "Error in $file"
        fi

        __test_generic $file
        __test_output_finalize $file
    done
fi

__get_test_files badshutdowntime
if [ $? -eq 0 ]
then
    for file in ${test_validate_files}
    do
        num=`grep -e "HAMSTER_SHUTDOWN_TIME must be >= 10 minutes if HAMSTER_POST_JOB_RUN is set" $file | wc -l`
        if [ "${num}" == "0" ]
        then
            echo "Error in $file"
        fi

        __test_generic $file
        __test_output_finalize $file
    done
fi

__get_test_files badnodecount
if [ $? -eq 0 ]
then
    for file in ${test_validate_files}
    do
        if echo ${file} | grep -q "small"
        then
            num=`grep -e "No remaining nodes for \(.*\), increase node count or adjust node allocations" $file | wc -l`
        else
            num=`grep -e "No remaining slave nodes after Zookeeper allocation" $file | wc -l`
        fi
        if [ "${num}" == "0" ]
        then
            echo "Error in $file"
        fi

        __test_generic $file
        __test_output_finalize $file
    done
fi

__check_exports_hamster () {
    local file=$1

    num=`grep -E "HAMSTER_CLUSTER_NODERANK=[0-9]+" ${file} | wc -l`
    if [ "${num}" == 0 ]
    then
        echo "Error in $file - can't find export HAMSTER_CLUSTER_NODERANK"
    fi

    num=`grep -E "HAMSTER_NODE_COUNT=[0-9]+" ${file} | wc -l`
    if [ "${num}" == 0 ]
    then
        echo "Error in $file - can't find export HAMSTER_NODE_COUNT"
    fi

    num=`grep -E "HAMSTER_NODELIST=.+" ${file} | wc -l`
    if [ "${num}" == 0 ]
    then
        echo "Error in $file - can't find export HAMSTER_NODELIST"
    fi

    num=`grep -E "HAMSTER_JOB_NAME=.+" ${file} | wc -l`
    if [ "${num}" == 0 ]
    then
        echo "Error in $file - can't find export HAMSTER_JOB_NAME"
    fi

    num=`grep -E "HAMSTER_JOB_ID=.+" ${file} | wc -l`
    if [ "${num}" == 0 ]
    then
        echo "Error in $file - can't find export HAMSTER_JOB_ID"
    fi

    num=`grep -E "HAMSTER_TIMELIMIT_MINUTES=[0-9]+" ${file} | wc -l`
    if [ "${num}" == 0 ]
    then
        echo "Error in $file - can't find export HAMSTER_TIMELIMIT_MINUTES"
    fi
}

__check_exports_project_confdir () {
    local file=$1
    local project=$2

    num=`grep -E "${project}_CONF_DIR=.+" ${file} | wc -l`
    if [ "${num}" == 0 ]
    then
        echo "Error in $file - can't find export ${project}_CONF_DIR"
    fi
}

__check_exports_project_logdir () {
    local file=$1
    local project=$2

    num=`grep -E "${project}_LOG_DIR=.+" ${file} | wc -l`
    if [ "${num}" == 0 ]
    then
        echo "Error in $file - can't find export ${project}_LOG_DIR"
    fi
}

__check_exports_project_base () {
    local file=$1
    local project=$2

    __check_exports_project_confdir ${file} ${project}
    __check_exports_project_logdir ${file} ${project}
}

__check_exports_hadoop () {
    local file=$1

    __check_exports_project_base ${file} "HADOOP"
    
    num=`grep -E "HADOOP_MASTER_NODE=.+" ${file} | wc -l`
    if [ "${num}" == 0 ]
    then
        echo "Error in $file - can't find export HADOOP_MASTER_NODE"
    fi

    num=`grep -E "HADOOP_SLAVE_COUNT=[0-9]+" ${file} | wc -l`
    if [ "${num}" == 0 ]
    then
        echo "Error in $file - can't find export HADOOP_SLAVE_COUNT"
    fi

    num=`grep -E "HADOOP_SLAVE_CORE_COUNT=[0-9]+" ${file} | wc -l`
    if [ "${num}" == 0 ]
    then
        echo "Error in $file - can't find export HADOOP_SLAVE_CORE_COUNT"
    fi

    if echo "${file}" | grep -q "hdfs"
    then
        num=`grep -E "HADOOP_NAMENODE=.+" ${file} | wc -l`
        if [ "${num}" == 0 ]
        then
            echo "Error in $file - can't find export HADOOP_NAMENODE"
        fi

        num=`grep -E "HADOOP_NAMENODE_PORT=[0-9]+" ${file} | wc -l`
        if [ "${num}" == 0 ]
        then
            echo "Error in $file - can't find export HADOOP_NAMENODE_PORT"
        fi
    fi
}

__get_test_files checkexports
if [ $? -eq 0 ]
then
    for file in ${test_validate_files}
    do
        __check_exports_hamster ${file}

        if echo ${file} | grep -q "hadoop"
        then
            __check_exports_hadoop ${file}
        fi

        __test_generic $file
        __test_output_finalize $file
    done
fi

__check_prepostrunscripts () {
    local file=$1
    local preorpost=$2

    num=`grep -e "${preorpost}RUN SCRIPT" $file | wc -l`
    if [ "${num}" == "0" ]
    then
        echo "Error in $file"
    fi
}

__get_test_files prepostrunscripts
if [ $? -eq 0 ]
then
    for file in ${test_validate_files}
    do
        __check_prepostrunscripts ${file} "PRE"
        __check_prepostrunscripts ${file} "POST"
        
        __test_generic $file
        __test_output_finalize $file
    done
fi

__get_test_files prerunscripterror
if [ $? -eq 0 ]
then
    for file in ${test_validate_files}
    do
        __check_prepostrunscripts ${file} "PRE"
        
        num=`grep -e "Hamster General Job Info" $file | wc -l`
        if [ "${num}" != "0" ]; then
            echo "Error in $file"
        fi
        
        __test_generic $file
        __test_output_finalize $file
    done
fi

__get_test_files run-hadoopterasort
if [ $? -eq 0 ]
then
    for file in ${test_validate_files}
    do
        num=`grep -e "completed successfully" $file | wc -l`
        if echo ${file} | grep -q "run-clustersyntheticcontrol"
        then
            # runs clustering algorithm, can be random-ish, we'll
            # guess it always takes atleast 5 iters
            if [ "${num}" -lt "7" ]; then
                echo "Error in $file"
            fi
        else
            if [ "${num}" != "2" ]; then
                echo "Error in $file"
            fi
        fi
        
        __test_hadoop_shutdown $file

        __test_generic $file
        __test_output_finalize $file
    done
fi

__get_test_files run-hadoopfullvalidationterasort
if [ $? -eq 0 ]
then
    for file in ${test_validate_files}
    do
        num=`grep -e "completed successfully" $file | wc -l`
        if [ "${num}" != "4" ]; then
            echo "Error in $file"
        fi

        num=`grep -e "TeraSort Checksum Comparison: Input and output checksums match" $file | wc -l`
        if [ "${num}" != "1" ]; then
            echo "Error in $file"
        fi
        
        __test_hadoop_shutdown $file

        __test_generic $file
        __test_output_finalize $file
    done
fi

__get_test_files run-scriptteragen
if [ $? -eq 0 ]
then
    for file in ${test_validate_files}
    do
        num=`grep -e "completed successfully" $file | wc -l`
        if [ "${num}" != "1" ]; then
            echo "Error in $file"
        fi
        
        __test_generic $file
        __test_hadoop_shutdown $file

        __test_generic $file
        __test_output_finalize $file
    done
fi

__get_test_files run-scriptterasort
if [ $? -eq 0 ]
then
    for file in ${test_validate_files}
    do
        num=`grep -e "completed successfully" $file | wc -l`
        if [ "${num}" != "1" ]; then
            echo "Error in $file"
        fi
        
        __test_hadoop_shutdown $file

        __test_generic $file
        __test_output_finalize $file
    done
fi

__get_test_files run-hadoopupgradehdfs
if [ $? -eq 0 ]
then
    for file in ${test_validate_files}
    do
        num=`grep -e "Finalize upgrade successful" $file | wc -l`
        if echo ${file} | grep -q "silentsuccess"
        then
            if [ "${num}" != "0" ]; then
                echo "Error in $file"
            fi
        else
            if [ "${num}" != "1" ]; then
                echo "Error in $file"
            fi
        fi
        
        __test_hadoop_shutdown $file

        __test_generic $file
        __test_output_finalize $file
    done
fi

__get_test_files "hdfs-older-version*expected-failure"
if [ $? -eq 0 ]
then
    for file in ${test_validate_files}
    do
        num=`grep -e "HDFS version at mount" $file | grep -e "is older than" | wc -l`
        if [ "${num}" != "1" ]; then
            echo "Error in $file"
        fi
        
        __test_no_hdfs_shutdown $file

        __test_generic $file
        __test_output_finalize $file
    done
fi

__get_test_files "hdfs-newer-version*expected-failure"
if [ $? -eq 0 ]
then
    for file in ${test_validate_files}
    do
        num=`grep -e "HDFS version at mount" $file | grep -e "is newer than" | wc -l`
        if [ "${num}" != "1" ]; then
            echo "Error in $file"
        fi
        
        __test_no_hdfs_shutdown $file

        __test_generic $file
        __test_output_finalize $file
    done
fi

__get_test_files "hdfs-fewer-nodes*expected-failure"
if [ $? -eq 0 ]
then
    for file in ${test_validate_files}
    do
        num=`grep -e "HDFS was last built using a larger slave node count" $file | wc -l`
        if [ "${num}" != "1" ]; then
            echo "Error in $file"
        fi
        
        __test_no_hdfs_shutdown $file

        __test_generic $file
        __test_output_finalize $file
    done
fi

__get_test_files decommissionhdfsnodes
if [ $? -eq 0 ]
then
    for file in ${test_validate_files}
    do
        num=`grep -e "Decommissioned ${basenodecount} nodes" $file | wc -l`
        if [ "${num}" != "1" ]; then
            echo "Error in $file"
        fi
        
        # On some jobs, Yarn may run, others maybe not, only test HDFS shutdown proper
        __test_hdfs_shutdown $file

        __test_generic $file
        __test_output_finalize $file
    done
fi

__get_test_files run-clustersyntheticcontrol
if [ $? -eq 0 ]
then
    for file in ${test_validate_files}
    do
        num=`grep -e "Dumping out clusters from clusters" $file | wc -l`
        if [ "${num}" != "1" ]; then
            echo "Error in $file"
        fi
        
        __test_hadoop_shutdown $file

        __test_generic $file
        __test_output_finalize $file
    done
fi
