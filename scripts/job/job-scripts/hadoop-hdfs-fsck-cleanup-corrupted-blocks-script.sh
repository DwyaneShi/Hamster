#!/bin/sh

# This script is useful for fixing HDFS corruption
source ${HAMSTER_SCRIPTS_HOME}/lib/hamster-lib-hadoop-helper

cd ${HADOOP_HOME}

local version=$(Hamster_hadoop_version)
if [ $version == "1" ]
then
    fsckscript="hadoop"
elif [ $version == "2" ]
then
    fsckscript="hdfs"
elif [ $version == "3" ]
then
    fsckscript="hdfs"
fi

# This will clean up corrupted/missing blocks
command="bin/${fsckscript} fsck -delete"
echo "Running $command" >&2
$command

# You may also just want to just look at fsck output w/
# bin/${fsckscript} fsck <absolute path to file>


exit 0
