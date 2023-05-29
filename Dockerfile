FROM jenkins/jenkins:2.375.4-jdk11

ENV JENKINS_SLAVE_AGENT_PORT 50000

COPY ./plugins.txt /usr/share/jenkins/ref/plugins.txt
RUN cat /usr/share/jenkins/ref/plugins.txt | xargs jenkins-plugin-cli --verbose --plugins 