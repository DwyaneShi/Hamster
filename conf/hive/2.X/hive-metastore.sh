#!/bin/bash
export LD_LIBRARY_PATH=${HOME}/lib
PID=/tmp/hive_metastore_postgres.pid
PDATA_DIR=/tmp/hive_metastore_postgres/data
Hamster_metastore_start () {
    if [ -f "${PID}" ]
    then
        cat ${PID} | xargs -I {} kill -9 {}
    fi
    if [ "${HIVE_HOME}X" == "X" ]
    then
        echo "Please set up envvar HIVE_HOME"
        return 1
    fi
    POSTGRES_BIN=${HOME}/bin
    if [ -d "${PDATA_DIR}" ]
    then
        rm -rf ${PDATA_DIR}
    fi

    mkdir -p ${PDATA_DIR}

    ${POSTGRES_BIN}/initdb -D ${PDATA_DIR}
    echo "listen_addresses = '*'" >> ${PDATA_DIR}/postgresql.conf
    echo "standard_conforming_strings = off" >> ${PDATA_DIR}/postgresql.conf
    sed -i "s|^host.*||g" ${PDATA_DIR}/pg_hba.conf
    sed -i "s|^local.*||g" ${PDATA_DIR}/pg_hba.conf
    echo "host    all     all        0.0.0.0/0               trust" >> $PDATA_DIR/pg_hba.conf
    ${POSTGRES_BIN}/postgres -D $PDATA_DIR &
    sleep 5

    try=10
    num=$(ps aux | grep ${PDATA_DIR} | wc -l)
    while [ ${num} -lt 2 ] && [ ${try} -gt 0 ]
    do
        sleep 5
        num=$(ps aux | grep ${PDATA_DIR} | wc -l)
        try=$(expr ${try} - 1)
    done

    if [ ${try} -le 0 ]
    then
        echo "Starting metastore failed"
        return 1
    fi

    ps aux | grep ${PDATA_DIR} | grep -v "grep" | awk '{print $2}' > ${PID}

    ${POSTGRES_BIN}/psql -U $(whoami) postgres -f ${HIVE_CONF_DIR}/hive-metastore.sql -h localhost
}

Hamster_metastore_stop () {
    if [ -f ${PID} ]
    then
        cat ${PID} | xargs -I {} kill -9 {}
        rm -f ${PID}
    else
        killall -9 postgres
    fi
    rm -rf ${PDATA_DIR}
}
