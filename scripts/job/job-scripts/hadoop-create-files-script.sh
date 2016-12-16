#!/bin/sh

# This script executes some teragens.  It is convenient for putting
# data into your file system for some tests.
source ${HAMSTER_SCRIPTS_HOME}/lib/hamster-lib-hadoop-helper

cd ${HADOOP_HOME}

if Hamster_hadoop_is_MR 1
then
    terasortexamples="hadoop-examples-$HADOOP_VERSION.jar"
elif Hamster_hadoop_is_MR 2
then
    terasortexamples="share/hadoop/mapreduce/hadoop-mapreduce-examples-$HADOOP_VERSION.jar"
elif Hamster_hadoop_is_MR 3
then
    terasortexamples="share/hadoop/mapreduce/hadoop-mapreduce-examples-$HADOOP_VERSION.jar"
fi

command="bin/hadoop jar ${terasortexamples} teragen 50000000 teragen-1"
echo "Running $command" >&2
$command

command="bin/hadoop jar ${terasortexamples} teragen 50000000 teragen-2"
echo "Running $command" >&2
$command
   
command="bin/hadoop fs -ls"
echo "Running $command" >&2
$command

exit 0
