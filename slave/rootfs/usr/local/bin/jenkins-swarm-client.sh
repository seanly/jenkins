#!/usr/bin/env bash

# Usage swarm-client.sh [options] -url http://jenkins [APP_OPTS]
# Optional environment variables :
# * JENKINS_URL : alternate jenkins URL
# * JENKINS_SECRET : agent secret, if not set as an argument
# * JENKINS_AGENT_NAME : agent name, if not set as an argument

if [ -n "$JENKINS_URL" ]; then
  URL="-url $JENKINS_URL"
fi

if [ -n "$JENKINS_USR" ]; then
  APP_OPTS="-username $JENKINS_USR ${APP_OPTS}"
fi

if [ -n "$JENKINS_PSW" ]; then
  APP_OPTS="-password $JENKINS_PSW ${APP_OPTS}"
fi

if [ -n "$LABELS" ]; then
  APP_OPTS="-labels $LABELS ${APP_OPTS}"
fi

if [ -n "$EXECUTORS" ]; then
  APP_OPTS="-executors ${EXECUTORS} ${APP_OPTS}"
else
  APP_OPTS="-executors 2 ${APP_OPTS}"
fi

AGENT_NAME="-name ${HOSTNAME}"
APP_OPTS="-fsroot /home/jenkins -workDir /home/jenkins ${AGENT_NAME} ${APP_OPTS}"

#It is fine it blows up for now since it should lead to an error anyway.
exec java $JAVA_OPTS -jar /usr/share/jenkins/swarm-client.jar ${URL} ${APP_OPTS} "$@"
