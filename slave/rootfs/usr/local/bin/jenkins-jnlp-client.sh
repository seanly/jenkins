#!/usr/bin/env bash

# Usage jenkins-slave.sh [options] -url http://jenkins [SECRET] [AGENT_NAME]
# Optional environment variables :
# * JENKINS_TUNNEL : HOST:PORT for a tunnel to route TCP traffic to jenkins host, when jenkins can't be directly accessed over network
# * JENKINS_URL : alternate jenkins URL
# * JENKINS_SECRET : agent secret, if not set as an argument
# * JENKINS_AGENT_NAME : agent name, if not set as an argument

# if -tunnel is not provided try env vars
if [[ "$@" != *"-tunnel "* ]]; then
  if [ ! -z "$JENKINS_TUNNEL" ]; then
    TUNNEL="-tunnel $JENKINS_TUNNEL"
  fi
fi

if [ -n "$JENKINS_URL" ]; then
  URL="-url $JENKINS_URL"
fi

if [ -n "$JENKINS_NAME" ]; then
  JENKINS_AGENT_NAME="$JENKINS_NAME"
fi	

if [ -z "$JNLP_PROTOCOL_OPTS" ]; then
  echo "Warning: JnlpProtocol3 is disabled by default, use JNLP_PROTOCOL_OPTS to alter the behavior"
  JNLP_PROTOCOL_OPTS="-Dorg.jenkinsci.remoting.engine.JnlpProtocol3.disabled=true"
fi

# If both required options are defined, do not pass the parameters
OPT_JENKINS_SECRET=""
if [ -n "$JENKINS_SECRET" ]; then
  if [[ "$@" != *"${JENKINS_SECRET}"* ]]; then
    OPT_JENKINS_SECRET="${JENKINS_SECRET}"
  else
    echo "Warning: SECRET is defined twice in command-line arguments and the environment variable"
  fi
fi

OPT_JENKINS_AGENT_NAME=""
if [ -n "$JENKINS_AGENT_NAME" ]; then
  if [[ "$@" != *"${JENKINS_AGENT_NAME}"* ]]; then
    OPT_JENKINS_AGENT_NAME="${JENKINS_AGENT_NAME}"
  else
    echo "Warning: AGENT_NAME is defined twice in command-line arguments and the environment variable"
  fi
fi


_java_exec=${SLAVE_JAVA_EXEC:-/opt/java/openjdk/bin/java}
#It is fine it blows up for now since it should lead to an error anyway.
exec ${_java_exec} $JAVA_OPTS $JNLP_PROTOCOL_OPTS -cp /usr/share/jenkins/slave.jar hudson.remoting.jnlp.Main -headless $TUNNEL $URL $OPT_JENKINS_SECRET $OPT_JENKINS_AGENT_NAME "$@"
