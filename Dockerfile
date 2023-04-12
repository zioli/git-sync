FROM golang:1.17.1

ARG LOG_FILE=/logs/sync-sidecar.log
ARG ENV_FILE=/go/bin/.env.sh
ARG MONITOR_JOB=/go/bin/monitor.sh
ARG CRON_FILE=/etc/cron.d/monitor
ARG GIT_SYNC_JOB=/go/bin/git-sync.go

ARG SYNC_REPO=https://github.com/fzioli/git-sync-testing.git
ARG SYNC_DEST=/git
ARG SYNC_BRANCH=main 
ARG SYNC_REV=FETCH_HEAD 
ARG SYNC_WAIT=600 


ENV GIT_SYNC_REPO ${SYNC_REPO}     
ENV GIT_SYNC_DEST ${SYNC_DEST}     
ENV GIT_SYNC_BRANCH ${SYNC_BRANCH}      
ENV GIT_SYNC_REV ${SYNC_REV}      
ENV GIT_SYNC_WAIT ${SYNC_WAIT}    
ENV SHELL /bin/bash

VOLUME ["/git", "/logs"] 

# Installing GIT cli

RUN apt-get update
RUN apt-get -y install git
RUN apt-get -y install vim
RUN mkdir -p /go/bin/

# git-sync job
COPY git-sync.go ${GIT_SYNC_JOB}

RUN chmod 755 ${GIT_SYNC_JOB}


# Prepare the environment file and the cron file to execute the monitor script 
# the monitor script make sure the go job (git-sync) keeps running

# instaling CRON 
RUN apt-get update && apt-get -y install cron
COPY monitor.sh ${MONITOR_JOB}
RUN chmod 777 ${MONITOR_JOB}

# Prepare the environment variables
RUN echo "export GIT_SYNC_REPO=${SYNC_REPO}  " >> ${ENV_FILE}
RUN echo "export GIT_SYNC_DEST=${SYNC_DEST}  " >> ${ENV_FILE}
RUN echo "export GIT_SYNC_BRANCH=${SYNC_BRANCH}" >> ${ENV_FILE}
RUN echo "export GIT_SYNC_REV=${SYNC_REV}   " >> ${ENV_FILE}
RUN echo "export GIT_SYNC_WAIT=${SYNC_WAIT}  " >> ${ENV_FILE}
RUN echo "*/1 * * * * . ${ENV_FILE}; ${MONITOR_JOB} >> ${LOG_FILE} 2>&1\n"
RUN echo "*/1 * * * * . ${ENV_FILE}; ${MONITOR_JOB} >> ${LOG_FILE} 2>&1" >> $CRON_FILE
RUN echo "" >> $CRON_FILE

RUN chmod 0644 $CRON_FILE

RUN crontab $CRON_FILE


CMD cron && tail -f $LOG_FILE

#CMD go run /go/bin/git-sync.go >> $LOG_FILE 2>&1

# TODO Hay que agregar las instrucciones para agregar las credenciales de forma manual githig
# TODO hay que agregar un alerta o envio de email en caso de algun tipo de falla




