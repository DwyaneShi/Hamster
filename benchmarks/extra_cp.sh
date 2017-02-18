#!/bin/bash
base_dir=${HAMSTER_SCRIPTS_HOME}/benchmarks
# hive-testbench
cp=${cp}:${base_dir}/hive-testbench/tpch-gen/target/*.jar:${base_dir}/hive-testbench/tpcds-gen/target/*.jar

# return extra class path
echo ${cp}
