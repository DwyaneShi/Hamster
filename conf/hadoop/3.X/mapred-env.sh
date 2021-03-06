# Licensed to the Apache Software Foundation (ASF) under one or more
# contributor license agreements.  See the NOTICE file distributed with
# this work for additional information regarding copyright ownership.
# The ASF licenses this file to You under the Apache License, Version 2.0
# (the "License"); you may not use this file except in compliance with
# the License.  You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

export JAVA_HOME=HADOOP_JAVA_HOME

export HADOOP_JOB_HISTORYSERVER_HEAPSIZE=HADOOP_DAEMON_HEAP_MAX

export HADOOP_ROOT_LOGGER=INFO,RFA

export HADOOP_CONF_DIR=${HADOOP_CONF_DIR:-"HADOOPCONFDIR"}
export HADOOP_HOME="${HADOOP_HOME:-HADOOPHOME}"
export HADOOP_COMMON_HOME="${HADOOP_COMMON_HOME:-HADOOPCOMMONHOME}"
export HADOOP_MAPRED_HOME="${HADOOP_MAPRED_HOME:-HADOOPMAPREDHOME}"

export HADOOP_STOP_TIMEOUT=HADOOPTIMEOUTSECONDS
