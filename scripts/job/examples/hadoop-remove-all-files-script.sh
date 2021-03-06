#!/bin/sh

# This script removes all your files in HDFS.  It's convenient when
# doing testing.
source ${HAMSTER_SCRIPTS_HOME}/lib/hamster-lib-hadoop-helper

FILES=`${HADOOP_HOME}/bin/hadoop fs -ls 2> /dev/null | grep -v Found | awk '{print $8}'`

local version=$(Hamster_hadoop_version)
if [ $version == "1" ]
then
    rmoption="-rmr"
elif [ $version == "2" ]
then
    rmoption="-rm -r"
elif [ $version == "3" ]
then
    rmoption="-rm -r"
fi

for file in $FILES
do
    echo "Removing $file"
    ${HADOOP_HOME}/bin/hadoop fs ${rmoption} $file
done

exit 0
