# Creation options, set to y or n
#
# HAMSTER_NO_LOCAL_DIR - support HAMSTER_NO_LOCAL_DIR
#

HAMSTER_NO_LOCAL_DIR=n

#
# Adjust any of these paths for your own local defaults
#
HAMSTER_SCRIPTS_DIR_PREFIX=$${HOME}
LOCAL_DIR_PREFIX=/tmp/$${USER}
HOME_DIR_PREFIX=$${HOME}
LOCAL_DRIVE_PREFIX=/ssd/$${USER}

HAMSTER_PROJECTS="HADOOP SPARK"
HAMSTER_SETUP="HADOOP SPARK"

HADOOP_DIR_PREFIX=$${HOME}

JAVA_HOME=/usr/java/jdk1.7.0/

# The range shown in nodelist is node[001, 004], but the actual hostname is
# node001.cluster, ..., node004.cluster, then you need to set up this variable
# to fix.
HOSTNAME_SUFFIX=".cluster"

#
# Misc defaults
#

HADOOP_FILESYSTEM_MODE="hdfs"

HADOOP_VERSION=2.7.3
HADOOP_DAEMON_HEAP_MAX=102400

HIVE_VERSION=2.1.1
ZOOKEEPER_VERSION=3.4.9
ZOOKEEPER_DATADIR=/tmp/datadir
ZOOKEEPER_PORT=2231
SPARK_VERSION=2.1.0

#
# If LOCAL_REQUIREMENTS is set to 'y', whatever is in the file pointed
# by LOCAL_REQUIREMENTS_FILE will be added to submission scripts
# before the first call to hamster-check-inputs
#
LOCAL_REQUIREMENTS=n
LOCAL_REQUIREMENTS_FILE=/tmp/mylocal

# Default job files
SBATCH_SRUN_DEFAULT_JOB_FILE=slurm-%j.out

.DEFAULT_GOAL=all

all: sbatch-srun

clean-sbatch-srun:
	rm -f script-sbatch-srun/hamster.sbatch-srun*

clean: clean-sbatch-srun

sbatch-srun: clean-sbatch-srun
	$(call create-templates,$@,srun,$(SBATCH_SRUN_DEFAULT_JOB_FILE))

define common
	sed -i -e 's;HAMSTERSCRIPTSDIRPREFIX;$(HAMSTER_SCRIPTS_DIR_PREFIX);g' $(1)
	sed -i -e 's;HAMSTERHOSTNAMESUFFIX;$(HOSTNAME_SUFFIX);g' $(1)
	sed -i -e 's;LOCALDIRPREFIX;$(LOCAL_DIR_PREFIX);g' $(1)
	sed -i -e 's;HOMEDIRPREFIX;$(HOME_DIR_PREFIX);g' $(1)
	sed -i -e 's;LOCALDRIVEPREFIX;$(LOCAL_DRIVE_PREFIX);g' $(1)
	sed -i -e 's;HADOOPDIRPREFIX;$(HADOOP_DIR_PREFIX);g' $(1)
	sed -i -e 's;HADOOPDAEMONHEAPMAX;$(HADOOP_DAEMON_HEAP_MAX);g' $(1)
	sed -i -e 's;HADOOPVERSION;$(HADOOP_VERSION);g' $(1)
	sed -i -e 's;HIVEVERSION;$(HIVE_VERSION);g' $(1)
	sed -i -e 's;ZOOKEEPERVERSION;$(ZOOKEEPER_VERSION);g' $(1)
	sed -i -e 's;ZOOKEEPERDATADIR;$(ZOOKEEPER_DATADIR);g' $(1)
	sed -i -e 's;ZOOKEEPERPORT;$(ZOOKEEPER_PORT);g' $(1)
	sed -i -e 's;SPARKVERSION;$(SPARK_VERSION);g' $(1)
	sed -i -e 's;JAVAHOME;$(JAVA_HOME);g' $(1)
	sed -i -e 's;HAMSTERPROJECTS;$(HAMSTER_PROJECTS);g' $(1)
    sed -i -e 's;HADOOPFILESYSTEMMODE;$(HADOOP_FILESYSTEM_MODE);g' $(1)
	sed -i -e 's;DEFAULTJOBOUTPUTFILE;$(JOBOUTPUTFILE);g' $(1)
endef

define common-addition
	sed -i -e "/@HAMSTER_JOB_TYPES@/a @HAMSTER_JOB_TYPES_TEMP@/" $(1);
	sed -i -e "/@HAMSTER_JOB_TYPES@/d" $(1);
	sed -i -e "s/@HAMSTER_JOB_TYPES_TEMP@/@HAMSTER_JOB_TYPES@/" $(1);
endef

define common-addition-end
	sed -i -e "/@HAMSTER_JOB_TYPES@/d" $(1)
endef

define common-additions
	$(call common-addition, $(1))
	$(call common-addition-end, $(1))
endef

define create-templates
	cp ../templates/hamster-customizations hamster-customizations

	sed -i -e "/@HAMSTER_NO_LOCAL_DIR@/{r ../templates/hamster-customizations-no-local-dir" -e "d}" hamster-customizations

	cp ../templates/hamster-hadoop-filesystem hamster-hadoop-filesystem

	cp ../templates/hamster-run-job-header hamster-run-job-header

	if test "${LOCAL_REQUIREMENTS}" = "y"; then \
		if ! test -f "${LOCAL_REQUIREMENTS_FILE}"; then \
			echo "File ${LOCAL_REQUIREMENTS_FILE} is not a normal file"; \
			exit 1; \
		fi; \
		sed -i -e "/@LOCALREQUIREMENTS@/{r ${LOCAL_REQUIREMENTS_FILE}" -e "d}" hamster-run-job-header; \
	else \
		sed -i -e "/@LOCALREQUIREMENTS@/,+1d" hamster-run-job-header; \
	fi

	$(eval SCHED := $(1))
	$(eval DIST := $(2))
	$(eval JOBOUTPUTFILE := $(3))
	echo "Creating hamster.$(SCHED)"
	mkdir -p script-$(SCHED)
	$(eval HAMSTER := script-$(SCHED)/hamster.$(SCHED))

	$(call create-all)
endef

define create-all
	echo "Creating hamster.$(SCHED)"
	cat 	../templates/hamster-header \
		../templates/hamster-config-$(SCHED) \
		hamster-customizations \
		../templates/hamster-general-configuration \
		../templates/hamster-hadoop-core \
		../templates/hamster-hive-core \
		../templates/hamster-spark-core \
		../templates/hamster-hadoop-job-details \
		hamster-hadoop-filesystem \
		../templates/hamster-hadoop-mode-details \
		../templates/hamster-distribute-hosts \
		hamster-run-job-header \
		../templates/hamster-run-job-$(DIST) > $(HAMSTER)
	$(call common, ${HAMSTER})
	$(call common-additions, ${HAMSTER})
	sed -i -e "s/HAMSTER_JOB_TYPE=\"\(.*\)\"/HAMSTER_JOB_TYPE=\"script\"/" $(HAMSTER)
	for project in "${HAMSTER_SETUP}"; \
	do \
		sed -i -e "s/$${project}_SETUP=.*/$${project}_SETUP=yes/" $(HAMSTER); \
	done
endef
