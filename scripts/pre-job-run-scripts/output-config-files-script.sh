#!/bin/sh

# This is script outputs config files.
#
# It is a convenient script to use before your job is run.  You can
# set it with the HAMSTER_PRE_JOB_RUN environment variable in
# the main job submission file.

# Run only on one node, no need to do it on all nodes
if [ "${HAMSTER_CLUSTER_NODERANK}" == "0" ]
then
    echo "**** environment variables ****"
    printenv

    echo "**** resource limits ****"
    ulimit -a

    # Cat conf files for documentation

    if [ "${HADOOP_CONF_DIR}X" != "X" ]
    then
        if [ -f "${HADOOP_CONF_DIR}/hadoop-env.sh" ] 
        then
            echo "**** hadoop-env.sh ****"
            cat ${HADOOP_CONF_DIR}/hadoop-env.sh
        fi
        
        if [ -f "${HADOOP_CONF_DIR}/mapred-env.sh" ] 
        then
            echo "**** mapred-env.sh ****"
            cat ${HADOOP_CONF_DIR}/mapred-env.sh
        fi

        if [ -f "${HADOOP_CONF_DIR}/yarn-env.sh" ] 
        then
            echo "**** yarn-env.sh ****"
            cat ${HADOOP_CONF_DIR}/yarn-env.sh
        fi

        if [ -f "${HADOOP_CONF_DIR}/mapred-site.xml" ]
        then
            echo "**** mapred-site.xml ****"
            cat ${HADOOP_CONF_DIR}/mapred-site.xml
        fi

        if [ -f "${HADOOP_CONF_DIR}/core-site.xml" ]
        then
            echo "**** core-site.xml ****"
            cat ${HADOOP_CONF_DIR}/core-site.xml
        fi

        if [ -f "${HADOOP_CONF_DIR}/hdfs-site.xml" ] 
        then
            echo "**** hdfs-site.xml ****"
            cat ${HADOOP_CONF_DIR}/hdfs-site.xml
        fi

        if [ -f "${HADOOP_CONF_DIR}/yarn-site.xml" ] 
        then
            echo "**** yarn-site.xml ****"
            cat ${HADOOP_CONF_DIR}/yarn-site.xml
        fi
    fi

fi

exit 0
