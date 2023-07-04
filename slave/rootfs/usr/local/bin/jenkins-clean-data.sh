#!/usr/bin/env bash

function stop_sv {
  supervisorctl stop jenkins-slave
}

function start_sv {
  supervisorctl start jenkins-slave
}

function clean_data {
  # clean workspace files
  mkdir -p /home/jenkins/empty
	if [ -d /home/jenkins/workspace ]; then
	  rsync -av --delete /home/jenkins/empty/ /home/jenkins/workspace/
	fi

	if [ -d /home/jenkins/agent/workspace ]; then
    rsync -av --delete /home/jenkins/empty/ /home/jenkins/agent/workspace
	fi
    
  # clean images
  docker system prune -af
}

SLAVE_PID=$(supervisorctl pid jenkins-slave)

if [ "x$?" != "x0" ]; then
  echo "get pid fail."
  exit 1
fi

SLAVE_SUBPROC=$(ps -aef -o "ppid" | awk '{print $1}' |grep $SLAVE_PID)

if [ "x$SLAVE_SUBPROC" != "x" ]; then
  echo "current exists job run..."
  exit 1
fi

echo "no job run, start clean data..."

stop_sv

if [ -f /hooks/clean-data.sh ]; then
  bash /hooks/clean-data.sh
else 
  clean_data
fi
start_sv