#!/bin/bash

PROCESS=$(ps -ef | grep "${GIT_SYNC_SUFFIX}" | grep -v 'grep')

#GIT_SYNC_JOB=/go/bin/git-sync.go
#GIT_SYNC_PROCESS=/Users/fabio.aparecido/Documents/workspace/DJONES-IBD/kubernetes/contrib/git-sync/git-sync.go

echo "Execute monitor"

if [ -z "${PROCESS}" ];then
    echo "[`date +'%m-%d-%Y %H:%M:%S'`] THERE IS NO PROCESS RUNNING, lets restart it"
    #output=$(/usr/local/go/bin/go run ${GIT_SYNC_JOB} 2>&1)

    echo "Environment variables"
    env
        
    echo "executing command [nohup /usr/local/go/bin/go run ${GIT_SYNC_JOB} &]"
    # nohup /usr/local/go/bin/go run ${GIT_SYNC_JOB} 1>>${LOG_FILE} 2&>1 &
    nohup /usr/local/go/bin/go run ${GIT_SYNC_JOB} &

    if [ $? -eq 0 ]; then
        echo "[`date +'%m-%d-%Y %H:%M:%S'`] ${GIT_SYNC_SUFFIX} process started WITH SUCCESS"
    else
        echo "FAIL to BOOT the ${GIT_SYNC_JOB} job"
        # how to send an alert or email from insid the docker container!!!
        # echo "The start of git-sync failed" | mail -s "git-sync [FAIL TO BOOT][`uname -r`][`date +'%m-%d-%Y %H:%M:%S'`]" fabio.aparecido@investors.com
    fi

else
    echo "[`date +'%m-%d-%Y %H:%M:%S'`] The git-sync process is running ok."
fi

#TODO cleanup the log file


nohup /usr/local/go/bin/go run /go/teste.go 1>>teste.log 2&>1 &