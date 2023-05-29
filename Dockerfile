FROM jenkins/jenkins:2.375.4-jdk11

ENV JENKINS_SLAVE_AGENT_PORT 50000

COPY ./plugins.2.375.txt /tmp/plugins.txt

RUN cat /tmp/plugins.txt | xargs jenkins-plugin-cli --verbose --plugins 
