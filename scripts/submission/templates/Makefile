# Creation options, set to y or n
#
# HAMSTER_NO_LOCAL_DIR - support HAMSTER_NO_LOCAL_DIR
#
# INSERT_INTELLUSTRE - insert intellustre configuration
#
# INSERT_HAMSTERNETWORKFS - insert hamsternetworkfs configuration
#
# INSERT_HDFSOVERLUSTRE - insert HDFS over Lustre configuration
#
# INSERT_HDFSOVERNETWORKFS - insert HDFS over NetworkFS configuration
#
# INSERT_HDFS_FEDERATION - insert HDFS federation configuration 
#

HAMSTER_NO_LOCAL_DIR=n
INSERT_INTELLUSTRE=n
INSERT_HAMSTERNETWORKFS=n
INSERT_HDFSOVERLUSTRE=n
INSERT_HDFSOVERNETWORKFS=n
INSERT_HDFS_FEDERATION=n

#
# Adjust any of these paths for your own local defaults
#
HAMSTER_SCRIPTS_DIR_PREFIX=$${HOME}
LOCAL_DIR_PREFIX=/tmp/$${USER}
HOME_DIR_PREFIX=$${HOME}
LUSTRE_DIR_PREFIX=/lustre/$${USER}
NETWORKFS_DIR_PREFIX=/networkfs/$${USER}
RAWNETWORKFS_DIR_PREFIX=/lustre/$${USER}
LOCAL_DRIVE_PREFIX=/ssd/$${USER}

HADOOP_DIR_PREFIX=$${HOME}

JAVA_HOME=/usr/java/jdk1.7.0/

# The range shown in nodelist is node[001, 004], but the actual hostname is
# node001.cluster, ..., node004.cluster, then you need to set up this variable
# to fix.
HOSTNAME_SUFFIX=".cluster"

# Run with n datanodes killed after setting up

HAMSTER_NUM_OF_KILLED_DNS=

#
# Misc defaults
#

HADOOP_FILESYSTEM_MODE="hdfs"
HADOOP_DEFAULT_TERASORT_SIZE=50000000

HADOOP_SETUP_TYPE=MR
HADOOP_VERSION=2.7.3
HADOOP_DAEMON_HEAP_MAX=10240

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
	sed -i -e 's;HAMSTERNUMOFKILLEDDNS;$(HAMSTER_NUM_OF_KILLED_DNS);g' $(1)
	sed -i -e 's;LOCALDIRPREFIX;$(LOCAL_DIR_PREFIX);g' $(1)
	sed -i -e 's;HOMEDIRPREFIX;$(HOME_DIR_PREFIX);g' $(1)
	sed -i -e 's;LUSTREDIRPREFIX;$(LUSTRE_DIR_PREFIX);g' $(1)
	sed -i -e 's;NETWORKFSDIRPREFIX;$(NETWORKFS_DIR_PREFIX);g' $(1)
	sed -i -e 's;RAWFSDIRPREFIX;$(RAWNETWORKFS_DIR_PREFIX);g' $(1)
	sed -i -e 's;LOCALDRIVEPREFIX;$(LOCAL_DRIVE_PREFIX);g' $(1)
	sed -i -e 's;HADOOPDIRPREFIX;$(HADOOP_DIR_PREFIX);g' $(1)
	sed -i -e 's;HADOOPSETUPTYPE;$(HADOOP_SETUP_TYPE);g' $(1)
	sed -i -e 's;HADOOPDAEMONHEAPMAX;$(HADOOP_DAEMON_HEAP_MAX);g' $(1)
	sed -i -e 's;HADOOPVERSION;$(HADOOP_VERSION);g' $(1)
	sed -i -e 's;JAVAHOME;$(JAVA_HOME);g' $(1)
    sed -i -e 's;HADOOPFILESYSTEMMODE;$(HADOOP_FILESYSTEM_MODE);g' $(1)
	sed -i -e 's;HADOOPDEFAULTTERASORTSIZE;$(HADOOP_DEFAULT_TERASORT_SIZE);g' $(1)
	if test "${HADOOP_DEFAULT_TERASORT_SIZE}" != "50000000"; then \
		sed -i -e "s/^# export HADOOP_TERASORT_SIZE/export HADOOP_TERASORT_SIZE/g" $(1); \
	fi
	sed -i -e 's;DEFAULTJOBOUTPUTFILE;$(JOBOUTPUTFILE);g' $(1)
endef

define common-addition
	sed -i -e "/@HAMSTER_JOB_TYPES@/a @HAMSTER_JOB_TYPES_TEMP@/" $(1);
	sed -i -e "/@HAMSTER_JOB_TYPES@/{r ../templates/hamster-customizations-job-hadoop" -e "}" $(1);
	sed -i -e "/@HAMSTER_JOB_TYPES@/d" $(1);
	sed -i -e "s/@HAMSTER_JOB_TYPES_TEMP@/@HAMSTER_JOB_TYPES@/" $(1);
	sed -i -e "/@HAMSTER_TESTALL_TYPES@/a @HAMSTER_TESTALL_TYPES_TEMP@/" $(1);
	sed -i -e "/@HAMSTER_TESTALL_TYPES@/{r ../templates/hamster-customizations-testall-hadoop" -e "}" $(1);
	sed -i -e "/@HAMSTER_TESTALL_TYPES@/d" $(1);
	sed -i -e "s/@HAMSTER_TESTALL_TYPES_TEMP@/@HAMSTER_TESTALL_TYPES@/" $(1);
endef

define common-addition-end
	sed -i -e "/@HAMSTER_JOB_TYPES@/d" $(1)
	sed -i -e "/@HAMSTER_TESTALL_TYPES@/d" $(1)
endef

define common-additions
	$(call common-addition, $(1))
	$(call common-addition-end, $(1))
endef

define create-templates
	cp ../templates/hamster-customizations hamster-customizations

	sed -i -e "/@HAMSTER_NO_LOCAL_DIR@/{r ../templates/hamster-customizations-no-local-dir" -e "d}" hamster-customizations

	cp ../templates/hamster-hadoop-filesystem hamster-hadoop-filesystem

	sed -i -e "/@MODE_INTELLUSTRE@/{r ../templates/hamster-hadoop-filesystem-mode-intellustre" -e "d}" hamster-hadoop-filesystem
	sed -i -e "/@CONFIG_INTELLUSTRE@/{r ../templates/hamster-hadoop-filesystem-config-intellustre" -e "d}" hamster-hadoop-filesystem

	sed -i -e "/@MODE_HDFSOVERLUSTRE@/{r ../templates/hamster-hadoop-filesystem-mode-hdfsoverlustre" -e "d}" hamster-hadoop-filesystem
	sed -i -e "/@CONFIG_HDFSOVERLUSTRE@/{r ../templates/hamster-hadoop-filesystem-config-hdfsoverlustre" -e "d}" hamster-hadoop-filesystem

	sed -i -e "/@MODE_HDFSOVERNETWORKFS@/{r ../templates/hamster-hadoop-filesystem-mode-hdfsovernetworkfs" -e "d}" hamster-hadoop-filesystem
	sed -i -e "/@CONFIG_HDFSOVERNETWORKFS@/{r ../templates/hamster-hadoop-filesystem-config-hdfsovernetworkfs" -e "d}" hamster-hadoop-filesystem

	sed -i -e "/@HDFS_FEDERATION@/{r ../templates/hamster-hadoop-filesystem-hdfs-federation" -e "d}" hamster-hadoop-filesystem

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
		../templates/hamster-hadoop-job \
		../templates/hamster-hadoop-job-details \
		hamster-hadoop-filesystem \
		../templates/hamster-hadoop-mode-terasort \
		../templates/hamster-hadoop-mode-details \
		hamster-run-job-header \
		../templates/hamster-run-job-$(DIST) > $(HAMSTER)
	$(call common, ${HAMSTER})
	$(call common-additions, ${HAMSTER})
	sed -i -e "s/HAMSTER_JOB_TYPE=\"\(.*\)\"/HAMSTER_JOB_TYPE=\"hadoop\"/" $(HAMSTER)
	sed -i -e "s/HADOOP_SETUP=.*/HADOOP_SETUP=yes/" $(HAMSTER)
endef
