#!/bin/bash
source /go/bin/.env.sh

PROCESS=$(ps -ef | grep 'exe/git-sync' | grep -v 'grep')
GIT_SYNC_PROCESS=/go/bin/git-sync.go
#GIT_SYNC_PROCESS=/Users/fabio.aparecido/Documents/workspace/DJONES-IBD/kubernetes/contrib/git-sync/git-sync.go
if [ -z "${PROCESS}" ];then
    echo "[`date +'%m-%d-%Y %H:%M:%S'`] THERE IS NO PROCESS RUNNING, lets restart it"
    output=$(/usr/local/go/bin/go run ${GIT_SYNC_PROCESS} 2>&1)
    if [ $? -eq 0 ]; then
        echo "${output}"
        echo "[`date +'%m-%d-%Y %H:%M:%S'`] GIT-SYNC process started WITH SUCCESS"
    else
        echo "FAIL to BOOT the git-sync job"
        echo "${output}" 
        echo "Send warning to {$EMAILS}"
        echo -e "The start of git-sync failed\n\noutput:\n${output}" 
        # how to send an alert or email from insid the docker container!!!
        # echo "The start of git-sync failed" | mail -s "git-sync [FAIL TO BOOT][`uname -r`][`date +'%m-%d-%Y %H:%M:%S'`]" fabio.aparecido@investors.com
    fi

else
    echo "[`date +'%m-%d-%Y %H:%M:%S'`] The git-sync process is running ok."
fi

#TODO cleanup the log file
